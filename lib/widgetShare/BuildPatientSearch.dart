import 'package:appilcation_for_ncds/PatientMain.dart';
import 'package:appilcation_for_ncds/function/checkRole.dart';
import 'package:appilcation_for_ncds/widgetShare/ProfilePhoto.dart';
import 'package:appilcation_for_ncds/widgetShare/StatusPatient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuildPatientSearch extends StatefulWidget {
  bool role;
  BuildPatientSearch({Key key, @required this.role}) : super(key: key);

  @override
  State<BuildPatientSearch> createState() => _BuildPatientSearchState();
}

class _BuildPatientSearchState extends State<BuildPatientSearch> {
  @override
  var _docRefPatient = FirebaseFirestore.instance
      .collection("MobileUser")
      .where("Role", isEqualTo: "Patient")
      .snapshots();
  TextEditingController _searchController = TextEditingController();
  CollectionReference _allPatient =
      FirebaseFirestore.instance.collection("MobileUser");
  List<DocumentSnapshot> documents = [];
  String searchText = '';
  bool isHospital;
  Widget build(BuildContext context) {
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
            // Expanded(child: ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderSide: const BorderSide(width: 3, color: Colors.red),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    _allPatient.where("Role", isEqualTo: "Patient").snapshots(),
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
                            .contains(searchText.toLowerCase());
                      }).toList();
                    }
                    return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          var path;
                          try {
                            path = documents[index]["img"];
                          } catch (e) {
                            path = "";
                          }
                          // if (documents[index]["Img"] == null) {
                          //   path =
                          //       "gs://applicationforncds.appspot.com/MobileUserImg/Patient/not-available.png";
                          // } else {
                          //   path = documents[index]["Img"];
                          // }
                          print(documents[index]["Img"]);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.pink[100], width: 3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              leading: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: proFileShow(context, path),
                              ),
                              title: Row(
                                children: [
                                  Column(
                                    children: [
                                      // Text(
                                      //   "${snap["Firstname"]}",
                                      //   softWrap: false,
                                      // ),
                                      Text.rich(
                                        TextSpan(
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${documents[index]["Firstname"]}  ${documents[index]["Lastname"]}",
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      statusAlert(documents[index].id),
                                    ],
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                checkDisease(documents[index]["NCDs"]),
                              ),
                              // DecoratedBox(
                              //   decoration: BoxDecoration(
                              //       color: Color.fromRGBO(255, 211, 251, 1),
                              //       borderRadius: BorderRadius.circular(5)),
                              //   child: Padding(
                              //     padding: EdgeInsets.all(8.0),
                              //     child: Text(
                              //         checkDisease(documents[index]["NCDs"])),
                              //   ),
                              // ),
                              trailing: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("ข้อมูล"),
                                ),
                              ),
                              onTap: () {
                                Map<String, dynamic> snap = documents[index]
                                    .data() as Map<String, dynamic>;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PatientMain(
                                      patienData: snap,
                                      patienDataId: documents[index].reference,
                                      isHospital: widget.role,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        });
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
}
