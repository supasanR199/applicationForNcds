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
import 'package:collapsible_sidebar/collapsible_sidebar.dart';

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
  List<CollapsibleItem> _items;
  String _headline;
  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
        text: 'ผู้ป่วย',
        icon: IconData(0xe159, fontFamily: 'MaterialIcons'),
        onPressed: () => setState(() => _headline = 'all'),
        isSelected: true,
      ),
      CollapsibleItem(
        text: 'โพสต์',
        icon: Icons.assignment_ind,
        onPressed: () => setState(() => _headline = 'patient'),
      ),
      CollapsibleItem(
        text: 'นัดหมายเข้าพบ',
        icon: Icons.stacked_bar_chart_sharp,
        onPressed: () => setState(() => _headline = 'volenter'),
      ),
    ];
  }

  void initState() {
    // print(_userLogId);
    super.initState();
    _items = _generateItems;
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
    var size = MediaQuery.of(context).size;

    return
        // DefaultTabController(
        //   initialIndex: 0,
        //   length: 3,
        Container(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 211, 251, 1),
        appBar: AppBar(
          centerTitle: false,
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
          // bottom: TabBar(
          //   indicatorColor: Color.fromRGBO(255, 211, 251, 1),
          //   labelColor: Colors.black,
          //   tabs: <Widget>[
          //     Tab(
          //       text: 'ผู้ป่วย',
          //     ),
          //     Tab(
          //       text: 'โพสต์',
          //     ),
          //     Tab(
          //       text: 'นัดหมายเข้าพบ',
          //     ),
          //     // Tab(
          //     //   text: '',
          //     // ),
          //   ],
          // ),
        ),
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("UserWeb")
                .doc(auth.currentUser.uid)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                userData = snapshot.data.data() as Map<String, dynamic>;
                _userData = userData;
                var userName = _userData["Firstname"] + _userData["Lastname"];
                return CollapsibleSidebar(
                  // isCollapsed: true,
                  selectedIconColor: Colors.white,
                  items: _items,
                  isCollapsed: true,
                  title: userName,
                  showToggleButton: true,
                  // title: 'MENU',
                  // avatarImg:false,
                  avatarImg: AssetImage('assets/icon/logo.png'),
                  // title: 'John Smith',
                  // onTitleTap: () {
                  //   // ScaffoldMessenger.of(context).showSnackBar(
                  //   //     SnackBar(content: Text('Yay! Flutter Collapsible Sidebar!')));
                  // },
                  toggleTitle: 'ปิดแถบเมนู',
                  body: _body(size, context, _headline),
                  backgroundColor: Colors.grey.shade900,
                  selectedTextColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 15,
                  ),
                  titleStyle: TextStyle(
                      fontSize: 20,
                      // fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                  toggleTitleStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

                  sidebarBoxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 20,
                      spreadRadius: 0.01,
                      offset: Offset(3, 3),
                    ),
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
        // TabBarView(
        //   children: <Widget>[
        //     Center(
        //       child: buildPatientPage(context, false),
        //     ),
        //     Center(
        //       child: buildPostPage(context),
        //     ),
        //     Center(
        //       child: buildAppointmentPage(context),
        //     ),
        //     // Center(
        //     //     // child: buildPostPage(context),
        //     //     ),
        //   ],
        // ),
      ),
    );
    // );
  }

  Widget _body(Size size, BuildContext context, String selected) {
    if (selected == "all") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blueGrey[50],
        child: Center(child: buildPatientPage(context, false)),
      );
    } else if (selected == "patient") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        // color: Colors.blueGrey[50],
        child: Center(child: buildPostPage(context)),
      );
    } else if (selected == "post") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        // color: Colors.blueGrey[50],
        child: Center(child: buildAppointmentPage(context)),
      );
    }
    return Container(
      height: double.infinity,
      width: double.infinity,
      // color: Colors.blueGrey[50],
      child: Center(child: buildAppointmentPage(context)),
    );
  }

  Widget actionMenu(String role) {
    return PopupMenuButton(
        icon: Icon(Icons.more_vert, color: Colors.black),
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

                    if (_userLogId.isEmpty) {
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
                        List appoint = List();
                        if (snap["AppointmentFromMd"] != null) {
                          appoint = snap["AppointmentFromMd"];
                        } else {
                          appoint.add(null);
                          appoint.add(null);
                        }
                        return ListTile(
                          title:
                              Text("${snap["Firstname"]}  ${snap["Lastname"]}"),
                          subtitle: Text(checkAppointmentFromMd(appoint[0])),
                          trailing: bulidButtonApployment(context, document),
                          // Text(checkAppointmentFromMd(
                          //     snap["AppointmentFromMd"])),
                          // onTap: () async {
                          //   final DateTime selected = await showDatePicker(
                          //     context: context,
                          //     initialDate: DateTime.now(),
                          //     firstDate: DateTime.now(),
                          //     lastDate: DateTime(2222),
                          //   );
                          //   if (selected != null && selected != selectedDate) {
                          //     setState(() {
                          //       selectedDate = selected;
                          //       FirebaseFirestore.instance
                          //           .collection("MobileUser")
                          //           .doc(document.id)
                          //           .update({
                          //         "AppointmentFromMd": selectedDate
                          //       }).whenComplete(() {
                          //         showDialog(
                          //           context: context,
                          //           builder: (BuildContext context) =>
                          //               alertMessageOnlyOk(context,
                          //                   "นัดหมายวันเข้าพบเรียบร้อยแล้ว"),
                          //         );
                          //       });
                          //     });
                          //   }
                          // },
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

  String checkAppointmentFromMd(String appoint) {
    // var date = new DateTime.fromMicrosecondsSinceEpoch(appoint.toDate());
    if (appoint == null) {
      return "ยังไม่การนัดหมายวันเข้าพบ";
    }
    // DateTime now = appoint.toDate();
    // String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    if (appoint != null) {
      return appoint;
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

  Widget bulidButtonApployment(
      BuildContext context, DocumentSnapshot document) {
    TextEditingController dateText = TextEditingController();
    TextEditingController timeText = TextEditingController();
    DateTime selected;
    TimeOfDay selectedTime;
    return RaisedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  content: SizedBox(
                    width: 250,
                    height: 250,
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("นัดวัน/เวลา",
                                style: TextStyle(fontSize: 25)),
                          ),
                        ),
                        // Text("วัน"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              controller: dateText,
                              onTap: () async {
                                selected = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2222),
                                  // ignore: missing_return
                                ).then((value) {
                                  if (value != null) {
                                    DateFormat serverFormater =
                                        DateFormat("yyyy-MM-dd");
                                    String formatted =
                                        serverFormater.format(value);
                                    dateText.text = formatted;
                                  } else {
                                    dateText.clear();
                                  }
                                });
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.calendar_today),
                                labelText: "วัน",
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  // borderSide: BorderSide(
                                  //   color: Color.fromRGBO(255, 211, 251, 1),
                                  // ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  // borderSide: BorderSide(
                                  //   color: Colors.red,
                                  //   width: 2.0,
                                  // ),
                                ),
                              )),
                        ),
                        // Text("เวลา"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              controller: timeText,
                              onTap: () async {
                                TimeOfDay initTime = TimeOfDay.now();
                                selectedTime = await showTimePicker(
                                  initialTime: initTime,
                                  context: context,
                                  // ignore: missing_return
                                ).then((value) {
                                  if (value != null) {
                                    DateTime date2 = DateFormat.jm()
                                        .parse(value.format(context));
                                    timeText.text =
                                        DateFormat("HH:mm:ss").format(date2);
                                  } else {
                                    timeText.clear();
                                  }
                                  // timeText.text = value;
                                });
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.lock_clock),
                                labelText: "เวลา",
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  // borderSide: BorderSide(
                                  //   color: Colors.blue,
                                  // ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  // borderSide: BorderSide(
                                  //   color: Colors.red,
                                  //   width: 2.0,
                                  // ),
                                ),
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                onPressed: () {
                                  showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              alertMessage(context,
                                                  "คุณแน่ใจจะนัดคุณ ${document.get("Firstname")}  ${document.get("Lastname")}  ไปที่ รพสต. ในวันที่ ${dateText.text}  เวลา  ${timeText.text}"))
                                      .then((value) {
                                    if (value == "CONFIRM") {
                                      List appointmentFromMd = List();
                                      appointmentFromMd.add(dateText.text);
                                      appointmentFromMd.add(timeText.text);
                                      FirebaseFirestore.instance
                                          .collection("MobileUser")
                                          .doc(document.id)
                                          .update({
                                        "AppointmentFromMd": appointmentFromMd
                                      });
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  });
                                },
                                textColor: Colors.black,
                                child: Text('ยืนยัน'),
                                color: Colors.greenAccent[100],
                                padding: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                textColor: Colors.black,
                                child: Text('ยกเลิก'),
                                color: Colors.redAccent[100],
                                padding: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ));
      },
      // color: Color.fromRGBO(255, 211, 251, 1),
      textColor: Colors.black,
      child: Text('นัดหมายผู้ป่วยมาที่ รพสต.'),
      color: Colors.greenAccent[100],
      padding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
    );
  }
}
