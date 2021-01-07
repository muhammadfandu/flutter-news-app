import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/mainMenu.dart';
import 'package:news_app/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant/constantFile.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
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
    final response = await http.post(BaseUrl.login, body: {
      "email": email,
      "password": password,
    });
    final data = jsonDecode(response.body);

    int value = data['value'];
    String pesan = data['message'];
    String usernameAPI = data['username'];
    String emailAPI = data['email'];
    String idUserAPI = data['id_user'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, usernameAPI, emailAPI, idUserAPI);
      });
      print(pesan);
      // print(usernameAPI + " " + emailAPI + " " + idUserAPI);
    } else {
      print(pesan);
    }
  }

  savePref(int value, String username, String email, String idUser) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("username", username);
      preferences.setString("email", email);
      preferences.setString("id_user", idUser);
      preferences.commit();
    });
  }

  var value, usernamePref, emailPref, idUserPref;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;

      usernamePref = preferences.getString("username");
      emailPref = preferences.getString("email");
      idUserPref = preferences.getString("id_user");

      print(usernamePref + " " + emailPref + " " + idUserPref);
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
              padding: EdgeInsets.all(15.0),
              child: Form(
                key: _key,
                child: ListView(
                  children: <Widget>[
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
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Register()));
                      },
                      child: Text(
                        "Create New Account",
                        textAlign: TextAlign.center,
                      ),
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
