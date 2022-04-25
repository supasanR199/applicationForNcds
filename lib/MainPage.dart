import 'dart:ui';

import 'package:appilcation_for_ncds/EvaluateSoftwarePage.dart';
import 'package:appilcation_for_ncds/function/checkChat.dart';
import 'package:appilcation_for_ncds/function/checkRole.dart';
import 'package:appilcation_for_ncds/widgetShare/AllStatus.dart';
import 'package:appilcation_for_ncds/widgetShare/BuildPatientPage.dart';
import 'package:appilcation_for_ncds/widgetShare/BuildPatientSearch.dart';
import 'package:appilcation_for_ncds/widgetShare/BuildVolunteerSearch.dart';
import 'package:appilcation_for_ncds/widgetShare/ChatSearchPage.dart';
import 'package:appilcation_for_ncds/widgetShare/ContentPage.dart';
import 'package:appilcation_for_ncds/widgetShare/ProfilePhoto.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appilcation_for_ncds/VolunteerMain.dart';
import 'package:appilcation_for_ncds/AddPost.dart';
import 'package:appilcation_for_ncds/function/DisplayTime.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appilcation_for_ncds/models/AuthDataModels.dart';
import 'widgetShare/ShowAlet.dart';
import 'package:appilcation_for_ncds/Chat.dart';
import 'package:appilcation_for_ncds/services/shared_preferences_service.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:appilcation_for_ncds/widgetShare/BuildAcceptUsersPage.dart';

class MainPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _MainPage();
  }
}

