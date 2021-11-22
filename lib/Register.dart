import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Color.fromRGBO(255, 211, 251, 1),
        body: Container(
          child: Center(
            child: Card(
              child: SizedBox(
                height: 700,
                width: 1000,
                child: ListView(
                  children: [
                    buildNameField(context),
                    buildSurNameField(context),
                    buildPositionField(context),
                    buildUserPhoneNumberField(context),
                    buildUserEmailField(context),
                    buildUserNameField(context),
                    buildPasswordField(context),
                    buildConfirmPasswordField(context),
                    Row(
                      children: [
                        Padding(
                          child: buildButtonRegister(context),
                          padding: EdgeInsets.only(
                            left: 50,
                            right: 20,
                            top: 70,
                            bottom: 50,
                          ),
                        ),
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
      ),
    );
  }
}

Padding buildNameField(context) {
  return Padding(
    padding: EdgeInsets.only(
      left: 50,
      right: 50,
      top: 70,
    ),
    child: TextFormField(
      decoration: InputDecoration(
        labelText: 'ชื่อ',
        icon: Icon(Icons.people),
      ),
      validator: (value) => value.isEmpty ? 'Please fill in title' : null,
    ),
  );
}

Padding buildSurNameField(context) {
  return Padding(
    padding: EdgeInsets.only(
      left: 50,
      right: 50,
      top: 70,
    ),
    child: TextFormField(
      decoration: InputDecoration(
        labelText: 'นามสกุล',
        icon: Icon(Icons.people),
      ),
      validator: (value) => value.isEmpty ? 'Please fill in title' : null,
    ),
  );
}

Padding buildPositionField(context) {
  return Padding(
    padding: EdgeInsets.only(
      left: 50,
      right: 50,
      top: 70,
    ),
    child: TextFormField(
      decoration: InputDecoration(
        labelText: 'ตำแหน่ง',
        icon: Icon(Icons.golf_course),
      ),
      validator: (value) => value.isEmpty ? 'Please fill in title' : null,
    ),
  );
}

Padding buildUserPhoneNumberField(context) {
  return Padding(
    padding: EdgeInsets.only(
      left: 50,
      right: 50,
      top: 70,
    ),
    child: TextFormField(
      decoration: InputDecoration(
        labelText: 'เบอร์โทรผู้ใช้งาน',
        icon: Icon(Icons.people),
      ),
      validator: (value) => value.isEmpty ? 'Please fill in title' : null,
    ),
  );
}

Padding buildUserEmailField(context) {
  return Padding(
    padding: EdgeInsets.only(
      left: 50,
      right: 50,
      top: 70,
    ),
    child: TextFormField(
      decoration: InputDecoration(
        labelText: 'อีเมลผู้ใช้งาน',
        icon: Icon(Icons.people),
      ),
      validator: (value) => value.isEmpty ? 'Please fill in title' : null,
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
      decoration: InputDecoration(
        labelText: 'ชื่อผู้ใช้งาน',
        icon: Icon(Icons.people),
      ),
      validator: (value) => value.isEmpty ? 'Please fill in title' : null,
    ),
  );
}

Padding buildPasswordField(context) {
  return Padding(
    padding: EdgeInsets.only(
      left: 50,
      right: 50,
      top: 70,
    ),
    child: TextFormField(
      decoration: InputDecoration(
        labelText: 'รหัสผู้ใช้งาน',
        icon: Icon(Icons.people),
      ),
      validator: (value) => value.isEmpty ? 'Please fill in title' : null,
    ),
  );
}

Padding buildConfirmPasswordField(context) {
  return Padding(
    padding: EdgeInsets.only(
      left: 50,
      right: 50,
      top: 70,
    ),
    child: TextFormField(
      decoration: InputDecoration(
        labelText: 'ยืนยันรหัสผู้ใช้งาน',
        icon: Icon(Icons.people),
      ),
      validator: (value) => value.isEmpty ? 'Please fill in title' : null,
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
