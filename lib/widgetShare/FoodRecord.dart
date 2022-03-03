import 'dart:developer';

import 'package:appilcation_for_ncds/function/GetDataChart.dart';
import 'package:appilcation_for_ncds/models/DiaryModels.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowChart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FoodRecord extends StatefulWidget {
  DocumentReference patienId;
  FoodRecord({Key key, @required this.patienId}) : super(key: key);

  @override
  State<FoodRecord> createState() => _FoodRecordState();
}

class _FoodRecordState extends State<FoodRecord> {
  List<String> sweetChoiceList = [
    "sweetchoice1",
    "sweetchoice2",
    "sweetchoice3",
    "sweetchoice4",
    "sweetchoice5"
  ];
  Iterable keepSweet;
  List keepDiary = List();
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("MobileUser")
            .doc(widget.patienId.id)
            .collection("diary")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            snapshot.data.docs.forEach((element) {
              keepDiary.add(element.data());
            });
            // print(keepDiary.toList());

            // sweetChoiceList.forEach((element) {
            //   // var sweetChoice = element;
            //   List<int> numList = List();
            // });
            print(keepDiary.length);
            // print(keepDiary.toList());
            // print(keepDiary)
            //  keepSweet = keepDiary.where((element) => element.toString().contains("sweetchoice"));

            // print(keepSweet.toList());
            // snapshot.data.docs.forEach((e) {
            //   print(e.data());
            // });
            return Card(
              child: SizedBox(
                height: 700,
                width: 1000,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 50,
                        right: 50,
                        top: 70,
                      ),
                      child: TextFormField(
                        // controller: crateAtDate,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'กรุณาระบุวันที่บันทึก';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'วันที่บันทึก',
                          icon: Icon(Icons.people),
                        ),
                        // onTap: () async {
                        //   showDialog(
                        //       context: context,
                        //       builder: (BuildContext context) =>
                        //           showDateRang(context, DateTime.now()));
                        // },
                      ),
                    ),
                    // ShowChart(),
                    // ShowChart(scoreMax: scoreMax)
                  ],
                ),
              ),
            );
          } else {
            return Text("");
          }
        });
  }
}
