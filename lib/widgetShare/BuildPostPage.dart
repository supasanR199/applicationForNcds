import 'package:appilcation_for_ncds/AddPost.dart';
import 'package:appilcation_for_ncds/widgetShare/EditPost.dart';
import 'package:appilcation_for_ncds/widgetShare/ProfilePhoto.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class BuildPostPage extends StatefulWidget {
  var userData;
  BuildPostPage({Key key, @required this.userData}) : super(key: key);

  @override
  State<BuildPostPage> createState() => _BuildPostPageState();
}

class _BuildPostPageState extends State<BuildPostPage> {
  @override
  void initState() {
    super.initState();
    setImgToNull();
  }

  setImgToNull() async {
    await FirebaseFirestore.instance
        .collection("RecommendPost")
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        if (element.data()["imgPath"] == null) {
          await FirebaseFirestore.instance
              .collection("RecommendPost")
              .doc(element.id)
              .update({"imgPath": ""});
        } else {
          print("isNotNull");
        }
      });
    });
  }

  List<DocumentSnapshot> documents = [];
  String searchText = '';
  TextEditingController _searchController = TextEditingController();
  var auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
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
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("RecommendPost")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      documents = snapshot.data.docs;
                      documents.forEach((e) {});
                      if (searchText.length > 0) {
                        documents = documents.where((element) {
                          return element
                              .get('topic')
                              .toString()
                              .toLowerCase()
                              .contains(searchText.toLowerCase());
                        }).toList();
                      }
                    }
                    return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => null,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 60),
                              child: Column(children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(),
                                  child: Card(
                                    color: Colors.white,
                                    child: SizedBox(
                                      height: 200,
                                      // width: 50,
                                      child: Row(children: [
                                        proFilePostShow(context,
                                            documents[index]["imgPath"]),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  // Padding(
                                                  //   padding:
                                                  //       EdgeInsets.only(left: 8.0, right: 8.0),
                                                  //   child: Text(
                                                  //     "หัวเรื่อง  :",
                                                  //     style: TextStyle(fontSize: 20),
                                                  //   ),
                                                  // ),
                                                  Text(
                                                      "${documents[index]["topic"]}",
                                                      style: TextStyle(
                                                          fontSize: 20)),

                                                  // Align(
                                                  //   alignment:
                                                  //       Alignment.centerRight,
                                                  //   child: Padding(
                                                  //     padding: EdgeInsets.only(
                                                  //         left: 8.0,
                                                  //         right: 8.0),
                                                  //     child: delectPost(
                                                  //         context,
                                                  //         documents[index].id,
                                                  //         documents[index]
                                                  //             ["imgPath"]),
                                                  //   ),
                                                  // ),
                                                  // Align(
                                                  //   alignment:
                                                  //       Alignment.topRight,
                                                  //   child: Padding(
                                                  //     padding: EdgeInsets.only(
                                                  //         left: 8.0,
                                                  //         right: 8.0),
                                                  //     child: Icon(IconData(
                                                  //         0xe89b,
                                                  //         fontFamily:
                                                  //             'MaterialIcons')),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              // Expanded(
                                              //   child: Row(
                                              //     children: [
                                              //       Padding(
                                              //         padding:
                                              //             EdgeInsets.only(left: 8.0, right: 8.0),
                                              //         child: Text(
                                              //           "เนื้อเรื่อง :",
                                              //           style: TextStyle(fontSize: 20),
                                              //         ),
                                              //       ),
                                              Text(
                                                "${documents[index]["content"]}",
                                                overflow: TextOverflow.fade,
                                                maxLines: 4,
                                              ),
                                              Expanded(
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8.0),
                                                      child: ButtonEdit(context,
                                                          documents[index].id),
                                                    ),
                                                    ButtonDelect(
                                                        context,
                                                        documents[index].id,
                                                        documents[index]
                                                            ["imgPath"]),
                                                  ])),
                                              //     ],
                                              //   ),
                                              // ),
                                              // Expanded(
                                              //   child: Row(
                                              //     children: [
                                              //       Padding(
                                              //         padding:
                                              //             EdgeInsets.only(left: 8.0, right: 8.0),
                                              //         child: Text(
                                              //           "ผู้สร้างโพสต์แนะนำ :",
                                              //           style: TextStyle(fontSize: 20),
                                              //         ),
                                              //       ),
                                              //       Expanded(
                                              //         child: Column(
                                              //           mainAxisAlignment:
                                              //               MainAxisAlignment.center,
                                              //           crossAxisAlignment:
                                              //               CrossAxisAlignment.start,
                                              //           children: [
                                              //             Text(
                                              //               "${snap["createBy"]}",
                                              //             ),
                                              //           ],
                                              //         ),
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                              // Expanded(
                                              //   child: Row(
                                              //     children: [
                                              //       Padding(
                                              //         padding:
                                              //             EdgeInsets.only(left: 8.0, right: 8.0),
                                              //         child: Text(
                                              //           "เหมะสำหรับผู้ป่วย :",
                                              //           style: TextStyle(fontSize: 20),
                                              //         ),
                                              //       ),
                                              //       Expanded(
                                              //         child: Column(
                                              //           mainAxisAlignment:
                                              //               MainAxisAlignment.center,
                                              //           crossAxisAlignment:
                                              //               CrossAxisAlignment.start,
                                              //           children: [
                                              //             Text(
                                              //               "อายุ:  ${snap["recommentForAge"]}",
                                              //             ),
                                              //             Text(
                                              //               "ค่าBMI:  ${snap["recommentForBMI"]}",
                                              //             ),
                                              //             Text(
                                              //               "โรค:  ${snap["recommentForDieases"]}",
                                              //             ),
                                              //           ],
                                              //         ),
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                              // Expanded(
                                              //   child: Row(
                                              //     children: [
                                              //       Padding(
                                              //         padding:
                                              //             EdgeInsets.only(left: 8.0, right: 8.0),
                                              //         child: Text(
                                              //           "สร้างโพสต์เมื่อวันที่ :",
                                              //           style: TextStyle(fontSize: 20),
                                              //         ),
                                              //       ),
                                              //       Text(
                                              //         convertDateTimeDisplay(snap["createAt"]
                                              //                 .toDate()
                                              //                 .toString()) +
                                              //             "" +
                                              //             "สร้างมาแล้ว :" +
                                              //             "" +
                                              //             calCreateDay(convertDateTimeDisplay(
                                              //                 snap["createAt"]
                                              //                     .toDate()
                                              //                     .toString())) +
                                              //             "วัน",
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                              // Expanded(
                                              //   child: Row(
                                              //     children: [
                                              //       Padding(
                                              //         padding:
                                              //             EdgeInsets.only(left: 8.0, right: 8.0),
                                              //         child: Text(
                                              //           "สร้างโพสต์เมื่อเวลา :",
                                              //           style: TextStyle(fontSize: 20),
                                              //         ),
                                              //       ),
                                              //       Text(
                                              //         convertTimeDisplay(snap["createAt"]),
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          );
                        });
                  },
                ),
              ),
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

  Widget delectPost(BuildContext context, String id, String imgPath) {
    return IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        tooltip: 'ลบโพตส์',
        onPressed: () async {
          showDialog(
                  context: context,
                  builder: (BuildContext content) =>
                      alertMessage(content, "คุณแน่ใจที่จะลบโพสต์หรือไม่"))
              .then((value) async {
            if (value == "CONFIRM") {
              await FirebaseFirestore.instance
                  .collection("RecommendPost")
                  .doc(id)
                  .delete();
              await FirebaseStorage.instance.ref(imgPath).delete();
            } else if (value == 'CANCEL') {
              // Navigator.pop(context);
            }
          });
        });
  }

  Widget ButtonEdit(context, String uid) {
    return Container(
      height: 45,
      width: 140,
      child: Center(
        child: RaisedButton(
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => EditPost(
                    postUid: uid,
                    whoEdit: auth.currentUser.uid,
                  )),
          child: Row(children: [
            Icon(IconData(0xe89b, fontFamily: 'MaterialIcons'),
                color: Colors.white),
            Text(
              "แก้ไขบทความ",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ]),
          color: Colors.blueAccent,
          hoverColor: Colors.grey,
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ),
    );
  }

  Widget ButtonDelect(context, String id, String imgPath) {
    return Container(
      height: 45,
      width: 140,
      child: Center(
        child: RaisedButton(
          onPressed: () async {
            showDialog(
                    context: context,
                    builder: (BuildContext content) =>
                        alertMessage(content, "คุณแน่ใจที่จะลบโพสต์หรือไม่"))
                .then((value) async {
              if (value == "CONFIRM") {
                await FirebaseFirestore.instance
                    .collection("RecommendPost")
                    .doc(id)
                    .delete();
                await FirebaseStorage.instance.ref(imgPath).delete();
              } else if (value == 'CANCEL') {
                // Navigator.pop(context);
              }
            });
          },
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Text(
                "ลบบทความ",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          color: Colors.red,
          hoverColor: Colors.grey,
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
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
                userData: widget.userData,
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
}
