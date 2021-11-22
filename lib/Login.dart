import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: ListView(
        children: [],
      ),
      backgroundColor: Color.fromRGBO(255, 211, 251, 1),
    );
  }
}
