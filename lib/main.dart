import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.black), 
        )
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(onPressed: null, child: Text("ผู้ป่วย")),
            TextButton(onPressed: null, child: Text("โพสต์")),
            TextButton(onPressed: null, child: Text("ออกจากระบบ")),
          ],
        ),
        backgroundColor: Color.fromRGBO(255, 211, 251, 1),
      ),
    );
  }
}
