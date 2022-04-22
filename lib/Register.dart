import 'dart:convert';
import 'dart:html';

import 'package:appilcation_for_ncds/models/RegisterModels.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _Register();
  }
}

class _Register extends State<Register> {
  var _value = 'บุคลากรแพทย์';
  final name = TextEditingController();
  final surname = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final roles = TextEditingController();
  final phonenumber = TextEditingController();
  final _registerForm = GlobalKey<FormState>();
  RegisterModels _registerModels = RegisterModels();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.grey.shade200,
        body: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage("img/doctor.jpg"),
          //   fit: BoxFit.cover,
          // ),
        ),           
          child: Center(
            child: Card(
              child: SizedBox(
                height: 700,
                width: 1000,
                child: Form(
                  key: _registerForm,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 700,
                        width: 350,
                       child : Container(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             SizedBox(height: 40,),
                             Image.asset("icon/icon-hospital.png",scale: 4,),
                           ],
                         ),
                                decoration: BoxDecoration(
                                image: DecorationImage(
                                image: AssetImage("img/register.jpg"),
                                fit: BoxFit.cover,
                                
                              ),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)
                              ),
                            ), 
                      ),

                      ),
                      // SizedBox(width: 40,),
                      Expanded(
                        child: Container(
                        child: Column(
                          children: [
                        SizedBox(height: 20,),
                        Text("สมัครสมาชิก",style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),
                        SizedBox(height: 20,),
                        buildNameField(context),
                        SizedBox(height: 20,),
                        buildSurNameField(context),
                        SizedBox(height: 20,),
                        buildUserPhoneNumberField(context),
                        SizedBox(height: 20,),
                        buildUserEmailField(context),
                        SizedBox(height: 20,),
                        buildPasswordField(context),
                        SizedBox(height: 20,),
                        buildConfirmPasswordField(context),
                        SizedBox(height: 20,),     
                        buildSelectRold(context),
                        SizedBox(height: 40,), 
                        Container(
                        child: buildButtonRegister(context),
                        ),
                        //     Row(children: [
                        //       Column(
                        //         children: [
                        // buildNameField(context),
                        // SizedBox(height: 20,),
                        // buildSurNameField(context),
                        // SizedBox(height: 20,),
                        // buildUserPhoneNumberField(context),
                        // SizedBox(height: 20,),
                        // buildUserEmailField(context),
                        // SizedBox(height: 20,),
                        // buildPasswordField(context),
                        // SizedBox(height: 20,),
                        // buildConfirmPasswordField(context),     
                        // // buildSelectRold(context),                                
                        //         ],
                        //       ),
                        // // SizedBox(width: 50,),
                        
                        // //       Column(
                        // //         children: [
                        // // buildUserEmailField(context),
                        // // SizedBox(height: 20,),
                        // // buildPasswordField(context),
                        // // SizedBox(height: 20,),
                        // // buildConfirmPasswordField(context),                                
                        // //         ],
                        // //       )
                        //     ],),
                                        
                          ],
                        ),
                        ),
                      )

                    ],
                  ),                  
                  // child: ListView(
                  //   children: <Widget>[
                  //     buildNameField(context),
                  //     buildSurNameField(context),
                  //     buildUserPhoneNumberField(context),
                  //     buildSelectRold(context),
                  //     buildUserEmailField(context),
                  //     buildPasswordField(context),
                  //     buildConfirmPasswordField(context),
                  //     Row(
                  //       children: <Widget>[
                  //         Padding(
                  //           child: buildButtonRegister(context),
                  //           padding: EdgeInsets.only(
                  //             left: 50,
                  //             right: 20,
                  //             top: 70,
                  //             bottom: 50,
                  //           ),
                  //         ),
                  //       ],
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //     ),
                  //   ],
                  // ),
                ),
              ),
              //  margin: EdgeInsets.only(top: 100,bottom: 400,),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
              Radius.circular(10),
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSelectRold(context) {
    return Container(
      // padding: EdgeInsets.only(
      //   left: 50,
      //   right: 50,
      //   top: 70,
      // ),
      width: 300,
      child: DropdownButtonFormField<String>(
        value: _value,
        decoration: InputDecoration(
          labelText: 'หน้าที่การใช้งาน',
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),),                  
          // icon: Icon(Icons.people),
        ),
        items: <String>['บุคลากรแพทย์', 'รพสต.'].map((String values) {
          return DropdownMenuItem<String>(
            value: values,
            child: Text(values),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _value = newValue;
            _registerModels.roles = _value;
          });
        },
        validator: (value) {
          if (value.isNotEmpty) {
            if (value.toString() == 'รพสต.') {
              _registerModels.roles = 'hospital';
            } else if (value.toString() == 'บุคลากรแพทย์') {
              _registerModels.roles = 'medicalpersonnel';
            }
          }
          if (value.isEmpty || value.toString() == null) {
            return 'กรุณาเลือกหน้าที่การใช้งาน';
          }
          return null;
        },
      ),
    );
  }

  Widget buildNameField(context) {
    return Container(
      width: 300,
      child: TextFormField(
        obscureText: true,
        onChanged: (value) {
          _registerModels.name = value;
        },
        controller: name,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'ชื่อ',
          enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),),
          // icon: Icon(Icons.people),
        ),
        validator: (value) => value.isEmpty ? 'ระบุชื่อ' : null,
        
      ),
    );
  }

  Widget buildSurNameField(context) {
    return Container(
      width: 300,
      child: TextFormField(
        onChanged: (value) {
          _registerModels.surname = value;
        },
        controller: surname,
        decoration: InputDecoration(
          labelText: 'นามสกุล',
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),),            
          // icon: Icon(Icons.people),
        ),
        validator: (value) => value.isEmpty ? 'ระบุนามสกุล' : null,
      ),
    );
  }

