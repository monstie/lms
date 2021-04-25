import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:library_ms/dashboard.dart';
import 'package:library_ms/signup.dart';

//import 'package:library_ms/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginscreen extends StatefulWidget {
  static const String id = 'login_screen';

  loginscreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _loginscreenState createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.teal, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  headerSection(),
                  textSection(),
                  buttonSection(),
                ],
              ),
      ),
    );
  }

  signIn(String rollno, password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String data = jsonEncode({
      'rollno': rollno,
      'password': password,
    });
    var jsonResponse;
    http.Response response = await http
        .post('https://lmssuiit.pythonanywhere.com/api/login', body: data);
    print("Body: ${response.body}");
    print("Status: ${response.statusCode}");
    print("Header: ${response.headers}");
    if (response.statusCode == 200) {
      await sharedPreferences.setString("rollno", rollno);
      await sharedPreferences.setString("password", password);
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        // setState(() {
        //   _isLoading = false;
        // });
        String firstName = jsonResponse['first_name']??'Unknown';
        String lastName = jsonResponse['last_name']??'';
        String email = jsonResponse['email']??'';
        await sharedPreferences.setString("first_name", firstName);
        await sharedPreferences.setString("last_name", lastName);
        await sharedPreferences.setString("email", email);
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
        // await sharedPreferences.setString("token", response.headers['set-cookie']);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MainPage()),
          (Route<dynamic> route) => false,
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          RaisedButton(
            onPressed:
                rollController.text == "" || passwordController.text == ""
                    ? null
                    : () {
                        setState(() {
                          _isLoading = true;
                        });
                        signIn(rollController.text, passwordController.text);
                      },
            elevation: 0.0,
            color: Colors.teal,
            child: Text("Log In", style: TextStyle(color: Colors.white70)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
          SizedBox(
            height: 50,
          ),
          Text('If new, create an account here'),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, Signup.id);
            },
            child: Text(
              'Sign up',
              style: GoogleFonts.spectralSC(fontSize: 30, color: Colors.white),
            ),
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  final TextEditingController rollController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: rollController,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.edit, color: Colors.white),
              hintText: "Roll No.",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: passwordController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white),
              hintText: "Password",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Center(
        child: Row(
          children: [
            Image(
              image: AssetImage('images/ic.png'),
              height: 90,
              width: 50,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text("LIBRARY",
                style:
                    GoogleFonts.breeSerif(fontSize: 50, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
