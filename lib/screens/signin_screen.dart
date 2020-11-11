import 'dart:collection';
import 'dart:convert';

import 'package:api_blog_app/screens/home_screen.dart';
import 'package:api_blog_app/screens/signup_screen.dart';
import 'package:api_blog_app/services/network_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final storage = new FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  final formKey = GlobalKey<FormState>();
  var _secureText = true;
  bool circular = false;
  bool validate = false;
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, Colors.yellow[200]],
                begin: const FractionalOffset(0.0, 1.0),
                end: const FractionalOffset(0.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.repeated),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "SIGN IN",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextFormField(
                    controller: _userNameController,
                    keyboardType: TextInputType.text,
                    validator: (String val) {
                      if (val.isEmpty) {
                        return "Name can not be Empty";
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orangeAccent),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Enter Username',
                      labelText: 'Username',
                      icon: Icon(Icons.person),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextFormField(
                    obscureText: _secureText,
                    controller: _userPasswordController,
                    keyboardType: TextInputType.text,
                    validator: (String val) {
                      if (val.isEmpty) {
                        return "Password can not be Empty";
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orangeAccent),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Enter Password',
                      labelText: 'Password',
                      suffixIcon: IconButton(
                          icon: Icon(_secureText
                              ? MaterialCommunityIcons.eye
                              : MaterialCommunityIcons.eye_off),
                          onPressed: () {
                            setState(() {
                              _secureText = !_secureText;
                            });
                          }),
                      icon: Icon(Icons.lock),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.01,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Click Here",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                circular
                    ? Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(vertical: 30),
                        width: size.width * 0.5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(29),
                          child: FlatButton(
                            color: Colors.yellow,
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                circular = true;
                              });
                              if (formKey.currentState.validate()) {
                                Map<String, String> data = {
                                  "username": _userNameController.text,
                                  "password": _userPasswordController.text,
                                };
                                print(data);
                                var response = await networkHandler.post(
                                    "/user/login", data);
                                if (response.statusCode == 200 ||
                                    response.statusCode == 201) {
                                  Map<String, dynamic> output =
                                      json.decode(response.body);
                                  print(output['token']);
                                  await storage.write(
                                      key: "token", value: output['token']);
                                  Fluttertoast.showToast(
                                      msg: "Logged In",
                                      textColor: Colors.black,
                                      backgroundColor: Colors.grey);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(),
                                      ),
                                      (route) => false);
                                  setState(() {
                                    validate = true;
                                    circular = false;
                                  });
                                } else {
                                  String output = json.decode(response.body);
                                  setState(() {
                                    Fluttertoast.showToast(
                                        msg: output,
                                        textColor: Colors.black,
                                        backgroundColor: Colors.grey);
                                    validate = false;
                                    circular = false;
                                  });
                                }
                              } else {
                                circular = false;
                              }
                            },
                          ),
                        ),
                      ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "New User?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.01,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      ),
                      child: Text(
                        "create an account",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
