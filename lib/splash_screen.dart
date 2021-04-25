import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_ms/dashboard.dart';
import 'package:library_ms/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splashScreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_)=>_startup());
    super.initState();
  }

  // Startup logic to decide where to go next: Login page or Dashboard
  void _startup() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String rollNo = sharedPreferences.getString("rollno");
    String password = sharedPreferences.getString("password");

    if(rollNo == null || rollNo.isEmpty){
      _redirectToLogin();
      return;
    }
    bool success = await _login(rollNo, password);
    if(success){
      _redirectToDashboard();
    }else{
      _redirectToLogin();
    }
  }

  // Calls login API and return true if gets response successfully otherwise returns false
  Future<bool> _login(String roll, String password) async {
    http.Response response;
    String data = jsonEncode({
      'rollno': roll,
      'password': password,
    });
    try {
      response = await http.post('https://lmssuiit.pythonanywhere.com/api/login', body: data);
    }catch(e){
      return false;
    }
    print("\n\nLogin API response ------------------------------------------");
    print("Body: ${response.body}");
    print("Status: ${response.statusCode}");
    print("Header: ${response.headers}\n\n");
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        String cookie = response.headers['set-cookie'];
        List<String> l = cookie.split("; ");
        l.forEach((field) async {
          List<String> a = field.split("=");
          if (a[0] == "csrftoken") {
            await sharedPreferences.setString("token", a[1]);
          } else if (a[0] == "SameSite" && a.length > 2) {
            await sharedPreferences.setString("sessionid", a[2]);
          }
        });
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  // Navigates user to Login page
  void _redirectToLogin(){
    Navigator.of(context).pushReplacementNamed(loginscreen.id);
  }

  // Navigates user to Dashboard page
  void _redirectToDashboard(){
    Navigator.of(context).pushReplacementNamed(MainPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
