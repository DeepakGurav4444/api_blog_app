import 'package:api_blog_app/pages/add_profile.dart';
import 'package:api_blog_app/pages/home_page.dart';
import 'package:api_blog_app/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentState = 0;
  List<Widget> widgets1 = [HomePage(), AddProfile()];
  List<Widget> widgets2 = [HomePage(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://cdn.imgbin.com/16/20/6/imgbin-randy-orton-wwe-championship-cutter-randy-orton-UjWtcGEDCWEgv6i7Zz7jeU7av.jpg'),
              ),
              accountName: Text('Deepak Suresh Gurav'),
              accountEmail: Text('guravdeepak288@gmail.com'),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen())),
              leading: Icon(Icons.home),
              title: Text('Home'),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.view_list),
              title: Text('Categories'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(MaterialIcons.notifications), onPressed: null)
        ],
        title: Text(currentState == 0 ? "Home Page" : "Profile Page"),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          FloatingActionButton(onPressed: null, child: Icon(MaterialIcons.add)),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        shape: CircularNotchedRectangle(),
        notchMargin: size.height * 0.015,
        child: Container(
          height: size.height * 0.07,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  icon: Icon(MaterialIcons.home),
                  color: currentState == 1 ? Colors.white10 : Colors.white,
                  onPressed: () {
                    setState(() {
                      currentState = 0;
                    });
                  }),
              IconButton(
                  icon: Icon(MaterialIcons.person),
                  color: currentState == 0 ? Colors.white10 : Colors.white,
                  onPressed: () {
                    setState(() {
                      currentState = 1;
                    });
                  }),
            ],
          ),
        ),
      ),
      body: widgets1[currentState],
    );
  }
}
