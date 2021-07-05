import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:library_ms/loginscreen.dart';

//import 'package:library_ms/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:library_ms/booklist.dart';
// import 'package:simple_coverflow/simple_coverflow.dart';
import 'main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:drawer_swipe/drawer_swipe.dart';

class MainPage extends StatefulWidget {
  static const String id = 'dash_board';
  final bool wantsTouchId=true;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
final LocalAuthentication auth= LocalAuthentication();
final storage = new FlutterSecureStorage();

  @override
  void initState(){
    super.initState();
    if (widget.wantsTouchId){
      auth.authenticate(
        localizedReason: 'Authenticate to use for signing in next time'
      );
    }
  }

void authenticate() async {
  final canCheck = await auth.canCheckBiometrics;

  if (canCheck) {
    List<BiometricType> availableBiometrics =
    await auth.getAvailableBiometrics();

    if (Platform.isIOS) {
      if (availableBiometrics.contains(BiometricType.face)) {
        // Face ID.
         final authenticated= await auth.authenticateWithBiometrics(
            localizedReason: 'Enable Face ID to sign in more easily');
//        if (authenticated) {
//          storage.write(key: 'email', value: widget.rollno);
//          storage.write(key: 'password', value: widget.password);
//          storage.write(key: 'usingBiometric', value: 'true');
//        }
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        // Touch ID.
      }
    }
  } else {
    print('cant check');
  }
}

  SharedPreferences sharedPreferences;
  final String url = 'https://lmssuiit.pythonanywhere.com/api/booklist';

  Future<List<List<dynamic>>> getBooks() async {
    if (sharedPreferences == null) sharedPreferences = await SharedPreferences.getInstance();
    http.Response response;
    String token = sharedPreferences.getString("token");
    String sessionId = sharedPreferences.getString("sessionid");
    String rollNo = sharedPreferences.getString("rollno");
    Map<String, String> header = {
      "Accept": "application/json",
      "Cookie": "csrftoken=$token;sessionid=$sessionId"
    };
    String bookUrl = "$url/$rollNo";
    try {
      response = await http.get(Uri.encodeFull(bookUrl), headers: header);
    } catch (e) {
      throw Exception("Failed to connect to internet");
    }
    print("Body: ${response.body}");
    print("Status: ${response.statusCode}");
    print("Header: ${response.headers}");
    Map<String, dynamic> res = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(res["data"] ?? "Failed to fetch list of books");
    }
    if (!res["success"]) {
      throw Exception(res["data"] ?? "Something went wrong");
    }
    return [res['issues'], res['returned']];
  }

  Widget getBooksListToDisplay(List<List<dynamic>> data) {
    List issues = data[0];
    List returned = data[1];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Text("Issues:",
                  style: GoogleFonts.dancingScript(
                      fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold))),
          Expanded(
            child: ListView.builder(
              itemCount: issues == null ? 0 : issues.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Card(
                    color: Colors.teal,
                    elevation: 15.0,
                    shadowColor: Colors.teal,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Book: ${issues[index][0]}",
                                style: GoogleFonts.breeSerif(fontSize: 20, color: Colors.white)),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Issued date: ${issues[index][1]} ",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Due date: ${issues[index][2]}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
              child: Text("Returned:",
                  style: GoogleFonts.dancingScript(
                      fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold))),
          Expanded(
            child: ListView.builder(
              itemCount: returned == null ? 0 : returned.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Card(
                    color: Colors.teal,
                    elevation: 15.0,
                    shadowColor: Colors.teal,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Book: ${returned[index][0]}",
                                style: GoogleFonts.breeSerif(fontSize: 20, color: Colors.white)),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text("Issued date: ${returned[index][1]} ",
                                style: TextStyle(color: Colors.white)),
                            Text("Returned date: ${returned[index][2]}",
                                style: TextStyle(color: Colors.white)),
                            Text("Due date: ${returned[index][3]} ", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }




  Future<String> getRollNumber() async {
    if(sharedPreferences == null) sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get("rollno");
  }
  @override

  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("DASHBOARD", style: TextStyle(color: Colors.white))),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Issues',
              ),
              Tab(
                text: 'Returned',              ),
            ],
          ),
          backgroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backwardsCompatibility: false,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                sharedPreferences.clear();
                // sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (BuildContext context) => loginscreen()),
                        (Route<dynamic> route) => false);
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
        ),


        body: const TabBarView(

          children: <Widget>[
            Center(
              child: Text("issues...."),
      ),
            Center(
              child: Text("returned...."),
            ),
          ],
        ),


//        body:
//
//        Padding(
//          padding: const EdgeInsets.symmetric(horizontal: 12),
//          child: FutureBuilder<List<List<dynamic>>>(
//            future: getBooks(),
//            builder: (context, snapshot) {
//              if (snapshot.connectionState == ConnectionState.done) {
//                if (snapshot.hasError) {
//                  return Center(child: Text(snapshot.error.toString()));
//                }
//                return getBooksListToDisplay(snapshot.data);
//              }
//              return Center(
//                child: CircularProgressIndicator(),
//              );
//            },
//          ),
//        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: FutureBuilder<String>(
                  future: getRollNumber(),
                  builder: (context, snapshot){
                    if(snapshot.hasData) return Text(snapshot.data);
                    return Container();
                  },
                ),
                accountEmail: Container(),
                decoration: BoxDecoration(color: Colors.teal),
              ),
              ListTile(
                title: Text(
                  'Booklist',
                  style: TextStyle(fontSize: 20.0),
                ),
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
              ListTile(
                title: Text(
                  'Dashboard',
                  style: TextStyle(fontSize: 20.0),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Settings', style: TextStyle(fontSize: 20.0)),
                onTap: () {},
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: TextButton(child:Text('Text',style: TextStyle(fontSize: 20.0,color: Colors.white),),onPressed:(){ Get.isDarkMode
      ? Get.changeTheme(ThemeData.light())
          : Get.changeTheme(ThemeData.dark());}),
              ),
      //            //SizedBox(height: 30,),
              Align(
                alignment: Alignment.bottomLeft,
                child: FlatButton(

//              backgroundColor: Colors.black,
                    child: Text('About', style: TextStyle(fontSize: 20.0)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 60.0),
                              child: AlertDialog(
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text('About us',
                                          style: GoogleFonts.breeSerif(fontSize: 30, color: Colors.black)),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      CircleAvatar(
                                        backgroundImage: AssetImage('images/ts.jpg'),
                                        radius: 80,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text('Developers:',
                                          style: GoogleFonts.breeSerif(fontSize: 30, color: Colors.black)),
                                      Text('Soumya Prakash Mishra',
                                          style: GoogleFonts.dancingScript(
                                              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
                                      Text('Tanshit Ur Rahman',
                                          style: GoogleFonts.dancingScript(
                                              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 80,
                                      ),
                                      //Icon(Icons.copyright,size: 8,),
                                      Text(
                                        'Copyright.All rights reserved. Version:0.0.1',
                                        style: TextStyle(fontSize: 8),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}