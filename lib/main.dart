import 'package:api_blog_app/screens/home_screen.dart';
import 'package:api_blog_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = FlutterSecureStorage();
  Widget page = WelcomeScreen();
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: page,
    );
  }

  void checkLogin() async {
    String token = await storage.read(key: "token");
    if (token != null) {
      setState(() {
        page = HomeScreen();
      });
    } else {
      page = WelcomeScreen();
    }
  }
}
