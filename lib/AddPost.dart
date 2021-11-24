import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _AddPost();
  }
}

class _AddPost extends State<AddPost> {
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
        body: Container(
          child: Center(
            child: Card(
              child: SizedBox(
                height: 700,
                width: 1000,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          // child: buildButtonLogin(context),
                          padding: EdgeInsets.only(
                            left: 50,
                            right: 20,
                            top: 70,
                          ),
                        ),
                        Padding(
                          // child: buildButtonRegister(context),
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
          ),
        ),
          backgroundColor: Color.fromRGBO(255, 211, 251, 1),
      ),
    );
  }
}
