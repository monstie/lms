//import 'dart:io';
//
//import 'package:flutter/material.dart';
//import 'package:toggle_bar/toggle_bar.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:animated_text_kit/animated_text_kit.dart';
//import 'package:library_ms/signup.dart';
//import 'dashboard.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
//import 'package:shared_preferences/shared_preferences.dart';
//
//
//
//
//
//class loginscreen extends StatefulWidget {
//  static const String id= 'login_screen';
//  loginscreen({Key key, this.title}) : super(key: key);
//
//  final String title;
//  @override
//  loginscreenState createState() => loginscreenState();
//}
//
//class loginscreenState extends State<loginscreen> {
//
//
//
//  List<String> labels = ["LOGIN", "SIGN UP"];
//  int currentIndex = 0;
//  ApiResponse _apiResponse = new ApiResponse();
//
//  Future<ApiResponse> authenticateUser(String rollno, String password) async {
//    ApiResponse _apiResponse = new ApiResponse();
//
//    try {
//      final response = await http.post('${'https://lmssuiit.pythonanywhere.com/api/login'}user/login', body: {
//        'rollno': rollno,
//        'password': password,
//      });
//
//      switch (response.statusCode) {
//        case 200:
//          _apiResponse.Data = User.fromJson(json.decode(response.body));
//          break;
//        case 401:
//          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
//          break;
//        default:
//          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
//          break;
//      }
//    } on SocketException {
//      _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
//    }
//    return _apiResponse;
//  }
//
//
//  Future<ApiResponse> getUserDetails(String userId) async {
//    ApiResponse _apiResponse = new ApiResponse();
//    try {
//      final response = await http.get('${'https://lmssuiit.pythonanywhere.com/api/login'}user/$rollno');
//
//      switch (response.statusCode) {
//        case 200:
//          _apiResponse.Data = User.fromJson(json.decode(response.body));
//          break;
//        case 401:
//          print((_apiResponse.ApiError as ApiError).error);
//          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
//          break;
//        default:
//          print((_apiResponse.ApiError as ApiError).error);
//          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
//          break;
//      }
//    } on SocketException {
//      _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
//    }
//    return _apiResponse;
//  }
//
//
//
//  void _handleSubmitted() async {
//
//    final FormState form = _formKey.currentState();
//    if (!form.validate()) {
//      print(Text('invalid'));
//      //showInSnackBar('Please fix the errors in red before submitting.');
//    } else {
//      form.save();
//      _apiResponse = await authenticateUser(_rollno, _password);
//      if ((_apiResponse.ApiError as ApiError) == null) {
//        _saveAndRedirectToHome();
//      } else {
//       // showInSnackBar((_apiResponse.ApiError as ApiError).error);
//      }
//    }
//  }
//
//  void _saveAndRedirectToHome() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    await prefs.setString("rollno", (_apiResponse.Data as User).rollno);
//    Navigator.pushNamedAndRemoveUntil(
//        context, '/home', ModalRoute.withName('/home'),
//        arguments: (_apiResponse.Data as User));
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//
//      resizeToAvoidBottomPadding: false,
////      appBar: AppBar(
////        backgroundColor: Colors.deepPurple,
////        //title: Text(widget.title),
////      ),
//
//      body: Container(
//        decoration: BoxDecoration(image: DecorationImage(
//          image: AssetImage("images/bg.jpg"),
//          fit: BoxFit.cover,
//        ),),
//        child: Center(
//          child:
//          Padding(
//            padding: const EdgeInsets.symmetric(vertical: 80.0),
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: <Widget>[
////              Padding(
////                padding: const EdgeInsets.all(18.0),
////                child: ToggleBar(
////                  labels: labels,
////                  backgroundColor: Colors.grey[800],
////                  onSelectionUpdated: (index) =>
////                      setState(() => currentIndex = index),
////                ),
////              ),
//                ColorizeAnimatedTextKit(
//                    onTap: () {
//                      print("Tap Event");
//                    },
//                    text: [
//                      "WELCOME TO",
//                      "YOUR",
//                      "LIBRARY"
//
//                    ],
//                    textStyle:
//                    TextStyle(
//                        fontSize: 50.0,
//
//                        fontFamily: "Alfa"
//                    ),
//
//
//                    colors: [
//                      Colors.deepPurple,
//                      Colors.blue,
//                      Colors.black,
//                      Colors.red,
//                    ],
//                    textAlign: TextAlign.start,
//                    alignment: AlignmentDirectional.topStart // or Alignment.topLeft
//                ),
//                SizedBox(
//                  height: 30.0,
//                ),
//
//                Padding(
//                  padding: const EdgeInsets.fromLTRB(25.0,0,25.0,0),
//                  child: Card(
//                    elevation: 30,
//
//                    color: Colors.grey[800],
//                    child: Container(
//                      padding: EdgeInsets.all(25.0),
//                      child: Column(
//                        children: <Widget>[
//                          Text('LOGIN',style: GoogleFonts.spectralSC(fontSize: 30,color: Colors.white)),
////                        Container(
////                          decoration: BoxDecoration(
////                            color: Colors.deepPurple,
////                            borderRadius: BorderRadius.circular(10.0),
////                          ),
////                      child: Text('LOGIN',style: TextStyle(color: Colors.white,fontSize: 30),),
////                    ),
//                          SizedBox(height: 30.0),
//                          TextField(style: TextStyle(color: Colors.white),
//                            onChanged: (value) {
//                              //Do something with the user input.
//                            },
//                            decoration: kTextFieldDecoration,
//
//
//                          ),
//                          SizedBox(height: 10.0),
//
//                          TextField(
//                            onChanged: (value) {
//                              //Do something with the user input.
//                            },
//                            decoration: kTextFieldDecoration.copyWith(hintText: 'Enter password'),
//                          ),
//                          SizedBox(height: 20.0),
//                          FloatingActionButton(
//                            onPressed: () {
//                              // Add your onPressed code here!
//                              //Navigator.pushNamed(context, dashboard.id);
//                              _handleSubmitted;
//
//                            },
//                            child: Icon(Icons.login),
//                            backgroundColor: Colors.deepPurple,
//                          ),
//                        ],
//                      ),
//
//                    ),
//                  ),
//                ),
//            SizedBox(
//            height: 50,
//          ),
//                Text('If new, create an account here'),
//                RaisedButton(onPressed: (){
//                  Navigator.pushNamed(context, Signup.id);
//                },
//                child:Text('Sign up',style: GoogleFonts.spectralSC(fontSize: 30,color: Colors.white),),
//                  color: Colors.deepPurple,
//                )
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}

