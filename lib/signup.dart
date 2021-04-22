import 'dart:convert';
//import 'dart:io';

import 'package:flutter/material.dart';

//import 'package:toggle_bar/toggle_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

//import 'package:library_ms/loginscreen.dart';
import 'package:http/http.dart' as http;

String rollno, first_name, last_name, password, email;

class Signup extends StatefulWidget {
  static const String id = 'sign_up';

  Signup({Key key, this.title}) : super(key: key);

  final String title;

  @override
  SignupState createState() => SignupState();
}

class SignupState extends State<Signup> {
  //String name;

  Future<void> postdata(String rollno, String title, String last_name, String email, String password) async {
    var res = await http.post(
      'https://lmssuiit.pythonanywhere.com/api/signup',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          "rollno": rollno,
          "first_name": title,
          "last_name": last_name,
          "email": email,
          "password": password,
        },
      ),
    );
    print(res.body);

//  if (res.statusCode == 201) {
//    return Album.fromJson(jsonDecode(res.body));
//  } else {
//    throw Exception('Failed to create album.');
//  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
//      appBar: AppBar(
//        backgroundColor: Colors.deepPurple,
//        //title: Text(widget.title),
//      ),

      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.all(18.0),
//                child: ToggleBar(
//                  labels: labels,
//                  backgroundColor: Colors.grey[800],
//                  onSelectionUpdated: (index) =>
//                      setState(() => currentIndex = index),
//                ),
//              ),
                  ColorizeAnimatedTextKit(
                      onTap: () {
                        print("Tap Event");
                      },
                      text: ["WELCOME TO", "YOUR", "LIBRARY"],
                      textStyle: TextStyle(fontSize: 50.0, fontFamily: "Alfa"),
                      colors: [
                        Colors.deepPurple,
                        Colors.blue,
                        Colors.black,
                        Colors.red,
                      ],
                      textAlign: TextAlign.start,
                      alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                      ),
                  SizedBox(
                    height: 30.0,
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                    child: Card(
                      elevation: 30,
                      color: Colors.grey[800],
                      child: Container(
                        padding: EdgeInsets.all(25.0),
                        child: Column(
                          children: <Widget>[
                            Text('SIGN UP', style: GoogleFonts.spectralSC(fontSize: 30, color: Colors.white)),
//                        Container(
//                          decoration: BoxDecoration(
//                            color: Colors.deepPurple,
//                            borderRadius: BorderRadius.circular(10.0),
//                          ),
//                      child: Text('LOGIN',style: TextStyle(color: Colors.white,fontSize: 30),),
//                    ),
                            SizedBox(height: 20.0),
                            TextField(
                              onChanged: (value) {
                                first_name = value;
                                //Do something with the user input.
                              },
                              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your first name'),
                            ),
                            SizedBox(height: 10.0),
                            TextField(
                              onChanged: (value) {
                                last_name = value;
                                //Do something with the user input.
                              },
                              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your last name'),
                            ),
                            SizedBox(height: 10.0),
                            TextField(
                              onChanged: (value) {
                                rollno = value;
                                //Do something with the user input.
                              },
                              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your rollno.'),
                            ),
                            SizedBox(height: 10.0),
                            TextField(
                              obscureText: true,
                              onChanged: (value) {
                                password = value;
                                //Do something with the user input.
                              },
                              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
                            ),
                            SizedBox(height: 10.0),
                            TextField(
                              onChanged: (value) {
                                email = value;
                                //Do something with the user input.
                              },
                              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
                            ),

//      SizedBox(height: 10.0),
//
//    TextField(
//    onChanged: (value) {
//      password= value;
//    //Do something with the user input.
//    },
//    decoration: kTextFieldDecoration.copyWith(hintText: 'Set your password'),
//    ),
                            SizedBox(height: 20.0),
                            FloatingActionButton(
                              onPressed: () {
                                // Add your onPressed code here!
                                postdata(rollno, first_name, last_name, email, password);
                              },
                              child: Icon(Icons.login),
                              backgroundColor: Colors.deepPurple,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
//    Text('Thanks for signing up, we hope it will be helpful to you.'),
//    RaisedButton(onPressed: (){
//
//    },
//    child:Text('Sign up',style: GoogleFonts.spectralSC(fontSize: 30,color: Colors.white),),
//    color: Colors.deepPurple,
//    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter Roll Number',
  hintStyle: TextStyle(color: Colors.white),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurple, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  fillColor: Colors.deepPurple,
  filled: true,
);
