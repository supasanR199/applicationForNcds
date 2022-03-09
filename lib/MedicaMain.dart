import 'package:appilcation_for_ncds/AddPost.dart';
import 'package:appilcation_for_ncds/EvaluateSoftwarePage.dart';
import 'package:appilcation_for_ncds/function/DisplayTime.dart';
import 'package:appilcation_for_ncds/widgetShare/BuildPatientPage.dart';
import 'package:appilcation_for_ncds/widgetShare/ContentPage.dart';
import 'package:appilcation_for_ncds/widgetShare/EvaluateSoftwareForMed.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'PatientMain.dart';
import 'models/AuthDataModels.dart';
import 'services/shared_preferences_service.dart';

class MedicaMain extends StatefulWidget {
  @override
  _MedicaMainState createState() => _MedicaMainState();
}

class _MedicaMainState extends State<MedicaMain> {
  @override
  AuthDataModels _authDataModels = AuthDataModels();
  final auth = FirebaseAuth.instance;
  var user;
  var _docRef = FirebaseFirestore.instance
      .collection('UserWeb')
      .where('role', isNotEqualTo: 'admin');
  var _docRefMobile = FirebaseFirestore.instance.collection("MobileUser");
  var docId;
  var _userData;
  var loginTime;
  var _docRefPatient = FirebaseFirestore.instance
      .collection("MobileUser")
      .where("Role", isEqualTo: "Patient")
      .snapshots();
  DateTime selectedDate = DateTime.now();

  final PrefService _prefService = PrefService();
  DateTime logoutTime;
  String _userLogId = "";
  int index;
  Map<String, dynamic> userData;

  void initState() {
    // print(_userLogId);
    super.initState();
    asyncSingUp();
  }

