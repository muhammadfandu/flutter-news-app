import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/mainMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;

  String email, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
      // print("$email, $password");
    }
  }

  login() async {
    final response =
        await http.post("http://192.168.18.193/app_news/login.php", body: {
      "email": email,
      "password": password,
    });
    final data = jsonDecode(response.body);

    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value);
      });
      print(pesan);
    } else {
      print(pesan);
    }
  }

  savePref(int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
            appBar: AppBar(),
            body: Container(
              padding: EdgeInsets.all(10.0),
              child: Form(
                key: _key,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Please insert username";
                        }
                      },
                      onSaved: (e) => email = e,
                      decoration: InputDecoration(labelText: "Email"),
                    ),
                    TextFormField(
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
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
            ));
        break;
      case LoginStatus.signIn:
        return MainMenu(signOut);
        break;
    }
  }
}
