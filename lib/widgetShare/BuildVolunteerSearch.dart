import 'package:appilcation_for_ncds/VolunteerMain.dart';
import 'package:appilcation_for_ncds/widgetShare/ProfilePhoto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

class BuildVolunteerSearch extends StatefulWidget {
  BuildVolunteerSearch({Key key}) : super(key: key);

  @override
  State<BuildVolunteerSearch> createState() => _BuildVolunteerSearchState();
}

class _BuildVolunteerSearchState extends State<BuildVolunteerSearch> {
  @override
  CollectionReference _allVolunteers =
      FirebaseFirestore.instance.collection("MobileUser");
  List<DocumentSnapshot> documents = [];
  String searchText = '';
  TextEditingController _searchController = TextEditingController();

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
                  'อสม.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
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
                stream: _allVolunteers
                    .where("Role", isEqualTo: "Volunteer")
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
                            .contains(searchText.toLowerCase());
                      }).toList();
                    }
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        // var path;
                        // if (documents[index]["Img"] == null) {
                        //   path =
                        //       "gs://applicationforncds.appspot.com/MobileUserImg/Patient/not-available.png";
                        // } else {
                        //   path = documents[index]["Img"];
                        // }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side:
                                  BorderSide(color: Colors.pink[100], width: 3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // leading: proFileShow(context, path),
                            title: Row(children: [
                              Text(
                                  "${documents[index]["Firstname"]}  ${documents[index]["Lastname"]}"),
                              if (documents[index]["isBoss"] == true)
                                Text("(หัวหน้าอสม.)"),
                            ]),
                            // subtitle: Text("${snap["Lastname"]}"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VolunteerMain(
                                      volunteerData: documents[index],
                                      volunteerDataId:
                                          documents[index].reference),
                                ),
                              );
                            },
                          ),
                        );
                      },
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
}