class _MainPage extends State<MainPage> {
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
  final PrefService _prefService = PrefService();
  DateTime logoutTime;
  String _userLogId = "";
  int index;
  List<String> listNcds = List();
  void initState() {
    // print(_userLogId);
    super.initState();
    asyncSingUp();
    _items = _generateItems;
    _headline = _items.firstWhere((item) => item.isSelected).text;
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

  Map<String, dynamic> userData;
  var _docRefPatient = FirebaseFirestore.instance
      .collection("MobileUser")
      .where("Role", isEqualTo: "Patient")
      .snapshots();

  String groupChatId;
  String groupChatIds;
  List<CollapsibleItem> _items;
  String _headline;
  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
        text: 'ระบบด้วยรวม',
        icon: Icons.stacked_bar_chart_sharp,
        onPressed: () => setState(() => _headline = 'all'),
        isSelected: true,
      ),
      CollapsibleItem(
        text: 'ผู้ป่วย',
        icon: Icons.people_alt,
        onPressed: () => setState(() => _headline = 'patient'),
      ),
      CollapsibleItem(
        text: 'อสม.',
        icon: Icons.assignment_ind,
        onPressed: () => setState(() => _headline = 'volenter'),
      ),
      CollapsibleItem(
        text: 'แชทพูดคุย',
        icon: IconData(0xe153, fontFamily: 'MaterialIcons'),
        onPressed: () => setState(() => _headline = 'chat'),
      ),
      CollapsibleItem(
        text: 'โพสต์',
        icon: Icons.post_add,
        onPressed: () => setState(() => _headline = 'post'),
      ),
      CollapsibleItem(
        text: 'ยืนยันสมัครเข้าใช้งาน',
        icon: IconData(0xe159, fontFamily: 'MaterialIcons'),
        onPressed: () => setState(() => _headline = 'accept'),
      ),
    ];
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (auth.currentUser != null) {
      return
          // DefaultTabController(
          //   initialIndex: 0,
          //   length: 6,
          //   child:
          Container(
        child: Scaffold(
          backgroundColor: Colors.blueGrey[50],
          appBar: AppBar(
            leading: Image.asset("icon/logo.png"),
            centerTitle: false,
            title: Text(
              "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
              style: TextStyle(color: Colors.black),
              // textAlign: TextAlign.left,
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
                            style: TextStyle(color: Colors.black),
                          ),
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
            //   bottom: TabBar(
            //     indicatorColor: Color.fromRGBO(255, 211, 251, 1),
            //     tabs: <Widget>[
            //       Tab(
            //         child: Text(
            //           "ระบบด้วยรวม",
            //           style: TextStyle(color: Colors.black),
            //         ),
            //         icon: Icon(
            //           Icons.people_alt,
            //           color: Colors.black,
            //         ),
            //       ),
            //       Tab(
            //         // text: 'ผู้ป่วย',
            //         child: Text(
            //           "ผู้ป่วย",
            //           style: TextStyle(color: Colors.black),
            //         ),
            //         icon: Icon(
            //           Icons.emoji_people,
            //           color: Colors.black,
            //         ),
            //       ),
            //       Tab(
            //         child: Text(
            //           "โพสต์",
            //           style: TextStyle(color: Colors.black),
            //         ),
            //         icon: Icon(
            //           Icons.post_add,
            //           color: Colors.black,
            //         ),
            //       ),
            //       Tab(
            //         child: Text(
            //           "อสม.",
            //           style: TextStyle(color: Colors.black),
            //         ),
            //         icon: Icon(
            //           Icons.emoji_people,
            //           color: Colors.black,
            //         ),
            //       ),
            //       Tab(
            //         child: Text(
            //           "แชทพูดคุย",
            //           style: TextStyle(color: Colors.black),
            //         ),
            //         icon: Icon(IconData(0xe153, fontFamily: 'MaterialIcons'),
            //             color: Colors.black),
            //       ),
            //       Tab(
            //         child: Text(
            //           "ยืนยันผู้สมัครเข้าใช้งาน",
            //           style: TextStyle(color: Colors.black),
            //         ),
            //         icon: Icon(IconData(0xe159, fontFamily: 'MaterialIcons'),
            //             color: Colors.black),
            //       ),
            //     ],
            //   ),
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
        ),
      );
      // );
    } else {
      Navigator.pushNamed(context, '/');
    }
  }

  Widget _body(Size size, BuildContext context, String selected) {
    if (selected == "all") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blueGrey[50],
        child: Center(child: AllStarus()),
      );
    } else if (selected == "patient") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        // color: Colors.blueGrey[50],
        child: Center(child: BuildPatientSearch(role: true)),
      );
    } else if (selected == "post") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        // color: Colors.blueGrey[50],
        child: Center(child: buildPostPage(context)),
      );
    } else if (selected == "volenter") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        // color: Colors.blueGrey[50],
        child: Center(child: BuildVolunteerSearch()),
      );
    } else if (selected == "chat") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        // color: Colors.blueGrey[50],
        child: Center(child: ChatSearchPage()),
      );
    } else if (selected == "accept") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        // color: Colors.blueGrey[50],
        child: Center(child: BuildAcceptUsersPage()),
      );
    }
    return Container(
      height: double.infinity,
      width: double.infinity,
      // color: Colors.blueGrey[50],
      child: Center(child: AllStarus()),
    );
  }

  Widget buildAcceptUsersPage(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 700,
        width: 1200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                child: Text(
                  'ยืนยันผู้สมัครเข้าใช้งาน',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 60),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 0, bottom: 20),
                              child: Text(
                                "บุคลากรทาการแพทย์",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: _docRef
                                      .where('role',
                                          isEqualTo: "medicalpersonnel")
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView(
                                        children: snapshot.data.docs
                                            .map((DocumentSnapshot document) {
                                          Map<String, dynamic> snap = document
                                              .data() as Map<String, dynamic>;
                                          return ListTile(
                                            title: Text(
                                                "${snap["Firstname"]}  ${snap["Lastname"]}"),
                                            subtitle: Text(
                                                checkRoletoThai(snap["role"])),
                                            trailing: Switch(
                                              value: snap["status"],
                                              onChanged: (value) {
                                                docId = (snapshot.data.docs
                                                    .map((e) => e.reference)
                                                    .toList());
                                                print(
                                                    "DocumentReference<Map<String, dynamic>>(UserWeb/" +
                                                        document.id +
                                                        ")");
                                                // for find index in DocmentReference.
                                                for (int i = 0;
                                                    i < docId.length;
                                                    i++) {
                                                  if (docId[i].toString() ==
                                                      "DocumentReference<Map<String, dynamic>>(UserWeb/" +
                                                          document.id +
                                                          ")") {
                                                    index = i;
                                                  }
                                                }
                                                FirebaseFirestore.instance
                                                    .runTransaction(
                                                        (transaction) async {
                                                  DocumentSnapshot freshSnap =
                                                      await transaction
                                                          .get(docId[index]);
                                                  await transaction.update(
                                                      freshSnap.reference,
                                                      {"status": value});
                                                });
                                              },
                                              activeTrackColor:
                                                  Colors.lightGreenAccent,
                                              activeColor: Colors.green,
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    } else {
                                      return Center(
                                        child: Text("กำลังโหลดข้อมูล"),
                                      );
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 2,
                      color: Colors.grey.shade400,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 60),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 0, bottom: 20),
                              child: Text(
                                "อสม.และ ผู้ป่วย",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: _docRefMobile.snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView(
                                        children: snapshot.data.docs
                                            .map((DocumentSnapshot document) {
                                          Map<String, dynamic> snap = document
                                              .data() as Map<String, dynamic>;
                                          return ListTile(
                                            subtitle: Text(
                                                checkRoletoThai(snap["Role"])),
                                            // leading: Padding(
                                            //   padding: const EdgeInsets.all(0),
                                            //   child: proFileShow(
                                            //       context,
                                            //       document["Img"],
                                            //       document["Gender"]),
                                            // ),
                                            title: Row(children: [
                                              Text(
                                                  "${snap["Firstname"]}  ${snap["Lastname"]}"),
                                              if (snap["isBoss"] == true)
                                                Text("(หัวหน้าอสม.)"),
                                            ]),

                                            // subtitle: Text("${snap["Lastname"]}"),
                                            trailing: Switch(
                                              value: snap["status"],
                                              onChanged: (value) {
                                                docId = (snapshot.data.docs
                                                    .map((e) => e.reference)
                                                    .toList());
                                                print(
                                                    "DocumentReference<Map<String, dynamic>>(MobileUser/" +
                                                        document.id +
                                                        ")");
                                                // for find index in DocmentReference.
                                                for (int i = 0;
                                                    i < docId.length;
                                                    i++) {
                                                  if (docId[i].toString() ==
                                                      "DocumentReference<Map<String, dynamic>>(MobileUser/" +
                                                          document.id +
                                                          ")") {
                                                    index = i;
                                                  }
                                                }
                                                FirebaseFirestore.instance
                                                    .runTransaction(
                                                        (transaction) async {
                                                  DocumentSnapshot freshSnap =
                                                      await transaction
                                                          .get(docId[index]);
                                                  await transaction.update(
                                                      freshSnap.reference,
                                                      {"status": value});
                                                });
                                              },
                                              activeTrackColor:
                                                  Colors.lightGreenAccent,
                                              activeColor: Colors.green,
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    } else {
                                      return Center(
                                        child: Text("กำลังโหลดข้อมูล"),
                                      );
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }

  Widget buildPostPage(BuildContext context) {
    return Card(
      color: Colors.grey.shade50,
      child: SizedBox(
        height: 800,
        width: 1000,
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  'โพสต์แนะนำ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: contentPage(context),
            ),
            Center(
              child: bulidButtonAddPost(context),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }

  Widget buildAcceptPage(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 800,
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

  Widget bulidButtonAddPost(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        hoverColor: Colors.grey.shade200,
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
        color: Colors.white,
        textColor: Colors.white,
        child: Icon(
          Icons.add,
          size: 24,
          color: Colors.blueAccent,
        ),
        padding: EdgeInsets.all(16),
        shape: CircleBorder(),
      ),
    );
  }

  Widget buildContentPost(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection("RecommendPost").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> snap =
                    document.data() as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () => null,
                  child: Card(
                    color: Colors.amber,
                    child: SizedBox(
                      height: 400,
                      width: 90,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Text(
                                          "หัวเรื่อง  :",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Text("${snap["topic"]}"),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Text(
                                          "เนื้อเรื่อง :",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              "${snap["content"]}",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Text(
                                          "ผู้สร้างโพสต์แนะนำ :",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${snap["createBy"]}",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Text(
                                          "เหมะสำหรับผู้ป่วย :",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "อายุ:  ${snap["recommentForAge"]}",
                                            ),
                                            Text(
                                              "ค่าBMI:  ${snap["recommentForBMI"]}",
                                            ),
                                            Text(
                                              "โรค:  ${snap["recommentForDieases"]}",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Text(
                                          "สร้างโพสต์เมื่อวันที่ :",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Text(
                                        convertDateTimeDisplay(snap["createAt"]
                                                .toDate()
                                                .toString()) +
                                            "" +
                                            "สร้างมาแล้ว :" +
                                            "" +
                                            calCreateDay(convertDateTimeDisplay(
                                                snap["createAt"]
                                                    .toDate()
                                                    .toString())) +
                                            "วัน",
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Text(
                                          "สร้างโพสต์เมื่อเวลา :",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Text(
                                        convertTimeDisplay(snap["createAt"]),
                                      ),
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
                );
              }).toList(),
            );
          } else {
            return Text("ไม่มีโพสต์แนะนำ");
          }
        });
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

  Widget actionMenu(String role) {
    return PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: Colors.black,
        ),
        // child: Text(userData["name"]),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.add_chart_outlined),
                  title: Text('ประเมินการใช้งาน'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EvaulatePage(
                          role: role,
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

  getAuthData(DocumentReference<Map<String, dynamic>> value) async {
    await FirebaseFirestore.instance
        .collection("UserWeb")
        .doc(auth.currentUser.uid)
        .get()
        .then((value) {
      var getData = value.data();
      setState(() {
        _authDataModels.name = getData["Firstname"];
        _authDataModels.role = getData["role"];
        _authDataModels.surname = getData["Lastname"];
      });
    });
  }

  getChatNoti() async {
    Future getChat;
    getChat = (await FirebaseFirestore.instance
        .collection("Messages")
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy('timestamp', descending: false)
        .get()) as Future;
    getChat.then((value) {});
  }
}
