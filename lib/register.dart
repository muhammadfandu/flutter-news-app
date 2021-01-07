import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constant/constantFile.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _secureText = true;
  String username, email, password;
  final _key = new GlobalKey<FormState>();

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  void check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      register();
    }
  }

  save() async {
    final response = await http.post(
        "http://192.168.18.193/app_news/register.php",
        body: {"username": username, "email": email, "password": password});

    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];

    print(pesan);

    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

  register() async {
    final response = await http.post(BaseUrl.register,
        body: {"username": username, "email": email, "password": password});

    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];

    print(pesan);

    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.all(15),
            children: <Widget>[
              TextFormField(
                validator: (e) {
                  if (e.isEmpty) {
                    return "Please insert username";
                  }
                },
                onSaved: (e) => username = e,
                decoration: InputDecoration(labelText: "Username"),
              ),
              TextFormField(
                validator: (e) {
                  if (e.isEmpty) {
                    return "Please insert email";
                  }
                },
                onSaved: (e) => email = e,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextFormField(
                validator: (e) {
                  if (e.isEmpty) {
                    return "Please insert password";
                  }
                },
                obscureText: _secureText,
                onSaved: (e) => password = e,
                decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      onPressed: showHide(),
                      icon: Icon(_secureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                    )),
              ),
              MaterialButton(
                onPressed: () {
                  check();
                },
                child: Text(
                  "Register",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Already have an account? Login here",
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ));
  }
}
