import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:library_ms/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


//class dashboard extends StatefulWidget {
//  static const String id= 'dash_board';
//
//  @override
//  dashboardState createState() => dashboardState();
//}
//
//class dashboardState extends State<dashboard> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Dashboard'),
//        backgroundColor: Colors.deepPurple,
//      ) ,
//      drawer: new Drawer(
//        child: new ListView(
//          children: <Widget>[
//            new UserAccountsDrawerHeader(
//              accountName: Text('Soumya Prakash Mishra'),
//              accountEmail: Text('soumyamax619@gmail.com'),
//              decoration: BoxDecoration(
//                color: Colors.deepPurple
//              ),
//
//
//            ),
//            new ListTile(
//              title: Text('Booklist'),
//              onTap: (){
//
////                PopupMenuButton(
////                  child: Center(child: Text('click here')),
////                  itemBuilder: (context) {
////                    return List.generate(5, (index) {
////                      return PopupMenuItem(
////                        child: Text('button no $index'),
////                      );
////                    });
////                  },
////                );
//              },
//
//            )
//          ],
//        ),
//      ),
//      resizeToAvoidBottomPadding: false,
//      //backgroundColor: Theme.of(context).primaryColor.,
//      //drawer: AppDrawer(),
//
//    );
//  }
//}



class MainPage extends StatefulWidget {
  static const String id= 'dash_board';
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => loginscreen()), (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Code Land", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              sharedPreferences.clear();
             // sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => loginscreen()), (Route<dynamic> route) => false);
            },
            child: Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Center(child: Text("Main Page")),
      drawer: Drawer(),
    );
  }
}