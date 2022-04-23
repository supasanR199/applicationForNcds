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
        width: 1200,
        child: Row(
          children: [
             SizedBox(
                        height: 700,
                        width: 350,
                       child : Container(
                         padding: const EdgeInsets.only(left: 30,right: 30),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             SizedBox(height: 40,),
                            //  Image.asset("icon/icon-hospital.png",scale: 4,),
                            Text('รายชื่อ อสม.',textAlign: TextAlign.center,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                             SizedBox(height: 5,),
                             Text("   ท่านสามารถค้นหาชื่อ อสม. ในระบบและคลิกที่รายชื่อ อสม.เพื่อดูข้อมูลได้ ในส่วนของหัวหน้า อสม.จะแสดงคำว่า (หัวหน้า อสม.) ต่อท้าย",style: TextStyle(color: Colors.white,fontSize: 20),),
                             SizedBox(height: 5,),
                            //  Row(
                            //    children: [
                            //      Icon(IconData(0xe04a, fontFamily: 'MaterialIcons'),color: Colors.red,),
                            //      Text("   ผู้ป่วยมีพฤติกรรมเสี่ยง",style: TextStyle(color: Colors.white,fontSize: 20),),
                            //    ],
                            //  ),
                            //  SizedBox(height: 3,),
                            //  Row(
                            //    children: [
                            //      Icon(IconData(0xe04a, fontFamily: 'MaterialIcons'),color: Colors.green,),
                            //      Text("   ผู้ป่วยยังไม่มีความเสี่ยง",style: TextStyle(color: Colors.white,fontSize: 20),),
                            //    ],
                            //  )                             
                           ],
                         ),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.shade100,
                              //   image: DecorationImage(
                              //     colorFilter: const ColorFilter.mode(
                              //       Colors.grey,
                              //       BlendMode.modulate,
                              //     ),
                              //   image: AssetImage("img/patientpage.jpg"),
                              //   fit: BoxFit.cover,
                                
                              // ),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)
                              ),
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
                //       'อสม.',
                //       textAlign: TextAlign.center,
                //       style: TextStyle(fontSize: 40),
                //     ),
                //   ),
                // ),
                SizedBox(height: 30,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  // padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'ค้นหา อสม.',
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
                SizedBox(height: 30,),
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
                              padding: EdgeInsets.symmetric(horizontal: 60),
                              // padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Column(
                                  children: [
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                        // side:
                                        //     BorderSide(
                                        //       color: Colors.pink[100], width: 3),
                                              borderRadius: BorderRadius.circular(20),
                                      ),
                                      // leading: proFileShow(context, path),
                                      title: Row(children: [
                                        Text(
                                            "${documents[index]["Firstname"]}  ${documents[index]["Lastname"]}"),
                                      ]),
                                      hoverColor: Colors.grey.shade200,
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
                                      trailing : Container(
                                        child:  Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                          if (documents[index]["isBoss"] == true)
                                          Text("(หัวหน้าอสม.)"),
                                        ],)
                                      ),
                                    ),
                                    Divider(
                                    thickness: 2,
                                    color: Colors.grey.shade300,
                                  )
                                  ],
                                ),
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
        ),                               
          ],
        )
        // Expanded(
        //   child: Container(
        //     child: Column(
        //       children: <Widget>[
        //         Center(
        //           child: Padding(
        //             padding: const EdgeInsets.only(
        //               top: 10,
        //             ),
        //             child: Text(
        //               'อสม.',
        //               textAlign: TextAlign.center,
        //               style: TextStyle(fontSize: 40),
        //             ),
        //           ),
        //         ),
        //         SizedBox(height: 30,),
        //         Padding(
        //           padding: EdgeInsets.symmetric(horizontal: 60),
        //           // padding: const EdgeInsets.all(8.0),
        //           child: TextFormField(
        //             controller: _searchController,
        //             onChanged: (value) {
        //               setState(() {
        //                 searchText = value;
        //               });
        //             },
        //             decoration: InputDecoration(
        //               labelText: 'ค้นหา',
        //               enabledBorder: OutlineInputBorder(
        //                 // borderSide: const BorderSide(width: 3, color: Colors.blue),
        //                 borderRadius: BorderRadius.circular(10),
        //               ),
        //               focusedBorder: OutlineInputBorder(
        //                 // borderSide: const BorderSide(width: 3, color: Colors.red),
        //                 borderRadius: BorderRadius.circular(10),
        //               ),
        //             ),
        //           ),
        //         ),
        //         SizedBox(height: 30,),
        //         Expanded(
        //           child: StreamBuilder<QuerySnapshot>(
        //             stream: _allVolunteers
        //                 .where("Role", isEqualTo: "Volunteer")
        //                 .snapshots(),
        //             builder: (BuildContext context,
        //                 AsyncSnapshot<QuerySnapshot> snapshot) {
        //               if (snapshot.hasData) {
        //                 documents = snapshot.data.docs;
        //                 if (searchText.length > 0) {
        //                   documents = documents.where((element) {
        //                     return element
        //                         .get('Firstname')
        //                         .toString()
        //                         .toLowerCase()
        //                         .contains(searchText.toLowerCase());
        //                   }).toList();
        //                 }
        //                 return ListView.builder(
        //                   itemCount: documents.length,
        //                   itemBuilder: (context, index) {
        //                     // var path;
        //                     // if (documents[index]["Img"] == null) {
        //                     //   path =
        //                     //       "gs://applicationforncds.appspot.com/MobileUserImg/Patient/not-available.png";
        //                     // } else {
        //                     //   path = documents[index]["Img"];
        //                     // }
        //                     return Padding(
        //                       padding: EdgeInsets.symmetric(horizontal: 60),
        //                       // padding: const EdgeInsets.all(8.0),
        //                       child: Container(
        //                         child: Column(
        //                           children: [
        //                             ListTile(
        //                               shape: RoundedRectangleBorder(
        //                                 // side:
        //                                 //     BorderSide(
        //                                 //       color: Colors.pink[100], width: 3),
        //                                       borderRadius: BorderRadius.circular(20),
        //                               ),
        //                               // leading: proFileShow(context, path),
        //                               title: Row(children: [
        //                                 Text(
        //                                     "${documents[index]["Firstname"]}  ${documents[index]["Lastname"]}"),
        //                                 if (documents[index]["isBoss"] == true)
        //                                   Text("(หัวหน้าอสม.)"),
        //                               ]),
        //                               hoverColor: Colors.grey.shade200,
        //                               // subtitle: Text("${snap["Lastname"]}"),
        //                               onTap: () {
        //                                 Navigator.push(
        //                                   context,
        //                                   MaterialPageRoute(
        //                                     builder: (context) => VolunteerMain(
        //                                         volunteerData: documents[index],
        //                                         volunteerDataId:
        //                                             documents[index].reference),
        //                                   ),
        //                                 );
        //                               },
        //                             ),
        //                             Divider(
        //                             thickness: 2,
        //                             color: Colors.grey.shade300,
        //                           )
        //                           ],
        //                         ),
        //                       ),
        //                     );
        //                   },
        //                 );
        //               } else {
        //                 return Center(
        //                   child: Text("กำลังโหลดข้อมูล"),
        //                 );
        //               }
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),      
    );
  }
}
