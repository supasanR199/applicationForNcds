import 'package:flutter/material.dart';
class MedicaMain extends StatefulWidget {
  @override
  _MedicaMainState createState() => _MedicaMainState();
}

class _MedicaMainState extends State<MedicaMain> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
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
                  text: 'ข้อมูลผู้ป่วย',
                ),
                Tab(
                  text: 'ออกกำลังกาย',
                ),
                Tab(
                  text: 'อาหาร',
                ),
                Tab(
                  text: 'อารมณ์',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Center(
                  // child: buildPatientPage(context),
                  ),
              Center(
                  // child: buildPostPage(context),
                  ),
              Center(
                  // child: buildPatientPage(context),
                  ),
              Center(
                  // child: buildPostPage(context),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}