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
  List<DocumentSnapshot> documents = [];
  List<DocumentSnapshot> documents0 = [];
  String searchText = '';
  TextEditingController _searchController = TextEditingController();
  String searchText0 = '';
  TextEditingController _searchController0 = TextEditingController();

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
                            // Padding(
                            //   padding: EdgeInsets.only(top: 0, bottom: 20),
                            //   child: Text(
                            //     "บุคลากรทาการแพทย์",
                            //     style: TextStyle(fontSize: 20),
                            //   ),
                            // ),
                            TextFormField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  searchText = value;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'ค้นหา',
                                enabledBorder: OutlineInputBorder(
                                  // borderSide: const BorderSide(width: 3, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  // borderSide: const BorderSide(width: 3, color: Colors.red),
                                  borderRadius: BorderRadius.circular(10),
                                ),
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
                                      documents = snapshot.data.docs;
                                      if (searchText.length > 0) {
                                        documents = documents.where((element) {
                                          return element
                                              .get('Firstname')
                                              .toString()
                                              .toLowerCase()
                                              .contains(
                                                  searchText.toLowerCase());
                                        }).toList();
                                      }
                                      return ListView.builder(
                                          itemCount: documents.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                  "${documents[index]["Firstname"]}  ${documents[index]["Lastname"]}"),
                                              subtitle: Text(
                                                checkRoletoThai(
                                                    documents[index]["role"]),
                                              ),
                                              trailing: Switch(
                                                value: documents[index]
                                                    ["status"],
                                                onChanged: (value) {
                                                  docId = (snapshot.data.docs
                                                      .map((e) => e.reference)
                                                      .toList());
                                                  print(
                                                      "DocumentReference<Map<String, dynamic>>(UserWeb/" +
                                                          documents[index].id +
                                                          ")");
                                                  // for find index in DocmentReference.
                                                  for (int i = 0;
                                                      i < docId.length;
                                                      i++) {
                                                    if (docId[i].toString() ==
                                                        "DocumentReference<Map<String, dynamic>>(UserWeb/" +
                                                            documents[index]
                                                                .id +
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
                                          });
                                    } else {
                                      return Center(
                                        child: Text("กำลังโหลดข้อมูล"),
                                      );
                                    }
                                  }),
                            ),
                            Padding(padding: EdgeInsets.all(20)),
                            TextFormField(
                              controller: _searchController0,
                              onChanged: (value) {
                                setState(() {
                                  searchText0 = value;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'ค้นหา',
                                enabledBorder: OutlineInputBorder(
                                  // borderSide: const BorderSide(width: 3, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  // borderSide: const BorderSide(width: 3, color: Colors.red),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: _docRefMobile.snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      documents0 = snapshot.data.docs;
                                      documents0.forEach((e) {});
                                      if (searchText0.length > 0) {
                                        documents0 =
                                            documents0.where((element) {
                                          return element
                                              .get('Firstname')
                                              .toString()
                                              .toLowerCase()
                                              .contains(
                                                  searchText0.toLowerCase());
                                        }).toList();
                                      }
                                      return ListView.builder(
                                          itemCount: documents0.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Row(children: [
                                                Text(
                                                    "${documents0[index]["Firstname"]}  ${documents0[index]["Lastname"]}"),
                                                // if (documents0[index]
                                                //         ["isBoss"] ==
                                                //     true)
                                                //   Text("(หัวหน้าอสม.)"),
                                              ]),
                                              subtitle: Text(checkRoletoThai(
                                                  documents0[index]["Role"])),
                                              trailing: Switch(
                                                value: documents0[index]
                                                    ["status"],
                                                onChanged: (value) {
                                                  docId = (snapshot.data.docs
                                                      .map((e) => e.reference)
                                                      .toList());
                                                  print(
                                                      "DocumentReference<Map<String, dynamic>>(MobileUser/" +
                                                          documents0[index].id +
                                                          ")");
                                                  // for find index in DocmentReference.
                                                  for (int i = 0;
                                                      i < docId.length;
                                                      i++) {
                                                    if (docId[i].toString() ==
                                                        "DocumentReference<Map<String, dynamic>>(MobileUser/" +
                                                            documents[index]
                                                                .id +
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
                                          });
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
                    // Container(
                    //   width: 2,
                    //   color: Colors.grey.shade400,
                    // ),
                    // Expanded(
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(horizontal: 60),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         // Padding(
                    //         //   padding: EdgeInsets.only(top: 0, bottom: 20),
                    //         //   child: Text(
                    //         //     "อสม.และ ผู้ป่วย",
                    //         //     style: TextStyle(fontSize: 20),
                    //         //   ),
                    //         // ),
                    //         TextFormField(
                    //           controller: _searchController0,
                    //           onChanged: (value) {
                    //             setState(() {
                    //               searchText0 = value;
                    //             });
                    //           },
                    //           decoration: InputDecoration(
                    //             labelText: 'ค้นหา',
                    //             enabledBorder: OutlineInputBorder(
                    //               // borderSide: const BorderSide(width: 3, color: Colors.blue),
                    //               borderRadius: BorderRadius.circular(10),
                    //             ),
                    //             focusedBorder: OutlineInputBorder(
                    //               // borderSide: const BorderSide(width: 3, color: Colors.red),
                    //               borderRadius: BorderRadius.circular(10),
                    //             ),
                    //           ),
                    //         ),
                    //         Expanded(
                    //           child: StreamBuilder<QuerySnapshot>(
                    //               stream: _docRefMobile.snapshots(),
                    //               builder: (BuildContext context,
                    //                   AsyncSnapshot<QuerySnapshot> snapshot) {
                    //                 if (snapshot.hasData) {
                    //                   documents0 = snapshot.data.docs;
                    //                   documents0.forEach((e) {});
                    //                   if (searchText0.length > 0) {
                    //                     documents0 = documents0.where((element) {
                    //                       return element
                    //                           .get('Firstname')
                    //                           .toString()
                    //                           .toLowerCase()
                    //                           .contains(
                    //                               searchText0.toLowerCase());
                    //                     }).toList();
                    //                   }
                    //                   return ListView.builder(
                    //                       itemCount: documents0.length,
                    //                       itemBuilder: (context, index) {
                    //                         return ListTile(
                    //                           title: Row(children: [
                    //                             Text(
                    //                                 "${documents0[index]["Firstname"]}  ${documents0[index]["Lastname"]}"),
                    //                             // if (documents0[index]
                    //                             //         ["isBoss"] ==
                    //                             //     true)
                    //                             //   Text("(หัวหน้าอสม.)"),
                    //                           ]),
                    //                           subtitle: Text(checkRoletoThai(
                    //                               documents0[index]["Role"])),
                    //                           trailing: Switch(
                    //                             value: documents0[index]
                    //                                 ["status"],
                    //                             onChanged: (value) {
                    //                               docId = (snapshot.data.docs
                    //                                   .map((e) => e.reference)
                    //                                   .toList());
                    //                               print(
                    //                                   "DocumentReference<Map<String, dynamic>>(MobileUser/" +
                    //                                       documents0[index].id +
                    //                                       ")");
                    //                               // for find index in DocmentReference.
                    //                               for (int i = 0;
                    //                                   i < docId.length;
                    //                                   i++) {
                    //                                 if (docId[i].toString() ==
                    //                                     "DocumentReference<Map<String, dynamic>>(MobileUser/" +
                    //                                         documents[index]
                    //                                             .id +
                    //                                         ")") {
                    //                                   index = i;
                    //                                 }
                    //                               }
                    //                               FirebaseFirestore.instance
                    //                                   .runTransaction(
                    //                                       (transaction) async {
                    //                                 DocumentSnapshot freshSnap =
                    //                                     await transaction
                    //                                         .get(docId[index]);
                    //                                 await transaction.update(
                    //                                     freshSnap.reference,
                    //                                     {"status": value});
                    //                               });
                    //                             },
                    //                             activeTrackColor:
                    //                                 Colors.lightGreenAccent,
                    //                             activeColor: Colors.green,
                    //                           ),
                    //                         );
                    //                       });
                    //                 } else {
                    //                   return Center(
                    //                     child: Text("กำลังโหลดข้อมูล"),
                    //                   );
                    //                 }
                    //               }),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
