import 'package:flutter/material.dart';
import 'package:library_ms/booklist.dart';
import 'package:library_ms/loginscreen.dart';
import 'package:library_ms/signup.dart';
import 'package:library_ms/dashboard.dart';
import 'package:library_ms/splash_screen.dart';
import 'package:get/get.dart';


void main() => runApp(libraryms());

class libraryms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
      ),
      debugShowCheckedModeBanner: false,
      home: loginscreen(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        loginscreen.id: (contest) => loginscreen(),
        Signup.id: (contest) => Signup(),
        MainPage.id: (contest) => MainPage(),
        booklist.id: (contest) => booklist(),
      },
    );
  }
}
