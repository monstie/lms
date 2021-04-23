import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:library_ms/loginscreen.dart';
//import 'package:library_ms/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:library_ms/booklist.dart';

class MainPage extends StatefulWidget {
  static const String id = 'dash_board';
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences sharedPreferences;

  final String url = 'https://lmssuiit.pythonanywhere.com/api/booklist/<str:rollno>';
  List data;
  List ret;

  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async {
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print(response.body);
    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      data = convertDataToJson['issued'];
      ret= convertDataToJson['returned'];
      print(data);
    });
    return "success";
  }

  @override
  void initState1() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print("token: ${sharedPreferences.getString("token")}");
    print("sessionid: ${sharedPreferences.getString("sessionid")}");
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => loginscreen()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("DASHBOARD", style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              sharedPreferences.clear();
              // sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => loginscreen()),
                  (Route<dynamic> route) => false);
            },
            child: Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            child: ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Card(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${data[index][0]}"),
                                  Text("${data[index][1]}"),
                                ],
                              ),
                              padding: const EdgeInsets.all(20.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),


          ),
          Container(
            child: ListView.builder(
                itemCount: ret == null ? 0 : ret.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Card(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${ret[index][0]}"),
                                  Text("${ret[index][1]}"),
                                ],
                              ),
                              padding: const EdgeInsets.all(20.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),


          ),

        ],
      ),


      drawer: Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text('Soumya Prakash Mishra'),
              accountEmail: Text('soumyamax619@gmail.com'),
              decoration: BoxDecoration(color: Colors.deepPurple),
            ),
            new ListTile(
              title: Text('Booklist',style: TextStyle(fontSize: 20.0),),
              onTap: () {
                Navigator.pushNamed(context, booklist.id);
//                PopupMenuButton(
//                  child: Center(child: Text('click here')),
//                  itemBuilder: (context) {
//                    return List.generate(5, (index) {
//                      return PopupMenuItem(
//                        child: Text('button no $index'),
//                      );
//                    });
//                  },
//                );
              },
            ),
            new ListTile(
        title: Text('Settings'),
        onTap: (){

    },
    )
          ],
        ),
      ),

    );
  }
}
