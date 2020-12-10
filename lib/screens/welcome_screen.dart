import 'dart:convert';
import 'package:api_blog_app/screens/signin_screen.dart';
import 'package:api_blog_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  AnimationController _animationController1;
  Animation<Offset> animation1;
  AnimationController _animationController2;
  Animation<Offset> animation2;
  bool _isfbLogin = false;
  Map data;
  final facebookLogin = FacebookLogin();

  @override
  void initState() {
    super.initState();
    _animationController1 = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 1000,
      ),
    );
    animation1 = Tween<Offset>(
      begin: Offset(0.0, 8.0),
      end: Offset(0.0, 1.0),
    ).animate(
        CurvedAnimation(parent: _animationController1, curve: Curves.easeOut));

    _animationController2 = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 2500,
      ),
    );
    animation2 = Tween<Offset>(
      begin: Offset(0.0, 8.0),
      end: Offset(0.0, 1.0),
    ).animate(CurvedAnimation(
        parent: _animationController2, curve: Curves.easeInOut));
    _animationController1.forward();
    _animationController2.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController1.dispose();
    _animationController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
              Colors.white,
              Colors.yellow[500],
            ],
                begin: const FractionalOffset(0.0, 1.0),
                end: const FractionalOffset(0.0, 1.0),
                tileMode: TileMode.repeated)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: Column(
            children: <Widget>[
              SlideTransition(
                position: animation1,
                child: Text(
                  "API BLOG APP",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.10,
              ),
              SlideTransition(
                position: animation1,
                child: Text(
                  "Testing Api Calls Through This App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.08,
              ),
              SlideTransition(
                position: animation2,
                child: Container(
                  alignment: Alignment.center,
                  height: size.height * 0.06,
                  width: size.width * 0.70,
                  child: SignInButton(
                    Buttons.Google,
                    text: "Sign up with Google",
                    onPressed: () {},
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.035,
              ),
              SlideTransition(
                position: animation2,
                child: Container(
                  alignment: Alignment.center,
                  height: size.height * 0.06,
                  width: size.width * 0.70,
                  child: SignInButton(
                    Buttons.Facebook,
                    text: "Sign up with Facebook",
                    onPressed: () async {
                      final result = await facebookLogin.logIn(['email']);
                      switch (result.status) {
                        case FacebookLoginStatus.loggedIn:
                          final token = result.accessToken;
                          final response = await http.get(
                              "http://graph.facebook.com/v8.0/me?fields=name,picture,email&access_token=${token}");
                          final fbData = json.decode(response.body);
                          print(data);
                          setState(() {
                            _isfbLogin = true;
                            this.data = fbData;
                          });
                          break;
                        case FacebookLoginStatus.cancelledByUser:
                          setState(() {
                            _isfbLogin = false;
                          });
                          break;
                        case FacebookLoginStatus.error:
                          setState(() {
                            _isfbLogin = false;
                          });
                          break;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.035,
              ),
              SlideTransition(
                position: animation2,
                child: Container(
                  alignment: Alignment.center,
                  height: size.height * 0.06,
                  width: size.width * 0.70,
                  child: SignInButton(
                    Buttons.Email,
                    text: "Sign up with Email",
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.08,
              ),
              SlideTransition(
                position: animation2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Aleready Have an Account?",
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
                          builder: (context) => SignInScreen(),
                        ),
                      ),
                      child: Text(
                        "SIGN IN",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
