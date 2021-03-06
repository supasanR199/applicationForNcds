import 'package:appilcation_for_ncds/PatientMain.dart';
import 'package:appilcation_for_ncds/function/checkRole.dart';
import 'package:appilcation_for_ncds/widgetShare/ProfilePhoto.dart';
import 'package:appilcation_for_ncds/widgetShare/StatusPatient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

var _docRefPatient = FirebaseFirestore.instance
    .collection("MobileUser")
    .where("Role", isEqualTo: "Patient")
    .snapshots();
TextEditingController _searchController = TextEditingController();
CollectionReference allPatient =
    FirebaseFirestore.instance.collection("MobileUser");
List<DocumentSnapshot> documents = [];
String searchText = '';
bool isHospital;
Widget buildPatientPage(BuildContext context, bool role) {
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
              stream: _docRefPatient,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> snap =
                          document.data() as Map<String, dynamic>;
                      var path;
                      if (snap["Img"] == null) {
                        path =
                            "gs://applicationforncds.appspot.com/MobileUserImg/Patient/not-available.png";
                      } else {
                        path = snap["Img"];
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              side:
                                  BorderSide(color: Colors.pink[100], width: 3),
                              borderRadius: BorderRadius.circular(20)),
                          leading: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                proFileShow(context, path, "${snap["Gender"]}"),
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
                                              "${snap["Firstname"]}  ${snap["Lastname"]}",
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  StatusAlert(id: document.id),
                                ],
                              ),
                            ],
                          ),
                          // subtitle: Text("${snap["Lastname"]}"),
                          trailing: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 211, 251, 1),
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(checkDisease(snap["NCDs"])),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientMain(
                                  patienData: snap,
                                  patienDataId: document.reference,
                                  isHospital: role,
                                ),
                              ),
                            );
                          },
                        ),
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
