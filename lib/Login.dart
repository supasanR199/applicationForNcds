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
        // actions: <Widget>[
        //   TabBar(tabs: [
        //     Tab(child: Text("ผู้ป่วย"),),
        //     Tab(child: Text("โพสต์"),),
        //     Tab(child:  Text("ออกจากระบบ"),),
        //   ])
        //   // TextButton(onPressed: null, child: Text("ผู้ป่วย")),
        //   // TextButton(onPressed: null, child: Text("โพสต์")),
        //   // TextButton(onPressed: null, child: Text("ออกจากระบบ")),
        // ],
        bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.cloud_outlined),
              ),
              Tab(
                icon: Icon(Icons.beach_access_sharp),
              ),
              Tab(
                icon: Icon(Icons.brightness_5_sharp),
              ),
            ],
          ),
      ),
      body: Container(
        child: Center(
          child: Card(
            child: SizedBox(
              height: 700,
              width: 1000,
              child: ListView(
                children: <Widget>[],
              ),
            ),
            //  margin: EdgeInsets.only(top: 100,bottom: 400,),
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(255, 211, 251, 1),
    );
  }
}
