import 'dart:convert';

import 'package:api_blog_app/screens/home_screen.dart';
import 'package:api_blog_app/services/network_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();
  var _secureText = true;
  bool circular = false;
  bool validate = false;
  bool userAlereadyExist = false;
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userPasswordController = TextEditingController();
  TextEditingController _userEmailController = TextEditingController();
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
                    "Sign Up with Email",
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
                        } else if (userAlereadyExist) {
                          setState(() {
                            circular = false;
                          });
                          return "User Aleready Exist Try Different";
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
                        helperText: "Password Should be >=8",
                        icon: Icon(Icons.lock),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: TextFormField(
                      controller: _userEmailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (String val) {
                        if (val.isEmpty) {
                          return "Email can not be Empty";
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orangeAccent),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: 'Enter Email',
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                      ),
                    ),
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
                                "SIGN UP",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  circular = true;
                                });
                                await checkUser();
                                if (formKey.currentState.validate() &&
                                    validate) {
                                  Map<String, String> data = {
                                    "username": _userNameController.text,
                                    "password": _userPasswordController.text,
                                    "email": _userEmailController.text
                                  };
                                  print(data);
                                  var responseRegister = await networkHandler
                                      .post("/user/register", data);
                                  Fluttertoast.showToast(
                                      msg: "User Registered",
                                      textColor: Colors.black,
                                      backgroundColor: Colors.grey);
                                  if (responseRegister.statusCode == 200 ||
                                      responseRegister.statusCode == 201) {
                                    Map<String, String> data = {
                                      "username": _userNameController.text,
                                      "password": _userPasswordController.text
                                    };
                                    var responseLogin = await networkHandler
                                        .post("/user/login", data);
                                    if (responseLogin.statusCode == 200 ||
                                        responseLogin.statusCode == 201) {
                                      Map<String, dynamic> output =
                                          json.decode(responseLogin.body);
                                      print(output["token"]);
                                      await storage.write(
                                          key: "token", value: output["token"]);
                                      setState(() {
                                        circular = false;
                                      });
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen()),
                                          (route) => false);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Network Error",
                                          textColor: Colors.black,
                                          backgroundColor: Colors.grey);
                                    }
                                  }
                                } else {
                                  setState(() {
                                    circular = false;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  checkUser() async {
    var response = await networkHandler
        .get("/user/checkusername/${_userNameController.text}");
    if (response["Status"]) {
      setState(() {
        print("User Aleredy Exist");
        validate = false;
        userAlereadyExist = true;
      });
    } else {
      setState(() {
        print("User Not Exist");
        validate = true;
        userAlereadyExist = false;
      });
    }
  }
}