// Widget buildPositionField(context) {
//   return Padding(
//     padding: EdgeInsets.only(
//       left: 50,
//       right: 50,
//       top: 70,
//     ),
//     child: TextFormField(
//       decoration: InputDecoration(
//         labelText: 'ตำแหน่ง',
//         icon: Icon(Icons.golf_course),
//       ),
//       validator: (value) => value.isEmpty ? 'Please fill in title' : null,
//     ),
//   );
// }

  Widget buildUserPhoneNumberField(context) {
    return Container(
      width: 300,
      child: TextFormField(
          onSaved: (value) {
            _registerModels.phoneNumber = value;
          },
          controller: phonenumber,
          decoration: InputDecoration(
            labelText: 'เบอร์โทรผู้ใช้งาน',
            // icon: Icon(Icons.people),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),),              
          ),
          validator: (value) {
            if (value.isEmpty) {
              return "ระบุเบอร์โทร";
            } else if (num.tryParse(value) == null) {
              return "ระบุตัวเลขเท่านั้น";
            } else if (value.length < 10 || value.length > 10) {
              return "ระบุเบอร์โทร10หลัก";
            }
            return null;
          }),
    );
  }

  Widget buildUserEmailField(context) {
    return Container(
      width: 300,
      child: TextFormField(
        onSaved: (value) {
          _registerModels.email = value;
        },
        controller: email,
        decoration: InputDecoration(
          labelText: 'อีเมลผู้ใช้งาน',
          // icon: Icon(Icons.people),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),),          
        ),
        validator: (value) {
          if (!validateEmail(value) || value.isEmpty) {
            // print("check");
            return "รูปแบบอีเมลไม่ถูกต้อง";
          }
          return null;
        },
      ),
    );
  }

// Widget buildUserNameField(context) {
//   return Padding(
//     padding: EdgeInsets.only(
//       left: 50,
//       right: 50,
//       top: 70,
//     ),
//     child: TextFormField(
//       decoration: InputDecoration(
//         labelText: 'ชื่อผู้ใช้งาน',
//         icon: Icon(Icons.people),
//       ),
//       validator: (value) => value.isEmpty ? 'Please fill in title' : null,
//     ),
//   );
// }

  Widget buildPasswordField(context) {
    return Container(
      width: 300,
      child: TextFormField(
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          onChanged: (value) {
            _registerModels.password = value;
          },
          controller: password,
          decoration: InputDecoration(
            labelText: 'รหัสผู้ใช้งาน',
            // icon: Icon(Icons.people),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),),             
          ),
          validator: (value) {
            if (value.isEmpty) {
              return "ระบุรหัสผ่าน";
            } else if (value.length < 6) {
              return "รหัสต้องไม่น้อยกว่า 6 ตัวอักษร";
            }
            return null;
          }),
    );
  }

  Widget buildConfirmPasswordField(context) {
    return Container(
      width: 300,
      child: TextFormField(
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: 'ยืนยันรหัสผู้ใช้งาน',
          // icon: Icon(Icons.people),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),),           
        ),
        validator: (value) {
          if (value.isEmpty) {
            return "ยืนยันรหัสผ่าน";
          } else if (value != _registerModels.password) {
            return "ยืนยันรหัสผ่านไม่ตรงกับรหัสผ่านด้านบน";
          }
          return null;
        },
      ),
    );
  }

  Widget buildButtonRegister(context) {
    return Container(
      width: 300,
      child: RaisedButton(
        // color: Colors.accents,
        hoverColor: Colors.grey.shade300,
        onPressed: () async {
          if (_registerForm.currentState.validate()) {
            _registerForm.currentState.save();
            try {
              await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: _registerModels.email,
                      password: _registerModels.password)
                  .then((value) {
                FirebaseFirestore.instance
                    .collection('UserWeb')
                    .doc(value.user.uid)
                    .set({
                  "email": _registerModels.email,
                  "Firstname": _registerModels.name,
                  "Lastname": _registerModels.surname,
                  "phonenumber": _registerModels.phoneNumber,
                  "role": _registerModels.roles,
                  "status": false
                });
              });
              Navigator.pushNamed(context, '/');
            } on FirebaseAuthException catch (e) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      aletLogin(context, e.toString()));
            }
          }
          // _registerModels.name  = name.text;
          // print(_registerModels.name);
        },
        child: Text('สมัครสมาชิก',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
        color: Colors.greenAccent.shade700,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
      ),
    );
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
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
