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
  void initState() {
    super.initState();
    setImgToNull();
  }

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
  setImgToNull() async {
    await FirebaseFirestore.instance
        .collection("MobileUser")
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        if (element.data()["Img"] == null) {
          await FirebaseFirestore.instance
              .collection("MobileUser")
              .doc(element.id)
              .update({"Img": ""});
        } else {
          print("isNotNull");
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 700,
        width: 1200,
        child: Row(
          children: [
            SizedBox(
              height: 700,
              width: 350,
              child: Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                        child: Image.asset(
                      "icon/consent.png",
                      scale: 4,
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        'รายชื่อผู้ป่วย',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "   ท่านสามารถค้นหาชื่อผู้ป่วยในระบบและคลิกที่รายชื่อผู้ป่วยเพื่อดูข้อมูลได้",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          IconData(0xe04a, fontFamily: 'MaterialIcons'),
                          color: Colors.red,
                        ),
                        Text(
                          "   ผู้ป่วยมีพฤติกรรมเสี่ยง",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        Icon(
                          IconData(0xe04a, fontFamily: 'MaterialIcons'),
                          color: Colors.green,
                        ),
                        Text(
                          "   ผู้ป่วยยังไม่มีความเสี่ยง",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.modulate,
                    ),
                    image: AssetImage("img/patientpage.jpg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    // Center(
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(
                    //       top: 10,
                    //     ),
                    //     child: Text(
                    //       'ผู้ป่วย',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(fontSize: 40),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 30,
                    ),
                    // Expanded(child: ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      child: TextFormField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            searchText = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'ค้นหาผู้ป่วย',
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
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _allPatient
                            .where("Role", isEqualTo: "Patient")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            documents = snapshot.data.docs;
                            documents.forEach((e) {});
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
                                  // if (documents[index]["Img"] == null) {
                                  //   documents[index]["Img"].add("");
                                  // }
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 60),
                                    // padding: const EdgeInsets.all(0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              shape: RoundedRectangleBorder(
                                                // side: BorderSide(
                                                //     color: Colors.pink[100], width: 3),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              leading: Padding(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                child: proFileShow(
                                                    context,
                                                    documents[index]["Img"],
                                                    documents[index]["Gender"]),
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
                                                      StatusAlert(
                                                          id: documents[index]
                                                              .id),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              subtitle: Text(
                                                checkDisease(
                                                    documents[index]["NCDs"]),
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
                                                    color: Colors
                                                        .greenAccent.shade700,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "ข้อมูล",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              hoverColor: Colors.grey.shade200,
                                              onTap: () {
                                                Map<String, dynamic> snap =
                                                    documents[index].data()
                                                        as Map<String, dynamic>;
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PatientMain(
                                                      patienData: snap,
                                                      patienDataId:
                                                          documents[index]
                                                              .reference,
                                                      isHospital: widget.role,
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
                                        )),
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
}
