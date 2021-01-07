import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/constant/color_constant.dart';
import 'package:news_app/constant/constantFile.dart';
import 'package:news_app/model/newsModel.dart';
import 'package:news_app/viewTabs/addNews.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  String username = "", email = "", idUser = "";

  final list = new List<NewsModel>();
  var loading = false;

  Future _getData() async {
    list.clear();
    setState(() {
      loading = true;
    });

    final response = await http.get(BaseUrl.getNews);

    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new NewsModel(
            api['id_news'],
            api['image'],
            api['title'],
            api['content'],
            api['description'],
            api['date_news'],
            api['id_user'],
            api['username'],
            api['email']);
        list.add(ab);
      });

      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
    _getData();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      email = preferences.getString("email");
      idUser = preferences.getString("id_user");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddNews()));
          },
          child: Icon(Icons.add),
        ),
        body: RefreshIndicator(
            onRefresh: () {
              _getData();
            },
            child: loading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    padding: EdgeInsets.all(16),
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final x = list[i];
                        return Container(
                            child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  BaseUrl.getImage + x.image,
                                  width: 150,
                                  height: 120,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      x.title,
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          color: mTitleColor,
                                          fontSize: 20),
                                    ),
                                    // Text(x.content),
                                    // Text(x.description),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(x.date_news),
                                  ],
                                )),
                                IconButton(
                                    icon: Icon(Icons.edit), onPressed: () {}),
                                IconButton(
                                    icon: Icon(Icons.delete), onPressed: () {}),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ));
                      },
                    ))));
  }
}