  void asyncSingUp() async {
    loginTime = DateTime.now();
    var getDoc = FirebaseFirestore.instance
        .collection("UserWeb")
        .doc(auth.currentUser.uid)
        .get();
    FirebaseFirestore.instance.collection("UserLog").add({
      "email": auth.currentUser.email,
      "timeLogin": DateTime.now(),
      "uid": auth.currentUser.uid,
      "Firstname": await getDoc.then((value) => value.data()["Firstname"]),
      "Lastname": await getDoc.then((value) => value.data()["Lastname"]),
      "role": await getDoc.then((value) => value.data()["role"]),
      "logoutTime": null
    }).then((value) {
      setState(() {
        _userLogId = value.id;
      });
    });
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Container(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(255, 211, 251, 1),
          appBar: AppBar(
            title: Text(
              "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
              style: TextStyle(color: Colors.black),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            actions: [
              FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("UserWeb")
                      .doc(auth.currentUser.uid)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      userData = snapshot.data.data() as Map<String, dynamic>;
                      _userData = userData;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "${userData['Firstname']}  ${userData['Lastname']}",
                              style: TextStyle(color: Colors.black)),
                          actionMenu(userData["role"]),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("กำลังโหลด"),
                        ],
                      );
                    }
                  }),
            ],
            bottom: TabBar(
              indicatorColor: Color.fromRGBO(255, 211, 251, 1),
              labelColor: Colors.black,
              tabs: <Widget>[
                Tab(
                  text: 'ผู้ป่วย',
                ),
                Tab(
                  text: 'โพสต์',
                ),
                Tab(
                  text: 'นัดหมายเข้าพบ',
                ),
                // Tab(
                //   text: '',
                // ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Center(
                child: buildPatientPage(context, false),
              ),
              Center(
                child: buildPostPage(context),
              ),
              Center(
                child: buildAppointmentPage(context),
              ),
              // Center(
              //     // child: buildPostPage(context),
              //     ),
            ],
          ),
        ),
      ),
    );
  }

  Widget actionMenu(String role) {
    return PopupMenuButton(
        icon: Icon(Icons.more_vert),
        // child: Text(userData["name"]),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(
                    Icons.add_chart_outlined,
                    color: Colors.black,
                  ),
                  title: Text('ประเมินการใช้งาน'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EvaulateSoftwareForMd(
                          role: userData["role"],
                        ),
                      ),
                    );
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('ออกจากระบบ'),
                  onTap: () async {
                    logoutTime = DateTime.now();
                    print(_userLogId.isEmpty);
                    if (_userLogId.isEmpty) {
                      print(_userLogId.isEmpty);
                    } else {
                      logoutTime = DateTime.now();
                      await FirebaseFirestore.instance
                          .collection("UserLog")
                          .doc(_userLogId)
                          .update({
                        "logoutTime": logoutTime,
                        "useInWeb": calTimeInUse(loginTime, logoutTime)
                      }).onError(
                              (error, stackTrace) => print(error.toString()));
                      auth.signOut().then((value) {
                        _prefService.removeCache("email");
                        _prefService.removeCache("password");
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              alertMessageOnlyOk(context, "ออกจากระบบแล้ว"),
                        ).then((value) {
                          if (value == "CONFIRM") {
                            Navigator.pushNamed(context, "/");
                          }
                        });
                      });
                    }
                  },
                ),
              ),
            ]);
  }

  Widget buildAppointmentPage(BuildContext context) {
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
                  'นัดหมายเข้าพบ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("MobileUser")
                    .where("Role", isEqualTo: "Patient")
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
                          title: Text("${snap["Firstname"]}"),
                          subtitle: Text("${snap["Lastname"]}"),
                          trailing: Text(checkAppointmentFromMd(
                              snap["AppointmentFromMd"])),
                          onTap: () async {
                            final DateTime selected = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2222),
                            );
                            if (selected != null && selected != selectedDate) {
                              setState(() {
                                selectedDate = selected;
                                FirebaseFirestore.instance
                                    .collection("MobileUser")
                                    .doc(document.id)
                                    .update({
                                  "AppointmentFromMd": selectedDate
                                }).whenComplete(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        alertMessageOnlyOk(context,
                                            "นัดหมายวันเข้าพบเรียบร้อยแล้ว"),
                                  );
                                });
                              });
                            }
                          },
                        );
                      }).toList(),
                    );
                  } else {
                    return Center(
                      child: Text("กำลังโหลดข้อมูล"),
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
              child: buildContentPost(context),
            ),
            Center(
              child: bulidButtonAddPost(context),
            ),
          ],
        ),
      ),
    );
  }

  String checkAppointmentFromMd(Timestamp appoint) {
    // var date = new DateTime.fromMicrosecondsSinceEpoch(appoint.toDate());
    if (appoint == null) {
      return "ยังไม่การนัดหมายวันเข้าพบ";
    }
    DateTime now = appoint.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    if (appoint != null) {
      return formattedDate;
    } else {
      return "ยังไม่การนัดหมายวันเข้าพบ";
    }
  }

  Widget buildContentPost(BuildContext context) {
    return contentPage(context);
    // return StreamBuilder<QuerySnapshot>(
    //     stream:
    //         FirebaseFirestore.instance.collection("RecommendPost").snapshots(),
    //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //       if (snapshot.hasData) {
    //         return ListView(
    //           children: snapshot.data.docs.map((DocumentSnapshot document) {
    //             Map<String, dynamic> snap =
    //                 document.data() as Map<String, dynamic>;
    //             return GestureDetector(
    //               onTap: () => null,
    //               child: Card(
    //                 color: Colors.amber,
    //                 child: SizedBox(
    //                   height: 400,
    //                   width: 90,
    //                   child: Expanded(
    //                     child: Row(
    //                       children: [
    //                         Expanded(
    //                           child: Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             mainAxisAlignment:
    //                                 MainAxisAlignment.spaceAround,
    //                             children: [
    //                               Expanded(
    //                                 child: Row(
    //                                   children: [
    //                                     Padding(
    //                                       padding: EdgeInsets.only(
    //                                           left: 8.0, right: 8.0),
    //                                       child: Text(
    //                                         "หัวเรื่อง  :",
    //                                         style: TextStyle(fontSize: 20),
    //                                       ),
    //                                     ),
    //                                     Text("${snap["topic"]}"),
    //                                   ],
    //                                 ),
    //                               ),
    //                               Expanded(
    //                                 child: Row(
    //                                   children: [
    //                                     Padding(
    //                                       padding: EdgeInsets.only(
    //                                           left: 8.0, right: 8.0),
    //                                       child: Text(
    //                                         "เนื้อเรื่อง :",
    //                                         style: TextStyle(fontSize: 20),
    //                                       ),
    //                                     ),
    //                                     Expanded(
    //                                       child: Column(
    //                                         children: [
    //                                           Text(
    //                                             "${snap["content"]}",
    //                                           ),
    //                                         ],
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                               Expanded(
    //                                 child: Row(
    //                                   children: [
    //                                     Padding(
    //                                       padding: EdgeInsets.only(
    //                                           left: 8.0, right: 8.0),
    //                                       child: Text(
    //                                         "ผู้สร้างโพสต์แนะนำ :",
    //                                         style: TextStyle(fontSize: 20),
    //                                       ),
    //                                     ),
    //                                     Expanded(
    //                                       child: Column(
    //                                         mainAxisAlignment:
    //                                             MainAxisAlignment.center,
    //                                         crossAxisAlignment:
    //                                             CrossAxisAlignment.start,
    //                                         children: [
    //                                           Text(
    //                                             "${snap["createBy"]}",
    //                                           ),
    //                                         ],
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                               Expanded(
    //                                 child: Row(
    //                                   children: [
    //                                     Padding(
    //                                       padding: EdgeInsets.only(
    //                                           left: 8.0, right: 8.0),
    //                                       child: Text(
    //                                         "เหมะสำหรับผู้ป่วย :",
    //                                         style: TextStyle(fontSize: 20),
    //                                       ),
    //                                     ),
    //                                     Expanded(
    //                                       child: Column(
    //                                         mainAxisAlignment:
    //                                             MainAxisAlignment.center,
    //                                         crossAxisAlignment:
    //                                             CrossAxisAlignment.start,
    //                                         children: [
    //                                           Text(
    //                                             "อายุ:  ${snap["recommentForAge"]}",
    //                                           ),
    //                                           Text(
    //                                             "ค่าBMI:  ${snap["recommentForBMI"]}",
    //                                           ),
    //                                           Text(
    //                                             "โรค:  ${snap["recommentForDieases"]}",
    //                                           ),
    //                                         ],
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                               Expanded(
    //                                 child: Row(
    //                                   children: [
    //                                     Padding(
    //                                       padding: EdgeInsets.only(
    //                                           left: 8.0, right: 8.0),
    //                                       child: Text(
    //                                         "สร้างโพสต์เมื่อวันที่ :",
    //                                         style: TextStyle(fontSize: 20),
    //                                       ),
    //                                     ),
    //                                     Text(
    //                                       convertDateTimeDisplay(
    //                                               snap["createAt"]
    //                                                   .toDate()
    //                                                   .toString()) +
    //                                           "" +
    //                                           "สร้างมาแล้ว :" +
    //                                           "" +
    //                                           calCreateDay(
    //                                               convertDateTimeDisplay(
    //                                                   snap["createAt"]
    //                                                       .toDate()
    //                                                       .toString())) +
    //                                           "วัน",
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                               Expanded(
    //                                 child: Row(
    //                                   children: [
    //                                     Padding(
    //                                       padding: EdgeInsets.only(
    //                                           left: 8.0, right: 8.0),
    //                                       child: Text(
    //                                         "สร้างโพสต์เมื่อเวลา :",
    //                                         style: TextStyle(fontSize: 20),
    //                                       ),
    //                                     ),
    //                                     Text(
    //                                       convertTimeDisplay(snap["createAt"]),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             );
    //           }).toList(),
    //         );
    //       } else {
    //         return Text("ไม่มีโพสต์แนะนำ");
    //       }
    //     });
  }

  Widget bulidButtonAddPost(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPost(
                userData: _userData,
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
      ),
    );
  }
}
