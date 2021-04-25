import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class booklist extends StatefulWidget {
  static const String id = 'booklist';

  @override
  _booklistState createState() => _booklistState();
}

class _booklistState extends State<booklist> {
  final String url = 'https://lmssuiit.pythonanywhere.com/api/booklist';
  // List data;

  // @override
  // void initState() {
  //   super.initState();
  //   getJsonData();
  //   getBooks()
  //       .then((value) => print(value.toString()))
  //       .catchError((error)=>print(error.toString()));
  // }

  Future<List<List<dynamic>>> getBooks() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");
    String sessionId = sharedPreferences.getString("sessionid");
    Map<String, String> header = {
      "Accept": "application/json",
      "Cookie": "csrftoken=$token;sessionid=$sessionId"
    };
    http.Response response;
    try{
      response = await http.get(Uri.encodeFull(url), headers: header);
    }catch(e){
      throw Exception("Failed to connect to internet");
    }
    print("Body: ${response.body}");
    print("Status: ${response.statusCode}");
    print("Header: ${response.headers}");
    Map<String, dynamic> res = jsonDecode(response.body);
    if(response.statusCode != 200){
      throw Exception(res["data"]??"Failed to fetch list of books");
    }
    if(!res["success"]){
      throw Exception(res["data"]??"Something went wrong");
    }
    List<List<dynamic>> l = [];
    (res["data"] as List<dynamic>).forEach((element) {
      l.add(element as List<dynamic>);
    });
    return l;
  }

  // Future<String> getJsonData() async {
  //   var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
  //   print(response.body);
  //   setState(() {
  //     var convertDataToJson = jsonDecode(response.body);
  //     data = convertDataToJson['data'];
  //     print(data);
  //   });
  //   return "success";
  // }

//
//   signIn(String rollno, password) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     String data = jsonEncode({
//       'rollno': rollno,
//       'password': password,
//     });
//     var jsonResponse = null;
//     http.Response response = await http.post('https://lmssuiit.pythonanywhere.com/api/booklist', body: data);
//     print("Body: ${response.body}");
//     print("Status: ${response.statusCode}");
//     print("Header: ${response.headers}");
//     if (response.statusCode == 200) {
//       jsonResponse = json.decode(response.body);
//       if (jsonResponse != null) {
//         // setState(() {
//         //   _isLoading = false;
//         // });
//         String cookie = response.headers['set-cookie'];
//         List<String> l = cookie.split("; ");
//         l.forEach((field) async {
//           List<String> a = field.split("=");
//           if (a[0] == "csrftoken") {
//             await sharedPreferences.setString("token", a[1]);
//           } else if (a[0] == "SameSite" && a.length > 2) {
//             await sharedPreferences.setString("sessionid", a[2]);
//           }
//         });
//         // await sharedPreferences.setString("token", response.headers['set-cookie']);
// //        Navigator.of(context).pushAndRemoveUntil(
// //          MaterialPageRoute(builder: (BuildContext context) => MainPage()),
// //              (Route<dynamic> route) => false,
// //        );
//       }
//     }
// //    else {
// //      setState(() {
// //        _isLoading = false;
// //      });
// //      print(response.body);
// //    }
//   }

  Widget getBooksListToDisplay(List<List<dynamic>> data){
    return ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Card(
                  color: Colors.teal,
                  elevation: 15.0,
                  shadowColor: Colors.teal,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Book: ${data[index][0]}",style: GoogleFonts.breeSerif(fontSize: 20, color: Colors.white)),
                        Text("Author: ${data[index][1]}",style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    padding: const EdgeInsets.all(20.0),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: Text('BOOKLIST'),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<List<dynamic>>>(
          future: getBooks(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasError){
                return Center(child: Text(snapshot.error.toString()));
              }
              return getBooksListToDisplay(snapshot.data);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      )
    );
  }
}
