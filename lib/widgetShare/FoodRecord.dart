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
  List<String> fatChoiceList = [
    "fatchoice1",
    "fatchoice2",
    "fatchoice3",
    "fatchoice4",
    "fatchoice5"
  ];
  List<String> seltChoiceList = [
    "saltchoice1",
    "saltchoice2",
    "saltchoice3",
    "saltchoice4",
    "saltchoice5",
  ];
  List<String> moodChoiceList = ["mood1", "mood2", "mood3", "mood4", "mood5"];

  var _value;
  List<String> selectDate = List();
  Future<QuerySnapshot> futureData;
  List<DairyModel> listitem = List();
  List<DairyModel> listforDate = List();
  List<DairyModel> listforDf = List();

  TextEditingController crateAtDate = TextEditingController();
  void initState() {
    // ignore: missing_return
    // futureData = getFutureData(widget.patienId.id).then((value) {
    //   value.docs.forEach((e) {
    //     DairyModel model = DairyModel.fromMap(e.data());
    //     setState(() {
    //       listitem.add(model);
    //     });
    //     // print(listitem);
    //   });
    // });
    // print(listitem);
    showdata();
    super.initState();
  }

  Future<void> showdata() async {
    // await FirebaseAuth.instance.authStateChanges().listen((event) async {
    //   var uid = event!.uid;
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
          listforDf.add(model);
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
    return Container(
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("MobileUser")
            .doc(widget.patienId.id)
            .collection("diary")
            .get(),
        builder:
            ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                              'บันทึกการรับประทานอาหาร',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 40),
                            ),
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
                                            // print(listforDf);
                                            // listitem.clear();
                                            listitem = listforDf;
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
                                              getMinDateFromDiary(listforDate),
                                              getMaxDateFromDiary(listforDate),
                                              listforDate),
                                    ).then((value) {
                                      if (value != null) {
                                        setState(() {
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
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              'หวาน',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: SizedBox(
                            width: 500,
                            child: ShowChartBar(
                              scoreMax:
                                  getSumAllChoice(listitem, sweetChoiceList)[1],
                              dataSource:
                                  getSumAllChoice(listitem, sweetChoiceList)[0],
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                sweetChoiceList[0] +
                                    ":" +
                                    "น้ำเปล่า เครื่องดืมไม่ผสมน้ำตาล",
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                  sweetChoiceList[1] +
                                      ":" +
                                      "น้ำอัดลม เครื่องดืมชง น้ำหวาน นมเปรี้ยว",
                                  textAlign: TextAlign.start),
                              Text(
                                  sweetChoiceList[2] +
                                      ":" +
                                      "น้ำผักผลไม้สำเร็จรูป",
                                  textAlign: TextAlign.start),
                              Text(
                                  sweetChoiceList[3] +
                                      ":" +
                                      "ไอศครีม เบอร์เกอรี่ หรือขนมไทย",
                                  textAlign: TextAlign.start),
                              Text(
                                  sweetChoiceList[4] +
                                      ":" +
                                      "เติมน้ำตาบ น้ำผึ้ง น้ำเชื่อมเพิ่มในอาหาร",
                                  textAlign: TextAlign.start),
                            ],
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              'มัน',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: SizedBox(
                            width: 400,
                            child: ShowChartBar(
                              scoreMax:
                                  getSumAllChoice(listitem, fatChoiceList)[1],
                              dataSource:
                                  getSumAllChoice(listitem, fatChoiceList)[0],
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                fatChoiceList[0] + ":" + "เนื้อติดมันติดหนัง",
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                  fatChoiceList[1] +
                                      ":" +
                                      "อาหารทอด ฟาสฟู๊ด ผัดน้ำมัน ",
                                  textAlign: TextAlign.start),
                              Text(
                                  fatChoiceList[2] +
                                      ":" +
                                      "อาหารจานเดียวไขมันสูง หรือแกงกระทิ",
                                  textAlign: TextAlign.start),
                              Text(
                                  fatChoiceList[3] +
                                      ":" +
                                      "เครื่องดื่มผสม นมข้นหวาน ครีมเทียม วิปปิ้งครีม",
                                  textAlign: TextAlign.start),
                              Text(
                                  fatChoiceList[4] +
                                      ":" +
                                      "ซดน้ำผัด น้ำแกง หรือดราดลงในข้าว",
                                  textAlign: TextAlign.start),
                            ],
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              'เค็ม',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: SizedBox(
                            width: 400,
                            child: ShowChartBar(
                              scoreMax:
                                  getSumAllChoice(listitem, seltChoiceList)[1],
                              dataSource:
                                  getSumAllChoice(listitem, seltChoiceList)[0],
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                seltChoiceList[0] +
                                    ":" +
                                    "ชิมอาหารก่อนปรุง ปรุงน้อยหรือไม่ปรุ่งเพิ่ม",
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                  seltChoiceList[1] +
                                      ":" +
                                      "ใช้สมุนไพรเครื่องเทศแทนเครื่องปรุง",
                                  textAlign: TextAlign.start),
                              Text(seltChoiceList[2] + ":" + "เนื้อสัตว์แปรรูป",
                                  textAlign: TextAlign.start),
                              Text(seltChoiceList[3] + ":" + "อาหารสำเร็จ",
                                  textAlign: TextAlign.start),
                              Text(
                                  seltChoiceList[4] +
                                      ":" +
                                      "ผักผลไม้ของดอง หรือผลไม้จิ้มพริกเกลือ น้ำปลาหวาน",
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
            return Text("Don't have data");
          }
        }),
      ),
    );
  }

  Widget buildButtonClear(context) {
    return RaisedButton(
      // color: Colors.accents,
      child: Text('ยกเลิก'),
      onPressed: () {},
      padding: EdgeInsets.all(20),
      color: Colors.redAccent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
    );
  }
}
