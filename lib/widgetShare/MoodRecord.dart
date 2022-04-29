import 'dart:developer';

import 'package:appilcation_for_ncds/function/GetDataChart.dart';
import 'package:appilcation_for_ncds/function/getRecordPatient.dart';
import 'package:appilcation_for_ncds/models/KeepRecord.dart';
import 'package:appilcation_for_ncds/models/dairymodel.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowChart.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowChartBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:math';

class MoodRecord extends StatefulWidget {
  DocumentReference patienId;

  MoodRecord({Key key, @required this.patienId}) : super(key: key);

  @override
  State<MoodRecord> createState() => _MoodRecordState();
}

class _MoodRecordState extends State<MoodRecord> {
  List<DairyModel> listitem = List();
  List<DairyModel> listforDate = List();
  List<String> selectDate = List();
  TextEditingController crateAtDate = TextEditingController();
  var _value;

  void initState() {
    showdata();
    super.initState();
  }

  Future<void> showdata() async {
    await FirebaseFirestore.instance
        .collection('MobileUser')
        .doc(widget.patienId.id)
        .collection("diary")
        .get()
        .then((value) {
      for (var i in value.docs) {
        DairyModel model = DairyModel.fromMap(i.data());
        setState(() {
          listitem.add(model);
          listforDate.add(model);
        });
      }
      selectDate.clear();
      listforDate.forEach((e) {
        setState(() {
          // print(e.date);
          selectDate.add(e.date);
        });
      });
      setState(() {
        selectDate = selectDate.sorted((a, b) {
          return DateTime.parse(b).compareTo(DateTime.parse(a));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> moodChoiceList = ["mood1", "mood2", "mood3", "mood4", "mood5"];
    return Container(
      child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("MobileUser")
              .doc(widget.patienId.id)
              .collection("diary")
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (listitem.length <= 0) {
                return Card(
                  child: SizedBox(
                    height: 700,
                    width: 1000,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text("ยังไม่มีการบันทึกประจำวัน"),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Card(
                  child: SizedBox(
                    height: 700,
                    width: 1000,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'บันทึกการประเมินอารมณ์',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 40),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 50,
                              right: 50,
                              top: 70,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 50,
                                    right: 50,
                                    top: 70,
                                  ),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: crateAtDate,
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
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.cancel),
                                          onPressed: () {
                                            setState(() {
                                              // listitem.clear();
                                              listitem = listforDate;
                                              crateAtDate.text = "";
                                            });
                                          },
                                        )),
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            showDateRang(
                                                context,
                                                getMinDateFromDiary(
                                                    listforDate),
                                                getMaxDateFromDiary(
                                                    listforDate),
                                                listforDate),
                                      ).then((value) {
                                        if (value != null) {
                                          setState(() {
                                            // listitem.clear();
                                            listitem = value;
                                            crateAtDate.text =
                                                listitem.first.date +
                                                    " - " +
                                                    listforDate.last.date;
                                          });
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              // Expanded(
                              //   child: Padding(
                              //     padding: EdgeInsets.only(
                              //       left: 50,
                              //       right: 50,
                              //       top: 70,
                              //     ),
                              //     child: DropdownButtonFormField<String>(
                              //       value: _value,
                              //       decoration: InputDecoration(
                              //         labelText: 'วันที่บันทึก',
                              //         icon: Icon(Icons.people),
                              //       ),
                              //       items: selectDate.map((String values) {
                              //         // print(values);
                              //         return DropdownMenuItem<String>(
                              //           value: values,
                              //           child: Text(values),
                              //         );
                              //       }).toList(),
                              //       onChanged: (newValue) {
                              //         // print(newValue);
                              //         setState(() {
                              //           _value = newValue;
                              //           var dateFromString =
                              //               DateTime.parse(_value);
                              //           List<DateTime> selectDateTimrList =
                              //               List();
                              //           selectDateTimrList.add(dateFromString);
                              //           listitem = getValueFromDateRang(
                              //               listforDate, selectDateTimrList);
                              //         });
                              //       },
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: SizedBox(
                              width: 500,
                              child: ShowChartBar(
                                scoreMax: getSumAllChoiceFood(
                                    listitem, moodChoiceList)[1],
                                dataSource: getSumAllChoiceFood(
                                    listitem, moodChoiceList)[0],
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  moodChoiceList[0] +
                                      ":" +
                                      "น้ำเปล่า เครื่องดืมไม่ผสมน้ำตาล",
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                    moodChoiceList[1] +
                                        ":" +
                                        "น้ำอัดลม เครื่องดืมชง น้ำหวาน นมเปรี้ยว",
                                    textAlign: TextAlign.start),
                                Text(
                                    moodChoiceList[2] +
                                        ":" +
                                        "น้ำผักผลไม้สำเร็จรูป",
                                    textAlign: TextAlign.start),
                                Text(
                                    moodChoiceList[3] +
                                        ":" +
                                        "ไอศครีม เบอร์เกอรี่ หรือขนมไทย",
                                    textAlign: TextAlign.start),
                                Text(
                                    moodChoiceList[4] +
                                        ":" +
                                        "เติมน้ำตาบ น้ำผึ้ง น้ำเชื่อมเพิ่มในอาหาร",
                                    textAlign: TextAlign.start),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Text("กำลังโหลด");
            }
          }),
    );
  }
}
