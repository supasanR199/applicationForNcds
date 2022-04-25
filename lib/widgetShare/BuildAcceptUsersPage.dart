import 'package:appilcation_for_ncds/function/checkRole.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuildAcceptUsersPage extends StatefulWidget {
  const BuildAcceptUsersPage({Key key}) : super(key: key);

  @override
  State<BuildAcceptUsersPage> createState() => _BuildAcceptUsersPageState();
}

class _BuildAcceptUsersPageState extends State<BuildAcceptUsersPage> {
  @override
  var _docRef = FirebaseFirestore.instance
      .collection('UserWeb')
      .where('role', isNotEqualTo: 'admin');
  var docId;
  int index;
  var _docRefMobile = FirebaseFirestore.instance.collection("MobileUser");

  Widget build(BuildContext context) {
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
}
