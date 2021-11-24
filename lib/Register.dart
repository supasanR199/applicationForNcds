import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _Register();
  }
}

class _Register extends State<Register> {
  var _value = 'แพทย์';
  @override
  Widget build(BuildContext context) {
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
                  children: <Widget>[
                    buildNameField(context),
                    buildSurNameField(context),
                    buildPositionField(context),
                    buildUserPhoneNumberField(context),
                    buildSelectRold(context),
                    buildUserEmailField(context),
                    buildUserNameField(context),
                    buildPasswordField(context),
                    buildConfirmPasswordField(context),
                    Row(
                      children: <Widget>[
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
          ),
        ),
      ),
    );
  }

  Widget buildSelectRold(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: DropdownButton<String>(
        value: _value,
        items:
            <String>['แพทย์', 'รพสต.', 'อสม.', 'ผู้ป่วย'].map((String values) {
          return DropdownMenuItem<String>(
            value: values,
            child: Text(values),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _value = newValue;
            print(_value);
          });
        },
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

Widget buildPositionField(context) {
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

Widget buildUserPhoneNumberField(context) {
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

Widget buildUserEmailField(context) {
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

Widget buildUserNameField(context) {
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

Widget buildPasswordField(context) {
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

Widget buildConfirmPasswordField(context) {
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

Widget buildButtonRegister(context) {
  return RaisedButton(
    // color: Colors.accents,
    onPressed: () => Navigator.pushNamed(context, '/mainpage'),
    child: Text('สมัครสมาชิก'),
    color: Colors.green,
    padding: EdgeInsets.all(20),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4))),
  );
}

class SelectRole extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _SelectRold();
  }
}

class _SelectRold extends State<SelectRole> {
  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'One';
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
