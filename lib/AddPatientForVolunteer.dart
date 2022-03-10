import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPatienFoorVolunteer extends StatefulWidget {
  var volunteerData;
  var volunteerDataId;
  AddPatienFoorVolunteer(
      {Key key, @required this.volunteerData, @required this.volunteerDataId})
      : super(key: key);

  @override
  _AddPatienFoorVolunteerState createState() => _AddPatienFoorVolunteerState();
}

class _AddPatienFoorVolunteerState extends State<AddPatienFoorVolunteer> {
  int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 211, 251, 1),
        appBar: AppBar(
          title: Text(
            "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: Center(
            child: Card(
              child: SizedBox(
                height: 700,
                width: 1000,
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 20,
                        ),
                        child: Text(
                          'เพิ่มผู้ป่วยให้หัวหน้าอสม.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "ผู้ป่วยทั้งหมด",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("MobileUser")
                                        .where(
                                          "Role",
                                          isEqualTo: "Patient",
                                        )
                                        // .where("isHaveCaretaker",
                                        //     isEqualTo: null)
                                        .where("isHaveCaretaker",
                                            isEqualTo: false)
                                        // .where("isHaveCaretaker", isNull: true)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        setToHaveCareTaker();
                                        return ListView(
                                          children: snapshot.data.docs
                                              .map((DocumentSnapshot document) {
                                            Map<String, dynamic> snap = document
                                                .data() as Map<String, dynamic>;
                                            if (snap["isHaveCaretaker"] ==
                                                null) {
                                              FirebaseFirestore.instance
                                                  .collection("MobileUser")
                                                  .doc(document.id)
                                                  .update({
                                                "isHaveCaretaker": true
                                              });
                                            }
                                            return ListTile(
                                              title: Text(
                                                "${snap["Firstname"]}",
                                              ),
                                              subtitle: Text(
                                                "${snap["Lastname"]}",
                                              ),
                                              onTap: () async {
                                                await FirebaseFirestore.instance
                                                    .collection("MobileUser")
                                                    .doc(widget
                                                        .volunteerDataId.id)
                                                    .collection(
                                                        "PatientTakeCare")
                                                    .doc(document.id)
                                                    .set({
                                                  "Firstname":
                                                      widget.volunteerData[
                                                          "Firstname"],
                                                  "Lastname":
                                                      widget.volunteerData[
                                                          "Firstname"],
                                                  "DocId":
                                                      widget.volunteerDataId.id,
                                                });
                                                await FirebaseFirestore.instance
                                                    .collection("MobileUser")
                                                    .doc(document.id)
                                                    .update({
                                                  "CareTakerIs":
                                                      widget.volunteerDataId.id
                                                });
                                                var docId = (snapshot.data.docs
                                                    .map((e) => e.reference)
                                                    .toList());
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
                                                      freshSnap.reference, {
                                                    "isHaveCaretaker": true
                                                  });
                                                });
                                              },
                                            );
                                          }).toList(),
                                        );
                                      } else {
                                        return Center(
                                          child: Text("กำลังโหลข้อมูล"),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "ผู้ป่วยที่อยู่ในการดูแลของ ${widget.volunteerData["Firstname"]}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("MobileUser")
                                        .where("Role", isEqualTo: "Patient")
                                        .where("isHaveCaretaker",
                                            isEqualTo: true).where("CareTakerIs",isEqualTo: widget.volunteerDataId.id)
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
                                              title:
                                                  Text("${snap["Firstname"]}"),
                                              subtitle:
                                                  Text("${snap["Lastname"]}"),
                                              onTap: () async {
                                                await FirebaseFirestore.instance
                                                    .collection("MobileUser")
                                                    .doc(widget
                                                        .volunteerDataId.id)
                                                    .collection(
                                                        "PatientTakeCare")
                                                    .doc(document.id)
                                                    .delete();
                                                await FirebaseFirestore.instance
                                                    .collection("MobileUser")
                                                    .doc(document.id)
                                                    .update(
                                                        {"CareTakerIs": null});
                                                var docId = (snapshot.data.docs
                                                    .map((e) => e.reference)
                                                    .toList());
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
                                                      freshSnap.reference, {
                                                    "isHaveCaretaker": false
                                                  });
                                                });
                                              },
                                            );
                                          }).toList(),
                                        );
                                      } else {
                                        return Center(
                                          child: Text("กำลังโหลข้อมูล"),
                                        );
                                      }
                                    },
                                  ),
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
          ),
        ),
      ),
    );
  }

  Future setToHaveCareTaker() async {
    var getPatient = await FirebaseFirestore.instance
        .collection("MobileUser")
        .where("Role", isEqualTo: "Patient")
        .get();
    print(getPatient);
  }
}
