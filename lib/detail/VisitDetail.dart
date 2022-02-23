import 'package:flutter/material.dart';

class VisitDetail extends StatelessWidget {
  var visit;
  VisitDetail({Key key, @required this.visit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Card(
            child: SizedBox(
              height: 700,
              width: 1000,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'บันทึกผลตรวจจากการลงพื้นที่ของอาสาสมัคร',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text("น้ำหนัก:"),
                              Text("ส่วนสูง:"),
                              Text("รอบเอว:"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text("น้ำหนัก:"),
                              Text("ส่วนสูง:"),
                              Text("รอบเอว:"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
