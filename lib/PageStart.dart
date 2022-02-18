import 'dart:html';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appilcation_for_ncds/Register.dart';

class StartPage extends StatelessWidget {
  final email = TextEditingController();
  final password = TextEditingController();
  final _loginForm = GlobalKey<FormState>();

  // FirebaseAuth firebaseAuth = FirebaseAuth();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
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
                child: Form(
                  key: _loginForm,
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
              ),
              //  margin: EdgeInsets.only(top: 100,bottom: 400,),
            ),
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
        validator: (value) => value.isEmpty ? 'ระบุอีเมล' : null,
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
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        controller: password,
        decoration: InputDecoration(
          labelText: 'รหัสผู้ใช้งาน',
          icon: Icon(Icons.password),
        ),
        validator: (value) => value.isEmpty ? 'ระบุรหัสผ่าน' : null,
      ),
    );
  }

  RaisedButton buildButtonLogin(context) {
    return RaisedButton(
      // color: Colors.accents,
      onPressed: () async {
        if (_loginForm.currentState.validate()) {
          await Firebase.initializeApp();
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(
            email: email.text,
            password: password.text,
          )
              .then((value) async {
            var auth = FirebaseAuth.instance;
            var userData;
            await FirebaseFirestore.instance
                .collection("UserWeb")
                .doc(auth.currentUser.uid)
                .get()
                .then((value) {
              userData = value.data();
              print(value);
            });
            print(userData["role"]);
            print(userData["status"]);
            if (userData["status"] == true) {
              if (userData["role"] == "admin") {
                Navigator.pushNamed(context, '/adminmain');
              } else if (userData["role"] == "hospital") {
                Navigator.pushNamed(context, '/mainpage');
              } else if (userData["role"] == "medicalpersonnel") {
                Navigator.pushNamed(context, '/mainpage');
              }
            } else if (userData["status"] == false) {
              showDialog(
                      context: context,
                      builder: (BuildContext context) => aletLogin(
                          context, "ท่านยังไม่ได้รับอนุมัติให้เข้าสู้ระบบ"))
                  .then((value) async {
                await FirebaseAuth.instance.signOut();
              });
            }

            // Navigator.pushNamed(context, '/mainpage');
          }).catchError((e) {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    aletLogin(context, e.toString()));
            Navigator.pushNamed(context, '/');
          });
        }
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
