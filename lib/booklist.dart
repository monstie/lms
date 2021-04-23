import 'package:flutter/material.dart';
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
  List data;

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
      data = convertDataToJson['data'];
      print(data);
    });
    return "success";
  }

  signIn(String rollno, password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String data = jsonEncode({
      'rollno': rollno,
      'password': password,
    });
    var jsonResponse = null;
    http.Response response = await http.post('https://lmssuiit.pythonanywhere.com/api/booklist', body: data);
    print("Body: ${response.body}");
    print("Status: ${response.statusCode}");
    print("Header: ${response.headers}");
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        // setState(() {
        //   _isLoading = false;
        // });
        String cookie = response.headers['set-cookie'];
        List<String> l = cookie.split("; ");
        l.forEach((field) async {
          List<String> a = field.split("=");
          if(a[0] == "csrftoken"){
            await sharedPreferences.setString("token", a[1]);
          }else if(a[0] == "SameSite" && a.length>2){
            await sharedPreferences.setString("sessionid", a[2]);
          }
        });
        // await sharedPreferences.setString("token", response.headers['set-cookie']);
//        Navigator.of(context).pushAndRemoveUntil(
//          MaterialPageRoute(builder: (BuildContext context) => MainPage()),
//              (Route<dynamic> route) => false,
//        );
      }
    }
//    else {
//      setState(() {
//        _isLoading = false;
//      });
//      print(response.body);
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BOOKLIST'),
          backgroundColor: Colors.deepPurple,
        ),
        body:




        ListView.builder(
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
            }));
  }
}
