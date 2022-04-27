import 'dart:html';

import 'package:appilcation_for_ncds/widgetShare/FoodRecord.dart';
import 'package:appilcation_for_ncds/widgetShare/MoodRecord.dart';
import 'package:appilcation_for_ncds/widgetShare/ProfilePhoto.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowVisiter.dart';
import 'package:appilcation_for_ncds/widgetShare/WailkCount.dart';
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
  PatientMain(
      {Key key,
      @required this.patienData,
      @required this.patienDataId,
      @required this.isHospital})
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
          resizeToAvoidBottomInset: false,
          // backgroundColor: Color.fromRGBO(255, 211, 251, 1),
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
              style: TextStyle(color: Colors.black),
            ),
            foregroundColor: Colors.blueAccent,
            backgroundColor: Colors.white,
            bottom: TabBar(
              indicatorColor: Colors.blueAccent,
              labelColor: Colors.black,
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
                  text: 'ยาของผู้ป่วย',
                ),
                Tab(
                  text: 'บันทึกการลงพื้นที่ของอาสาสมัคร',
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
                child: WalkCount(
                  patientId: widget.patienDataId,
                ),
              ),
              Center(
                child: FoodRecord(
                  patienId: widget.patienDataId,
                ),
              ),
              Center(
                child: MoodRecord(
                  patienId: widget.patienDataId,
                ),
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 10),
                  child: Text(
                    'ข้อมูลผู้ป่วย',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                  ),
                ),
              ),         
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20,), 
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Text(
                            "ข้อมูลส่วนตัว",
                            style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10,), 
                            RichText(
                              text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                                  TextSpan(text: 'ชื่อ :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                                  TextSpan(text: ' ${widget.patienData["Firstname"]}',style: TextStyle(fontSize: 18,)),
                                                ],
                                            ),
                                          ),
                            SizedBox(height: 5,),              
                            RichText(
                              text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                                  TextSpan(text: 'นามสกุล :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                                  TextSpan(text: ' ${widget.patienData["Lastname"]}',style: TextStyle(fontSize: 18,)),
                                                ],
                                            ),
                                          ),
                            SizedBox(height: 5,),               
                            RichText(
                              text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                                  TextSpan(text: 'วันเกิด :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                                  TextSpan(text: ' ${convertDateTimeDisplay(widget
                                                                      .patienData["Birthday"]
                                                                        .toDate()
                                                                          .toString())}',style: TextStyle(fontSize: 18,)),
                                                ],
                                            ),
                                          ),
                            SizedBox(height: 5,),              
                            RichText(
                              text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                                  TextSpan(text: 'อายุ :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                                  TextSpan(text: ' ${calAge(convertDateTimeDisplay(widget
                                                                    .patienData["Birthday"]
                                                                      .toDate()
                                                                        .toString()) +
                                                                          "ปี")}',style: TextStyle(fontSize: 18,)),
                                                ],
                                            ),
                                          ),
                            SizedBox(height: 5,),              
                            RichText(
                              text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                                  TextSpan(text: 'โทรศัพท์ :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                                  TextSpan(text: ' ${widget.patienData["Phonenumber"]}',style: TextStyle(fontSize: 18,)),
                                                ],
                                            ),
                                          ),
                            SizedBox(height: 5,),              
                            RichText(
                              text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                                  TextSpan(text: 'เพศ :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                                  TextSpan(text: ' ${widget.patienData["Gender"]}',style: TextStyle(fontSize: 18,)),
                                                ],
                                            ),
                                          ),                                                                                                                                                                                                                                  
                        // Text("ชื่อ : " + widget.patienData["Firstname"],style: TextStyle(fontSize: 18)),
                        // Text("นามสกุล : " + widget.patienData["Lastname"],style: TextStyle(fontSize: 18)),
                        // Text(
                        //   "วันเกิด : " +
                        //       convertDateTimeDisplay(widget
                        //           .patienData["Birthday"]
                        //           .toDate()
                        //           .toString()),style: TextStyle(fontSize: 18)
                        // ),
                        // Text(
                        //   "อายุ : " +
                        //       calAge(convertDateTimeDisplay(widget
                        //               .patienData["Birthday"]
                        //               .toDate()
                        //               .toString()) +
                        //           "ปี"),style: TextStyle(fontSize: 18)
                        // ),
                        // Text(
                        //     "โทรศัพท์ : " + widget.patienData["Phonenumber"],style: TextStyle(fontSize: 18)),
                        // Text("เพศ : " + widget.patienData["Gender"],style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                    Container(
                      width: 2,
                      color: Colors.grey.shade400,
                    ),                  
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20,), 
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Text(
                            "ข้อมูลสุขภาพ",
                            style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10,), 
                            RichText(
                              text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                                  TextSpan(text: 'น้ำหนัก :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                                  TextSpan(text: ' ${widget.patienData["Weight"]} กก.',style: TextStyle(fontSize: 18,)),
                                                ],
                                            ),
                                          ),
                            SizedBox(height: 5,),
                            RichText(
                              text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                                  TextSpan(text: 'ส่วนสูง :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                                  TextSpan(text: ' ${widget.patienData["Height"]} ซม.',style: TextStyle(fontSize: 18,)),
                                                ],
                                            ),
                                          ),
                            SizedBox(height: 5,),               
                            RichText(
                              text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                                  TextSpan(text: 'รอบอก :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                                  TextSpan(text: ' ${widget.patienData["Waistline"]} นิ้ว',style: TextStyle(fontSize: 18,)),
                                                ],
                                            ),
                                          ),
                            SizedBox(height: 5,),              
                            RichText(
                              text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                                  TextSpan(text: 'กรุ๊ปเลือด :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                                  TextSpan(text: ' ${widget.patienData["Bloodgroup"]}',style: TextStyle(fontSize: 18,)),
                                                ],
                                            ),
                                          ),
                            SizedBox(height: 5,),              
                            RichText(
                              text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                                  TextSpan(text: 'แพ้ยา :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                                  TextSpan(text: ' ${checkDrugAllergy(widget.patienData["DrugAllergy"])}',style: TextStyle(fontSize: 18,)),
                                                ],
                                            ),
                                          ),
                            SizedBox(height: 5,),              
                            RichText(
                              text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                                  TextSpan(text: 'โรค :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                                  TextSpan(text: ' ${listNcds(widget.patienData["NCDs"])}',style: TextStyle(fontSize: 18,)),
                                                ],
                                            ),
                                          ),                                                                                                                                                                                                                                         
                        // Text("ส่วนสูง : " + widget.patienData["Height"],style: TextStyle(fontSize: 18)),
                        // Text("น้ำหนัก : " + widget.patienData["Weight"],style: TextStyle(fontSize: 18)),
                        // Text("รอบอก : " + widget.patienData["Waistline"],style: TextStyle(fontSize: 18)),
                        // Text("กรุ๊ปเลือด : " + widget.patienData["Bloodgroup"],style: TextStyle(fontSize: 18)),
                        // Text("แพ้ยา : " +checkDrugAllergy(widget.patienData["DrugAllergy"]),style: TextStyle(fontSize: 18)),
                        // Text("โรค : " + listNcds(widget.patienData["NCDs"]),style: TextStyle(fontSize: 18)),
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
      ),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }

  Widget buildHistoryLabResultsPage(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20),),),
      child: SizedBox(
        height: 700,
        width: 1000,
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 30, bottom: 20
                ),
                child: Text(
                  'ผลตรวจจากห้องปฏิบัติการ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("MobileUser")
                    .doc(widget.patienDataId.id)
                    .collection("LabResultsHistory")
                    // .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        print(document.id);
                        Map<String, dynamic> snap =
                            document.data() as Map<String, dynamic>;
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 100),
                          child: Column(
                            children: [
                              ListTile(
                                hoverColor: Colors.grey.shade200,
                                title: Text("วันที่ทำกสรบันทึก : ${document.id}"),
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
                              ),
                                              Divider(
                                                thickness: 2,
                                                color: Colors.grey.shade300,
                                              )                              
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error));
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
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20))),
      child: SizedBox(
        height: 700,
        width: 1000,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 30,bottom: 20
                  ),
                  child: Text(
                    'ยาของผู้ป่วย',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
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
                              title: Text("${snap["name"]}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
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
                                            " ",style: TextStyle(fontSize: 16)),
                                        Text("กิน:" +
                                            " " +
                                            listTimePerDay(snap["After/Befor"]) +
                                            " ",style: TextStyle(fontSize: 16)),
                                        Text("เวลากิน:" +
                                            " " +
                                            listTime(snap["TimeToEat"]) +
                                            " ",style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("บันทึกเพิ่มเติม:" +
                                            " " +
                                            checkNote(snap["Note"]),style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                    Divider(
                                        thickness: 2,
                                        color: Colors.grey.shade300,
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
              buildButtonAddReminderDrug(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVisitReport(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20),),),    
      child: SizedBox(
        height: 700,
        width: 1000,
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30,bottom: 20),
                child: Text(
                  'บันทึกการลงพื้นที่ของอาสาสมัคร',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 60),
                          child: Column(
                            children: [
                              ListTile(
                                hoverColor: Colors.grey.shade200,
                                trailing: showWhoIs(context, snap["Visitor"]),
                                title: Text("วันที่ทำกสรบันทึก : ${document.id}"),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VisitDetail(
                                        visit: snap,
                                      ),
                                    ),
                                  );
                                },
                              ),
                                                Divider(
                                                  thickness: 2,
                                                  color: Colors.grey.shade300,
                                                )                            
                            ],
                          ),
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
        child: Text(
          "บันทึกผลตรวจจากห้องปฏิบัติการ",
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
          ),
        color: Colors.blueAccent,
        hoverColor: Colors.grey,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  Widget buildButtonAddReminderDrug(context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: MaterialButton(
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
        hoverColor: Colors.grey.shade200,
        color: Colors.white,
        textColor: Colors.blueAccent,
        child: Icon(
          Icons.add,
          size: 24,
        ),
        padding: EdgeInsets.all(16),
        shape: CircleBorder(),
      ),
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
      hoverColor: Colors.grey,
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
      child: Text('ลบ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),
      color: Colors.redAccent,
      padding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
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
