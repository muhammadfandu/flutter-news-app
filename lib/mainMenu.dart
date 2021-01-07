import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'viewTabs/home.dart';
import 'viewTabs/news.dart';
import 'viewTabs/category.dart';
import 'viewTabs/profile.dart';

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String username = "", email = "", usernamePref, emailPref, idUserPref;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      usernamePref = preferences.getString("username");
      emailPref = preferences.getString("email");
      idUserPref = preferences.getString("id_user");

      print(usernamePref + " " + emailPref + " " + idUserPref);
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.lock_open),
                onPressed: () {
                  signOut();
                })
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            Home(),
            News(),
            Category(),
            Profile(),
          ],
        ),
        bottomNavigationBar: TabBar(
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home),
              text: "Home",
            ),
            Tab(
              icon: Icon(Icons.new_releases),
              text: "News",
            ),
            Tab(
              icon: Icon(Icons.category),
              text: "Category",
            ),
            Tab(
              icon: Icon(Icons.perm_contact_calendar),
              text: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
