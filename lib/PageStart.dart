import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:appilcation_for_ncds/MainPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'services/shared_preferences_service.dart';
import 'package:appilcation_for_ncds/Register.dart';
import 'routes.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  final email = TextEditingController();
  final password = TextEditingController();
  final _loginForm = GlobalKey<FormState>();
  final PrefService _prefService = PrefService();
  var auth = FirebaseAuth.instance;

  // FirebaseAuth firebaseAuth = FirebaseAuth();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  void initState() {
    var getPassword;
    _prefService.readCache("email").then((value) async {
      if (value != null) {
        _prefService.readCache("password").then((value) {
          getPassword = value;
        });

        await Firebase.initializeApp();
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: value, password: getPassword)
            .then((value) async {
          var userData;
          await FirebaseFirestore.instance
              .collection("UserWeb")
              .doc(auth.currentUser.uid)
              .get()
              .then((value) {
            userData = value.data();
          });
          if (userData["status"] == true) {
            if (userData["role"] == "admin") {
              Navigator.pushNamed(context, '/adminmain');
            } else if (userData["role"] == "hospital") {
              Navigator.pushNamed(context, '/mainpage');
            } else if (userData["role"] == "medicalpersonnel") {
              Navigator.pushNamed(context, '/medicaMain');
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
        });
      } else {
        print("error");
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leading: Image(
            image: AssetImage("assets/icon/logo.png"),
          ),
          title: Text(
            "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img/doctor.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Card(
              child: SizedBox(
                height: 600,
                width: 500,
                child: Form(
                  key: _loginForm,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Image.asset(
                      //   "icon/login.png",
                      //   scale: 3,
                      // ),
                      Image(
                        image: AssetImage("assets/icon/login.png"),
                        height: 200,
                        width: 200,
                      ),
                      buildUserNameField(context),
                      buildPasswordField(context),
                      SizedBox(
                        height: 20,
                      ),
                      // TextButton(
                      //   onPressed: () {
                      //     // Navigator.push(context,
                      //     // MaterialPageRoute(builder: (context) => forgetpassword()));
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text("ลืมรหัสผ่าน",
                      //           style: TextStyle(
                      //             fontSize: 18,
                      //             color: Colors.black87,
                      //           )),
                      //       Text(" ต้องการเปลี่ยน",
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.w600,
                      //             fontSize: 18,
                      //             color: Colors.black,
                      //           ))
                      //     ],
                      //   ),
                      //   style: TextButton.styleFrom(
                      //     padding: const EdgeInsets.all(16.0),
                      //     primary: Colors.white,
                      //     textStyle: const TextStyle(fontSize: 20),
                      //   ),
                      // ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Padding(
                            child: buildButtonLogin(context),
                            padding: EdgeInsets.only(
                              left: 50,
                              right: 20,
                              // top: 40,
                            ),
                          ),
                          Padding(
                            child: buildButtonRegister(context),
                            padding: EdgeInsets.only(
                              left: 0,
                              right: 50,
                              // top: 40,
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
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
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
        // top: 5,
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
      padding: EdgeInsets.only(left: 50, right: 50, top: 10),
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

  buildButtonLogin(context) {
    return Container(
      width: 160,
      child: RaisedButton(
        // color: Colors.accents,
        hoverColor: Colors.grey.shade300,
        onPressed: () async {
          if (_loginForm.currentState.validate()) {
            await Firebase.initializeApp();
            await FirebaseAuth.instance
                .signInWithEmailAndPassword(
              email: email.text,
              password: password.text,
            )
                .whenComplete(() {
              _prefService.createCache("password", password.text);
              _prefService.createCache("email", email.text);
            }).then((value) async {
              var userData;
              await FirebaseFirestore.instance
                  .collection("UserWeb")
                  .doc(auth.currentUser.uid)
                  .get()
                  .then((value) {
                userData = value.data();
              });

              if (userData["status"] == true) {
                if (userData["role"] == "admin") {
                  Navigator.pushNamed(context, '/adminmain');
                } else if (userData["role"] == "hospital") {
                  Navigator.pushNamed(context, '/mainpage');
                } else if (userData["role"] == "medicalpersonnel") {
                  Navigator.pushNamed(context, '/medicaMain');
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
        color: Colors.greenAccent.shade700,
        child: Text(
          'เข้าสู่ระบบ',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
      ),
    );
  }

  buildButtonRegister(context) {
    return Container(
      width: 160,
      child: RaisedButton(
        // color: Colors.accents,
        hoverColor: Colors.grey.shade300,
        onPressed: () => Navigator.pushNamed(context, '/register'),
        child: Text(
          'สมัครสมาชิก',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        color: Colors.blueAccent.shade100,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
      ),
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
