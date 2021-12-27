import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _MainPage();
  }
}

class _MainPage extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            actions: [
              actionMenu(),
            ],
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
                Tab(
                  text: 'ยืนยันการสมัครสมาชิกผู้ป่วย/อสม.',
                  icon: Icon(Icons.cloud_outlined),
                ),
                 Tab(
                  text: 'อสม.',
                  icon: Icon(Icons.cloud_outlined),
                ),
                Tab(
                  text: 'แชทพูดคุย',
                  icon: Icon(Icons.cloud_outlined),
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
              Center(
                child: buildAcceptPage(context),
              ),
               Center(
                child: buildVolunteerPage(context),
              ),
              Center(
                child: buildChat(context),
              ),
            ],
          ),
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
                children: [
                  buildContentPatient(context),
                ],
              ),
            )
          ],
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
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: bulidButtonAddPost(context),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAcceptPage(BuildContext context) {
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
                  'ยืนยันการสมัครสมาชิกผู้ป่วย/อสม./บุคลากรทางการแพทย์',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  buildContentAccept(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildVolunteerPage(BuildContext context) {
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
                  'อสม.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  buildContentPatient(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bulidButtonAddPost(BuildContext context) {
    return MaterialButton(
      onPressed: () => Navigator.pushNamed(context, '/addpost'),
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

  Widget buildContentAccept(BuildContext context) {
    return Card(
      color: Colors.amber,
      child: SizedBox(
        height: 200,
        width: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                // color: Colors.accents,
                onPressed: () => Navigator.pushNamed(context, '/patientmain'),
                child: Text('ยืนยัน'),
                color: Colors.green,
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                // color: Colors.accents,
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text('ยกเลิก'),
                color: Colors.redAccent,
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildContentPatient(BuildContext context) {
    return Card(
      color: Colors.amber,
      child: SizedBox(
        height: 200,
        width: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                // color: Colors.accents,
                onPressed: () => Navigator.pushNamed(context, '/patientmain'),
                child: Text('ข้อมูล'),
                color: Colors.green,
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                // color: Colors.accents,
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text('สมัครสมาชิก'),
                color: Colors.green,
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildChat(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.amber,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text('col1'),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  color: Colors.red,
                  child: Text('col1'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget actionMenu() {
    return PopupMenuButton(
        icon: Icon(Icons.more_vert),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Item 1'),
                ),
              ),
            ]);
  }
}
