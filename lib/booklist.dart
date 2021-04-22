import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class booklist extends StatefulWidget {
  static const String id= 'booklist';

  @override
  _booklistState createState() => _booklistState();
}

class _booklistState extends State<booklist> {
  final String url='https://lmssuiit.pythonanywhere.com/api/booklist';
  List data;

  @override
  void initState(){
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async{
    var response = await http.get(
      Uri.encodeFull(url),
      headers: {"Accept":"application/json"}
    );
    print(response.body);
    setState(() {
      var convertDataToJson= jsonDecode(response.body);
      data = convertDataToJson['books'];
    });
    return "success";

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BOOKLIST'),
      ),
      body: new ListView.builder(
          itemCount: data ==null?0:data.length,
          itemBuilder: (BuildContext context, int index){
            return new Container(
              child: new Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Card(
                      child: new Container(
                        child: new Text(data[index]['name']['pub']),
                        padding: const EdgeInsets.all(20.0),
                      ),
                    )
                  ],
                ),
              ),
            );

          }
      )
    );
  }
}
