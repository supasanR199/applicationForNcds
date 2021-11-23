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
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            bottom: TabBar(
              indicatorColor: Color.fromRGBO(255, 211, 251, 1),
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
          body: TabBarView(
            children: <Widget>[
              Center(
                child: buildPatientPage(context),
              ),
              Center(
                child: buildPostPage(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPostPage(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 700,
        width: 1000,
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Text(
                  'โพสต์แนะนำ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  buildContentPost(context),
                  bulidButtonAddPost(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPatientPage(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 700,
        width: 1000,
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Text(
                  'ผู้ป่วย',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bulidButtonAddPost(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      color: Color.fromRGBO(255, 211, 251, 1),
      textColor: Colors.white,
      child: Icon(
        Icons.add,
        size: 24,
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
    );
  }

  Widget buildContentPost(BuildContext context) {
    return Card(
      color: Colors.amber,
      child: SizedBox(
        height: 200,
        width: 90,
      ),
    );
  }
}
