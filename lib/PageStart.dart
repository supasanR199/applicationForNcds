import 'dart:html';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appilcation_for_ncds/Register.dart';

class StartPage extends StatelessWidget {
  final email = TextEditingController();
  final password = TextEditingController();
  // FirebaseAuth firebaseAuth = FirebaseAuth();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
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
            child: Card(
              child: SizedBox(
                height: 700,
                width: 1000,
                child: Column(
                  children: [
                    buildUserNameField(context),
                    buildPasswordField(context),
                    Row(
                      children: [
                        Padding(
                          child: buildButtonLogin(context),
                          padding: EdgeInsets.only(
                            left: 50,
                            right: 20,
                            top: 70,
                          ),
                        ),
                        Padding(
                          child: buildButtonRegister(context),
                          padding: EdgeInsets.only(
                            left: 0,
                            right: 50,
                            top: 70,
                          ),
                        ),
                        // buildButtonLogin(context),
                        // buildButtonRegister(context),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                ),
              ),
              //  margin: EdgeInsets.only(top: 100,bottom: 400,),
            ),
            // child: ListView(
            //   children: [
            //     buildUserNameField(context),
            //     buildPasswordField(context),
            //     Row(
            //       children: [
            //         buildButtonLogin(context),
            //         buildButtonRegister(context),
            //       ],
            //       mainAxisAlignment: MainAxisAlignment.center,
            //     ),
            //   ],
            // ),
          ),
        ),
        backgroundColor: Color.fromRGBO(255, 211, 251, 1),
      ),
    );
  }

  Padding buildUserNameField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        controller: email,
        decoration: InputDecoration(
          labelText: 'ชื่อผู้ใช้งาน',
          icon: Icon(Icons.people),
        ),
        validator: (value) => value.isEmpty ? 'Please fill in title' : null,
      ),
    );
    // TextFormField(
    //   decoration: InputDecoration(
    //     labelText: 'ชื่อผู้ใช้งาน',
    //     icon: Icon(Icons.people),
    //   ),
    //   validator: (value) => value.isEmpty ? 'Please fill in title' : null,
    // );
  }

  Padding buildPasswordField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
      ),
      child: TextFormField(
        controller: password,
        decoration: InputDecoration(
          labelText: 'รหัสผู้ใช้งาน',
          icon: Icon(Icons.password),
        ),
        validator: (value) => value.isEmpty ? 'Please fill in title' : null,
      ),
    );
  }

  RaisedButton buildButtonLogin(context) {
    return RaisedButton(
      // color: Colors.accents,
      onPressed: () async {
        // await Firebase.initializeApp();
        // await FirebaseAuth.instance
        //     .signInWithEmailAndPassword(
        //   email: email.text,
        //   password: password.text,
        // )
        //     .then((value) {
        //   Navigator.pushNamed(context, '/mainpage');
        //   print("login");
        // }).catchError((e) {
        //   showDialog(
        //       context: context, 
        //       builder:(BuildContext context) => aletLogin(context, e.toString()));
        // });
        Navigator.pushNamed(context, '/mainpage');
      },
      color: Colors.white,
      child: Text('เข้าสู้ระบบ'),
      padding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
    );
  }

  RaisedButton buildButtonRegister(context) {
    return RaisedButton(
      // color: Colors.accents,
      onPressed: () => Navigator.pushNamed(context, '/register'),
      child: Text('สมัครสมาชิก'),
      color: Colors.green,
      padding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
    );
  }

  Widget aletLogin(context, String e) {
    return AlertDialog(
      title: const Text('แจ้งเตือน'),
      content: Text(e),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
