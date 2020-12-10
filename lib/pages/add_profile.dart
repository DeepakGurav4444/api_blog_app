import 'package:flutter/material.dart';

class AddProfile extends StatefulWidget {
  @override
  _AddProfileState createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
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
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 30),
          width: size.width * 0.5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(29),
            child: FlatButton(
              color: Colors.yellow,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Text(
                "Add Profile",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}
