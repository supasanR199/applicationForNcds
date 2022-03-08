import 'package:appilcation_for_ncds/function/DisplayTime.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Widget contentPage(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("RecommendPost").snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData) {
        return ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> snap = document.data() as Map<String, dynamic>;
            return GestureDetector(
              onTap: () => null,
              child: Card(
                color: Colors.amber,
                child: SizedBox(
                  height: 400,
                  width: 90,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Text(
                                      "หัวเรื่อง  :",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Text("${snap["topic"]}"),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: delectPost(context, document.id,
                                          snap["imgPath"]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Text(
                                      "เนื้อเรื่อง :",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "${snap["content"]}",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Text(
                                      "ผู้สร้างโพสต์แนะนำ :",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${snap["createBy"]}",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Text(
                                      "เหมะสำหรับผู้ป่วย :",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "อายุ:  ${snap["recommentForAge"]}",
                                        ),
                                        Text(
                                          "ค่าBMI:  ${snap["recommentForBMI"]}",
                                        ),
                                        Text(
                                          "โรค:  ${snap["recommentForDieases"]}",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Text(
                                      "สร้างโพสต์เมื่อวันที่ :",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Text(
                                    convertDateTimeDisplay(snap["createAt"]
                                            .toDate()
                                            .toString()) +
                                        "" +
                                        "สร้างมาแล้ว :" +
                                        "" +
                                        calCreateDay(convertDateTimeDisplay(
                                            snap["createAt"]
                                                .toDate()
                                                .toString())) +
                                        "วัน",
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Text(
                                      "สร้างโพสต์เมื่อเวลา :",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Text(
                                    convertTimeDisplay(snap["createAt"]),
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
            );
          }).toList(),
        );
      } else {
        return Text("ไม่มีโพสต์แนะนำ");
      }
    },
  );
}

Widget delectPost(BuildContext context, String id, String imgPath) {
  return IconButton(
      icon: const Icon(Icons.delete),
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
            Navigator.pop(context);
          }
        });
      });
}