//
//class User {
//  /*
//  This class encapsulates the json response from the api
//  {
//      'rollno': '1908789',
//      'firstname': firstname,
//      'name': 'Peter Clarke',
//      'lastLogin': "23 March 2020 03:34 PM",
//      'email': 'x7uytx@mundanecode.com'
//  }
//  */
//  String _rollno;
//  String _firstname;
//  String _lastname;
//  String _password;
//  String _email;
//
//   constructorUser(
//      {String rollno,
//  String firstname,
//  String lastname,
//  String password,
//  String email,})
//{
//this._rollno = rollno;
//this._firstname = firstname;
//this._lastname = lastname;
//this._password = password;
//this._email = email;
//}
//
//// Properties
//String get rollno => _rollno;
//set rollno(String rollno) => _rollno = rollno;
//String get firstname => _firstname;
//set firstname(String firstname) => _firstname = firstname;
//String get lastname => _lastname;
//set lastname(String lastname) => _lastname = lastname;
//String get password => _password;
//set lastLogin(String lastLogin) => _password = password;
//String get email => _email;
//set email(String email) => _email = email;
//
//// create the user object from json input
//User.fromJson(Map<String, dynamic> json) {
//_rollno = json['rollno'];
//_firstname = json['firstname'];
//_lastname = json['lastname'];
//_password = json['password'];
//_email = json['email'];
//}
//
//// exports to json
//Map<String, dynamic> toJson() {
//  final Map<String, dynamic> data = new Map<String, dynamic>();
//  data['rollno'] = this._rollno;
//  data['firstname'] = this._firstname;
//  data['lastname'] = this._lastname;
//  data['password'] = this._password;
//  data['email'] = this._email;
//  return data;
//}
//
//}
//
//class ApiError {
//  String _error;
//
//  ApiError({String error}) {
//    this._error = error;
//  }
//
//  String get error => _error;
//  set error(String error) => _error = error;
//
//  ApiError.fromJson(Map<String, dynamic> json) {
//    _error = json['error'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['error'] = this._error;
//    return data;
//  }
//}
//
//
//
//class ApiResponse {
//  // _data will hold any response converted into
//  // its own object. For example user.
//  Object _data;
//  // _apiError will hold the error object
//  Object _apiError;
//
//  Object get Data => _data;
//  set Data(Object data) => _data = data;
//
//  Object get ApiError => _apiError as Object;
//  set ApiError(Object error) => _apiError = error;
//}
//
//




import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:library_ms/dashboard.dart';
//import 'package:library_ms/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginscreen extends StatefulWidget {
  static const String id= 'login_screen';
 loginscreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _loginscreenState createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Colors.purple],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
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
    Map data = {
      'rollno': rollno,
      'password': password,
    };
    var jsonResponse = null;
    var response = await http.post('https://lmssuiit.pythonanywhere.com/api/login', body: data);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
      }
    }
    else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed: emailController.text == "" || passwordController.text == "" ? null : () {
          setState(() {
            _isLoading = true;
          });
          signIn(emailController.text, passwordController.text);
        },
        elevation: 0.0,
        color: Colors.purple,
        child: Text("Sign In", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            cursorColor: Colors.black,

            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "Email",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
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
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Password",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
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
      child: Text("LIBRARY",
          style: TextStyle(
              color: Colors.white70,
              fontSize: 40.0,
              fontWeight: FontWeight.bold)),
    );
  }
}