import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PatientMain extends StatefulWidget {
  @override
  Map<String, dynamic> patienData;
  PatientMain({
    Key key,
    @required this.patienData,
  }) : super(key: key);
  _PatientMainState createState() => _PatientMainState();
}

class _PatientMainState extends State<PatientMain> {
  @override
  Widget build(BuildContext context) {
    String test;
    print(widget.patienData["NCDs"]);
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
                child: buildPatientPage(context),
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

  Widget buildPatientPage(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 700,
        width: 1000,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'ข้อมูลผู้ป่วย',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "ข้อมูลส่วนตัว",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("ชื่อ : " + widget.patienData["Firstname"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text("นามสกุล : " + widget.patienData["Lastname"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("วันเกิด : " +
                            convertDateTimeDisplay(widget.patienData["Birthday"]
                                .toDate()
                                .toString())),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "อายุ : " +
                              calAge(convertDateTimeDisplay(widget
                                      .patienData["Birthday"]
                                      .toDate()
                                      .toString()) +
                                  "ปี"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "โทรศัพท์ : " + widget.patienData["Phonenumber"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("เพศ : " + widget.patienData["Gender"]),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "ข้อมูลสุขภาพ",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("ส่วนสูง : " + widget.patienData["Height"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("น้ำหนัก : " + widget.patienData["Weight"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text("รอบอก : " + widget.patienData["Waistline"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "กรุ๊ปเลือด : " + widget.patienData["Bloodgroup"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("แพ้ยา : " +
                            checkDrugAllergy(widget.patienData["DrugAllergy"])),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "โรค : " + listNcds(widget.patienData["NCDs"]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buttonLabTest(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String calAge(String birthDayString) {
    String pattern = "dd-MM-yyyy";
    DateTime birthDay = DateFormat(pattern).parse(birthDayString);
    DateTime today = DateTime.now();
    var yeardiff = today.year - birthDay.year;
    // print(birthDay);
    // print(today.year);
    // print(birthDay.year);

    // var daydiff = today.day - birthDay.day;

    return yeardiff.toString();
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  String checkDrugAllergy(String str) {
    if (str.isEmpty) {
      return "ไม่มีการแพ้ยา";
    } else {
      return str;
    }
  }

  String listNcds(List ncds) {
    List ncdsListThai = [];
    for (var i = 0; i < ncds.length; i++) {
      print(ncds[i]);
      if (ncds[i] == "fat") {
        ncdsListThai.add("โรคอ้วน");
      } else if (ncds[i] == "diabetes") {
        ncdsListThai.add("โรคเบาหวาน");
      } else if (ncds[i] == "hypertension") {
        ncdsListThai.add("โรคความดันโลหิต");
      }
    }
    return ncdsListThai.toString().replaceAll('[', '').replaceAll(']', '');
  }

  Widget buttonLabTest(context) {
    return RaisedButton(
      onPressed: () => null,
      child: Text("บันทึกผลตรวจจากห้องปฏิบัติการ"),
      color: Colors.green,
      padding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
    );
  }
}
