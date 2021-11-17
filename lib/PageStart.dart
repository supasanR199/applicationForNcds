import 'package:flutter/material.dart';
import 'package:appilcation_for_ncds/Register.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: Center(
            child: ListView(
              children: [
                buildUserNameField(context),
                buildPasswordField(context),
                Row(
                  children: [
                    buildButtonLogin(context),
                    buildButtonRegister(context),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Color.fromRGBO(255, 211, 251, 1),
      ),
    );
  }

  TextFormField buildUserNameField(context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'ชื่อผู้ใช้งาน',
        icon: Icon(Icons.people),
      ),
      validator: (value) => value.isEmpty ? 'Please fill in title' : null,
    );
  }

  TextFormField buildPasswordField(context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'รหัสผู้ใช้งาน',
        icon: Icon(Icons.password),
      ),
      validator: (value) => value.isEmpty ? 'Please fill in title' : null,
    );
  }

  RaisedButton buildButtonLogin(context) {
    return RaisedButton(
      // color: Colors.accents,
      onPressed: null,
      child: Text('เข้าสู้ระบบ'),
    );
  }

  RaisedButton buildButtonRegister(context) {
    return RaisedButton(
      // color: Colors.accents,
      onPressed: () => Navigator.pushNamed(context, '/register'),
      child: Text('สมัครสมาชิก'),
    );
  }
}
