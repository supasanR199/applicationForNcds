import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _MainPage();
  }
}

class _MainPage extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
  //   return DefaultTabController(
  //     initialIndex: 1,
  //     length: 3,
  //     child: Scaffold(
  //       appBar: AppBar(
  //         title: Text(
  //           "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
  //           style: TextStyle(color: Colors.black),
  //         ),
  //         backgroundColor: Colors.white,
  //         actions: <Widget>[
  //           TabBar(tabs: [
  //             Tab(
  //               child: Text("ผู้ป่วย"),
  //             ),
  //             Tab(
  //               child: Text("โพสต์"),
  //             ),
  //             Tab(
  //               child: Text("ออกจากระบบ"),
  //             ),
  //           ])
  //           // TextButton(onPressed: null, child: Text("ผู้ป่วย")),
  //           // TextButton(onPressed: null, child: Text("โพสต์")),
  //           // TextButton(onPressed: null, child: Text("ออกจากระบบ")),
  //         ],
  //         // bottom: TabBar(
  //         //     tabs: <Widget>[
  //         //       Tab(
  //         //         icon: Icon(Icons.cloud_outlined),
  //         //       ),
  //         //       Tab(
  //         //         icon: Icon(Icons.beach_access_sharp),
  //         //       ),
  //         //       Tab(
  //         //         icon: Icon(Icons.brightness_5_sharp),
  //         //       ),
  //         //     ],
  //         //   ),
  //       ),
  //       body: Container(
  //         child: Center(
  //           child: Card(
  //             child: SizedBox(
  //               height: 700,
  //               width: 1000,
  //               child: ListView(
  //                 children: <Widget>[],
  //               ),
  //             ),
  //             //  margin: EdgeInsets.only(top: 100,bottom: 400,),
  //           ),
  //         ),
  //       ),
  //       backgroundColor: Color.fromRGBO(255, 211, 251, 1),
  //     ),
  //   );
  return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'ผู้ป่วย',
                icon: Icon(Icons.cloud_outlined),
              ),
              Tab(
                text: 'โพสต์',
                icon: Icon(Icons.beach_access_sharp),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: Text("It's cloudy here"),
            ),
            Center(
              child: Text("It's rainy here"),
            ),
          ],
        ),
      ),
    );
  }
}
