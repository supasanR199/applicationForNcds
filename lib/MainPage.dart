import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appilcation_for_ncds/PatientMain.dart';
import 'package:appilcation_for_ncds/VolunteerMain.dart';

class MainPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _MainPage();
  }
}

class _MainPage extends State<MainPage> {
  @override
  final auth = FirebaseAuth.instance;
  var user;
  var _docRef = FirebaseFirestore.instance
      .collection('UserWeb')
      .where('role', isNotEqualTo: 'admin');
  var _docRefMobile = FirebaseFirestore.instance.collection("MobileUser");
  var docId;
  int index;

  Map<String, dynamic> userData;
  var _docRefPatient = FirebaseFirestore.instance
      .collection("MobileUser")
      .where("Role", isEqualTo: "Patient")
      .snapshots();
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            actions: [
              FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("UserWeb")
                      .doc(auth.currentUser.uid)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    userData = snapshot.data.data() as Map<String, dynamic>;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${userData['name']}  ${userData['surname']}"),
                      ],
                    );
                  }),
              actionMenu(),
            ],
            bottom: TabBar(
              indicatorColor: Color.fromRGBO(255, 211, 251, 1),
              tabs: <Widget>[
                Tab(
                  text: 'ผู้ป่วย',
                  icon: Icon(Icons.cloud_outlined),
                ),
                Tab(
                  text: 'โพสต์',
                  icon: Icon(Icons.beach_access_sharp),
                ),
                Tab(
                  text: 'อสม.',
                  icon: Icon(Icons.cloud_outlined),
                ),
                Tab(
                  text: 'แชทพูดคุย',
                  icon: Icon(Icons.cloud_outlined),
                ),
                Tab(
                  text: 'ยืนยันผู้สมัครเข้าใช้งาน',
                  icon: Icon(Icons.add_alert),
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
                child: buildPostPage(context),
              ),
              Center(
                child: buildVolunteerPage(context),
              ),
              Center(
                child: buildChat(context),
              ),
              Center(
                child: buildAcceptUsersPage(context),
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
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Text(
                  'ผู้ป่วย',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _docRefPatient,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  return ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> snap =
                          document.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text("${snap["Firstname"]}"),
                        subtitle: Text("${snap["Lastname"]}"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientMain(
                                  patienData: snap,
                                  patienDataId: document.reference),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAcceptUsersPage(BuildContext context) {
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
                  'ยืนยันผู้สมัครเข้าใช้งาน',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40, bottom: 0),
              child: Expanded(
                child: Text(
                  "บุคลากรทาการแพทย์",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _docRef
                      .where('role', isEqualTo: "medicalpersonnel")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    return ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> snap =
                            document.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text("${snap["name"]}"),
                          subtitle: Text("${snap["surname"]}"),
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
                              for (int i = 0; i < docId.length; i++) {
                                if (docId[i].toString() ==
                                    "DocumentReference<Map<String, dynamic>>(UserWeb/" +
                                        document.id +
                                        ")") {
                                  index = i;
                                }
                              }
                              FirebaseFirestore.instance
                                  .runTransaction((transaction) async {
                                DocumentSnapshot freshSnap =
                                    await transaction.get(docId[index]);
                                await transaction.update(
                                    freshSnap.reference, {"status": value});
                              });
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                        );
                      }).toList(),
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0, bottom: 0),
              child: Expanded(
                child: Text(
                  "อสม. ผู้ป่วย",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _docRefMobile.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    return ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> snap =
                            document.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text("${snap["Firstname"]}"),
                          subtitle: Text("${snap["Lastname"]}"),
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
                              for (int i = 0; i < docId.length; i++) {
                                if (docId[i].toString() ==
                                    "DocumentReference<Map<String, dynamic>>(UserWeb/" +
                                        document.id +
                                        ")") {
                                  index = i;
                                }
                              }
                              FirebaseFirestore.instance
                                  .runTransaction((transaction) async {
                                DocumentSnapshot freshSnap =
                                    await transaction.get(docId[index]);
                                await transaction.update(
                                    freshSnap.reference, {"status": value});
                              });
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                        );
                      }).toList(),
                    );
                  }),
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
              child: ListView(
                children: [
                  buildContentPost(context),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: bulidButtonAddPost(context),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAcceptPage(BuildContext context) {
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

  Widget buildVolunteerPage(BuildContext context) {
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
                  'อสม.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("MobileUser")
                    .where("Role", isEqualTo: "Volunteer")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  return ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> snap =
                          document.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text("${snap["Firstname"]}"),
                        subtitle: Text("${snap["Lastname"]}"),
                         onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VolunteerMain(
                                  volunteerData: snap,
                                  volunteerDataId: document.reference),
                            ),
                          );
                         }
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bulidButtonAddPost(BuildContext context) {
    return MaterialButton(
      onPressed: () => Navigator.pushNamed(context, '/addpost'),
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

  Widget buildContentPost(BuildContext context) {
    return Card(
      color: Colors.amber,
      child: SizedBox(
        height: 200,
        width: 90,
      ),
    );
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

  Widget buildContentPatient(BuildContext context) {
    return Row(
      children: [
        // StreamBuilder<QuerySnapshot>(
        //   stream: _docRefPatient,
        //   builder:
        //       (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //     return ListView(
        //       children: snapshot.data.docs.map((DocumentSnapshot document) {
        //         Map<String, dynamic> snap =
        //             document.data() as Map<String, dynamic>;
        //         return ListTile(
        //           title: Text("${snap["name"]}"),
        //           subtitle: Text("${snap["surname"]}"),
        //           //
        //         );
        //       }).toList(),
        //     );
        //   },
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            // color: Colors.accents,
            onPressed: () => requestData(),
            child: Text('ข้อมูล'),
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
            onPressed: () => Navigator.pushNamed(context, '/labresults'),
            child: Text('แจ้งผลตรวจจากห้องทดลอง'),
            color: Colors.green,
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
          ),
        )
      ],
    );
  }

  Widget buildChat(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.amber,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text('col1'),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  color: Colors.red,
                  child: Text('col1'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget actionMenu() {
    return PopupMenuButton(
        icon: Icon(Icons.more_vert),
        // child: Text(userData["name"]),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Item 1'),
                ),
              ),
            ]);
  }

  requestData() async {
    return await FirebaseFirestore.instance
        .collection("UserWeb")
        .doc(auth.currentUser.uid)
        .get()
        .then((value) {
      user = value.data();
    });
  }

  Widget userText() {
    requestData();
    return Text(user["name"]);
  }
}
