import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:appilcation_for_ncds/function/DisplayTime.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';

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
                  text: 'ข้อมูลอาสาสมัคร',
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
                child: buildVolunteerDataPage(context),
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

  Widget buildVolunteerDataPage(context) {
    print(widget.volunteerData["isBoss"]);
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
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'ข้อมูลอาสาสมัคร',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                ],
              ),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text("ชื่อ : " + widget.volunteerData["Firstname"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "นามสกุล : " + widget.volunteerData["Lastname"]),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "ที่อยู่ : " + widget.volunteerData["Address"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "วันหมดอายุใบอนุญาตอาสาสมัคร : " +
                              convertDateTimeDisplay(
                                widget.volunteerData["CardEXP"]
                                    .toDate()
                                    .toString(),
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      child: buildButtonRegisterBoss(context),
                      visible: !widget.volunteerData["isBoss"],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtonRegisterBoss(context) {
    return RaisedButton(
      color: Colors.green[100],
      child: Text("กำหนดให้เป็นหัวหน้าอาสาสมัคร"),
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
