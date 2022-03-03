import 'package:appilcation_for_ncds/widgetShare/FoodRecord.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:appilcation_for_ncds/LabResults.dart';
import 'package:appilcation_for_ncds/detail/LabResultsDetail.dart';
import 'package:appilcation_for_ncds/function/ListNCDs.dart';
import 'package:appilcation_for_ncds/function/DisplayTime.dart';
import 'package:appilcation_for_ncds/AddReminderDrug.dart';
import 'package:appilcation_for_ncds/detail/VisitDetail.dart';

class PatientMain extends StatefulWidget {
  @override
  Map<String, dynamic> patienData;
  DocumentReference patienDataId;
  bool isHospital;
  PatientMain({Key key, @required this.patienData, @required this.patienDataId,@required this.isHospital})
      : super(key: key);
  _PatientMainState createState() => _PatientMainState();
}

class _PatientMainState extends State<PatientMain> {
  var auth = FirebaseAuth.instance;
  bool isHospital;
  void initState() {
    // checkIsHopital();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 7,
      child: Container(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(255, 211, 251, 1),
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
                Tab(
                  text: 'ผลตรวจจากห้องปฏิบัติการ',
                ),
                Tab(
                  text: 'เตือนรับประทานยา',
                ),
                Tab(
                  text: 'บันทึกผลตรวจจากการลงพื้นที่ของอาสาสมัคร',
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
                  child: FoodRecord(patienId: widget.patienDataId,),
                  ),
              Center(
                  // child: buildPostPage(context),
                  ),
              Center(
                child: buildHistoryLabResultsPage(context),
              ),
              Center(
                child: buildReminderDrug(context),
              ),
              Center(
                child: buildVisitReport(context),
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
                        child: Text(
                          "วันเกิด : " +
                              convertDateTimeDisplay(widget
                                  .patienData["Birthday"]
                                  .toDate()
                                  .toString()),
                        ),
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

  Widget buildHistoryLabResultsPage(BuildContext context) {
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
                  'ผลตรวจจากห้องปฏิบัติการ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("MobileUser")
                    .doc(widget.patienDataId.id)
                    .collection("LabResultsHistory")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> snap =
                            document.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(
                            convertDateTimeDisplay(
                                snap["creatAt"].toDate().toString()),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LabResultsDetail(
                                  labResultsData: snap,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    );
                  } else {
                    return Center(
                      child: Text("ไม่มีประวัติการตรวจจากห้องแลป"),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReminderDrug(BuildContext context) {
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
                  'เตือนรับประทานยา',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("MobileUser")
                      .doc(widget.patienDataId.id)
                      .collection("ReminderDrug")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> snap =
                              document.data() as Map<String, dynamic>;
                          return ListTile(
                            title: Text("${snap["name"]}"),
                            subtitle: Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("วันที่ยาหมดอายุ:" +
                                          " " +
                                          convertDateTimeDisplay(snap["DateEXP"]
                                              .toDate()
                                              .toString()) +
                                          " "),
                                      Text("กิน:" +
                                          " " +
                                          listTimePerDay(snap["After/Befor"]) +
                                          " "),
                                      Text("เวลากิน:" +
                                          " " +
                                          listTime(snap["TimeToEat"]) +
                                          " "),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("บันทึกเพิ่มเติม:" +
                                          " " +
                                          checkNote(snap["Note"])),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            trailing: buildButtonDelectRemainder(
                                context, document.id, snap["name"]),
                          );
                        }).toList(),
                      );
                    } else {
                      return Center(
                        child: Text("ยังไม่มีบันทึกเตือนความจำกินยา"),
                      );
                    }
                  }),
            ),
            Expanded(
              child: buildButtonAddReminderDrug(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVisitReport(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 700,
        width: 1000,
        child: Column(
          children: <Widget>[
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("MobileUser")
                    .doc(widget.patienDataId.id)
                    .collection("VisitReport")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> snap =
                            document.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(document.id),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VisitDetail(
                                  visit: null,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    );
                  } else {
                    return Center(
                      child: Text("ไม่มีประวัติการตรวจจากห้องแลป"),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String checkDrugAllergy(String str) {
    if (str.isEmpty) {
      return "ไม่มีการแพ้ยา";
    } else {
      return str;
    }
  }

  Widget buttonLabTest(context) {
    return Visibility(
      visible: widget.isHospital,
      child: RaisedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LabResults(
                patienData: widget.patienData,
                patienDataId: widget.patienDataId,
              ),
            ),
          );
        },
        child: Text("บันทึกผลตรวจจากห้องปฏิบัติการ"),
        color: Colors.green,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
      ),
    );
  }

  Widget buildButtonAddReminderDrug(context) {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddReminderDrug(
              patienData: widget.patienData,
              patienDataId: widget.patienDataId,
            ),
          ),
        );
      },
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

  Widget dialogAddRemider(context) {
    return AlertDialog(
      title: const Text('เพิ่มเตือนความจำรับประทานยา'),
      content: Column(
        children: [],
      ),
    );
  }

  String listTime(List ncds) {
    List ncdsListThai = [];
    for (var i = 0; i < ncds.length; i++) {
      print(ncds[i]);
      if (ncds[i] == "morning") {
        ncdsListThai.add("เช้า");
      } else if (ncds[i] == "affternoon") {
        ncdsListThai.add("กลางวัน");
      } else if (ncds[i] == "evening") {
        ncdsListThai.add("เย็น");
      } else if (ncds[i] == "ninght") {
        ncdsListThai.add("ก่อนนอน");
      }
    }
    return ncdsListThai.toString().replaceAll('[', '').replaceAll(']', '');
  }

  String listTimePerDay(String ncds) {
    String ncdsListThai = "";

    if (ncds == "before_meals") {
      ncdsListThai = "ก่อนอาหาร";
    } else if (ncds == "after_meals") {
      ncdsListThai = "หลังอาหาร";
    }
    return ncdsListThai;
  }

  String checkNote(String str) {
    if (str == null) {
      return "ไม่มีบันทึก";
    } else {
      return str;
    }
  }

  Widget buildButtonDelectRemainder(context, id, name) {
    return RaisedButton(
      // color: Colors.accents,
      onPressed: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              alertMessage(context, "ลบเตือนเวลา $name หรือไม่"),
        ).then((value) async {
          if (value == "CONFIRM") {
            await FirebaseFirestore.instance
                .collection("MobileUser")
                .doc(widget.patienDataId.id)
                .collection("ReminderDrug")
                .doc(id)
                .delete()
                .whenComplete(() {
              showDialog(
                context: context,
                builder: (BuildContext context) => alertMessageOnlyOk(
                    context, "ลบเตือนเวลากินยาเรียบร้อยแล้ว"),
              );
            });
          } else if (value == "CANCEL") {
            Navigator.pop(context);
          }
        });
      },
      child: Text('ลบ'),
      color: Colors.redAccent,
      padding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
    );
  }

  checkIsHopital() async {
    await FirebaseFirestore.instance
        .collection("UserWeb")
        .doc(auth.currentUser.uid)
        .get()
        .then((value) {
      if (value.data()["role"] == "hospital") {
        setState(() {
          isHospital = true;
        });
      } else {
        setState(() {
          isHospital = false;
        });
      }
    });
  }
}
