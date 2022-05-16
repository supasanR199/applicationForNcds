import 'package:appilcation_for_ncds/mobilecode/function/datethai.dart';
import 'package:appilcation_for_ncds/widgetShare/ProfilePhoto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:appilcation_for_ncds/function/DisplayTime.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:appilcation_for_ncds/AddPatientForVolunteer.dart';
import 'package:intl/intl.dart';
// import 'package:smart_select/smart_select.dart';

class VolunteerMain extends StatefulWidget {
  @override
  var volunteerData;
  var volunteerDataId;
  VolunteerMain(
      {Key key, @required this.volunteerData, @required this.volunteerDataId})
      : super(key: key);
  _VolunteerMainState createState() => _VolunteerMainState();
}

class _VolunteerMainState extends State<VolunteerMain> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 1,
      child: Container(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            foregroundColor: Colors.blueAccent,
            centerTitle: false,
            title: Text(
              "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            // bottom: TabBar(
            //   indicatorColor: Color.fromRGBO(255, 211, 251, 1),
            //   tabs: <Widget>[
            //     Tab(
            //       text: 'ข้อมูลอาสาสมัคร',
            //     ),
            //     // Tab(
            //     //   text: 'ออกกำลังกาย',
            //     // ),
            //     // Tab(
            //     //   text: 'อาหาร',
            //     // ),
            //     // Tab(
            //     //   text: 'อารมณ์',
            //     // ),
            //   ],
            // ),
          ),
          body: TabBarView(
            children: <Widget>[
              Center(
                child: buildVolunteerDataPage(context),
              ),
              // Center(
              //     // child: buildPostPage(context),
              //     ),
              // Center(
              //     // child: buildPatientPage(context),
              //     ),
              // Center(
              //     // child: buildPostPage(context),
              //     ),
            ],
          ),
        ),
      ),
    );
    // );
  }

  Widget buildVolunteerDataPage(context) {
    if (widget.volunteerData["isBoss"] == null) {
      FirebaseFirestore.instance
          .collection("MobileUser")
          .doc(widget.volunteerDataId.id)
          .update({"isBoss": false});
    }
    return Card(
      child: SizedBox(
        height: 700,
        width: 1000,
        child: Padding(
          padding: const EdgeInsets.only(left: 60, right: 60),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 20),
                      child: Text(
                        'ข้อมูล อสม.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              proFileShowDataPhoto(context, widget.volunteerData["Img"],
                  widget.volunteerData["Gender"]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text(
                      //     "ข้อมูลส่วนตัว",
                      //     style: TextStyle(fontSize: 20),
                      //   ),
                      // ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'ชื่อ :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(
                                text: ' ${widget.volunteerData["Firstname"]}',
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'นามสกุล :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(
                                text: ' ${widget.volunteerData["Lastname"]}',
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'เพศ :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(
                                text: ' ${widget.volunteerData["Gender"]}',
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'โทรศัพท์ :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(
                                text: ' ${widget.volunteerData["Phonenumber"]}',
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'E-mail :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(
                                text: ' ${widget.volunteerData["Gender"]}',
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'เลขบัตรประจำตะว อสม. :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(
                                text: ' ${widget.volunteerData["VolunteerID"]}',
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'ได้รับการแต่งตั้งปี :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(
                                text:
                                    ' ${DateThai(widget.volunteerData["CardEXP"].toDate().toString())}',
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'ที่อยู่ :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(
                                text: ' ${widget.volunteerData["Address"]}',
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child:
                      //       Text("ชื่อ : " + widget.volunteerData["Firstname"]),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text(
                      //       "นามสกุล : " + widget.volunteerData["Lastname"]),
                      // ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      child: buildButtonRegisterBoss(context),
                      visible: !widget.volunteerData["isBoss"],
                    ),
                    Visibility(
                      child: buildButtonCancelBoss(context),
                      visible: widget.volunteerData["isBoss"],
                    ),
                    Visibility(
                      child: buildButtonAddPatientForBoss(context),
                      visible: widget.volunteerData["isBoss"],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }

  Widget buildButtonRegisterBoss(context) {
    return Container(
      width: 250,
      child: RaisedButton(
        hoverColor: Colors.grey.shade300,
        color: Colors.green,
        child: Text("กำหนดให้เป็นหัวหน้า อสม.",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        padding: EdgeInsets.all(20),
        onPressed: () {
          try {
            showDialog(
                    context: context,
                    builder: (BuildContext context) => alertMessage(context,
                        "คุณต้องการกำหนดให้คุณ  ${widget.volunteerData["Firstname"]} เป็นหัวหน้าอสม. ใช้หรือไม่?"))
                .then((value) async {
              if (value == "CONFIRM") {
                await FirebaseFirestore.instance
                    .collection("MobileUser")
                    .doc(widget.volunteerDataId.id)
                    .update({"isBoss": true}).whenComplete(() {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          alertMessage(context, "บันทึกสำเร็จ"));
                });
              }
            });
          } on FirebaseException catch (e) {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    alertMessage(context, e.toString()));
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget buildButtonCancelBoss(context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: 250,
        child: RaisedButton(
          hoverColor: Colors.grey.shade300,
          color: Colors.red,
          child: Text("ยกเลิกเป็นหัวหน้า อสม.",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          padding: EdgeInsets.all(20),
          onPressed: () {
            try {
              showDialog(
                      context: context,
                      builder: (BuildContext context) => alertMessage(context,
                          "คุณต้องการยกเลิก  ${widget.volunteerData["Firstname"]} จากการเป็นเป็นหัวหน้าอสม. ใช้หรือไม่?"))
                  .then((value) async {
                if (value == "CONFIRM") {
                  await FirebaseFirestore.instance
                      .collection("MobileUser")
                      .doc(widget.volunteerDataId.id)
                      .update({"isBoss": false}).whenComplete(() {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            alertMessage(context, "บันทึกสำเร็จ"));
                  });
                }
              });
            } on FirebaseException catch (e) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      alertMessage(context, e.toString()));
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtonAddPatientForBoss(context) {
    return Container(
      width: 250,
      child: RaisedButton(
        hoverColor: Colors.grey.shade300,
        color: Colors.blueAccent,
        child: Text("เพิ่มผู้ป่วยในการดูแล",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        padding: EdgeInsets.all(20),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPatienFoorVolunteer(
                volunteerData: widget.volunteerData,
                volunteerDataId: widget.volunteerDataId,
              ),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }

  bool isBoss(String boss) {
    if (boss == "Boss") {
      return true;
    } else {
      return false;
    }
  }
}
