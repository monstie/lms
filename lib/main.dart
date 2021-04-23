import 'package:flutter/material.dart';
import 'package:library_ms/booklist.dart';
import 'package:library_ms/loginscreen.dart';
import 'package:library_ms/signup.dart';
import 'package:library_ms/dashboard.dart';
void main() => runApp(libraryms());

class libraryms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: loginscreen(),
      initialRoute:loginscreen.id,
      routes:{
        loginscreen.id: (contest) => loginscreen(),
        Signup.id: (contest) => Signup(),
        MainPage.id: (contest) => MainPage(),
        booklist.id: (contest) => booklist(),
      } ,
    );
  }
}
