import 'dart:developer';

import 'package:appilcation_for_ncds/function/GetDataChart.dart';
import 'package:appilcation_for_ncds/function/getRecordPatient.dart';
import 'package:appilcation_for_ncds/models/KeepRecord.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../mobilecode/function/datethai.dart';

class WalkCount extends StatefulWidget {
  DocumentReference patientId;
  WalkCount({Key key, @required this.patientId}) : super(key: key);

  @override
  State<WalkCount> createState() => _WalkCountState();
}

class _WalkCountState extends State<WalkCount> {
  List<KeepChoieAndSocre> chartData = List();
  List<KeepChoieAndSocre> getAll = List();
  List<String> selectDay = List();
  String showStepCount;
  DateTime selectedDate = DateTime.now();
  TextEditingController crateAtDate = TextEditingController();
  TextEditingController crateAtSingleDate = TextEditingController();
  DateFormat myDateFormat = DateFormat("yyyy-MM-dd");
  var chartLiner;

  var _value;
  void initState() {
    FirebaseFirestore.instance
        .collection("MobileUser")
        .doc(widget.patientId.id)
        .collection("sensordiary")
        .orderBy("Date", descending: false)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        KeepChoieAndSocre getEle = KeepChoieAndSocre(
            element.get("Date"), element.get("Step"), Colors.blue);
        setState(() {
          getAll.add(getEle);
        });
      });
      setState(() {
        getAll.forEach((element) {
          selectDay.add(element.choice);
        });
        chartData.add(getAll.last);
        showStepCount = getAll.last.score.toString();
        _value = getAll.last.choice.toString();
        crateAtDate.text = DateThai(getAll.first.choice)+
            " - "+
            DateThai(myDateFormat.format(DateTime.now()));
      });
    });

    chartLiner = getAll;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection("MobileUser")
          .doc(widget.patientId.id)
          .collection("sensordiary")
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (getAll.isEmpty) {
            return Center(child: Text("ยังไม่มีข้อมูล"));
          } else {
            return Scaffold(
              body: SingleChildScrollView(
                child: Center(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                          child: SizedBox(
                            height: 500,
                            width: 1000,
                            child: Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      'จำนวนก้าวเดิน',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "ก้าวเดินที่บันทึกล่าสุดเมื่อวันที่ :  ${DateThai(snapshot.data.docs.last.get("Date"))}",
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                // Padding(
                                //   padding:
                                //       EdgeInsets.symmetric(horizontal: 100),
                                //   child: 
                                //   DropdownButtonFormField<String>(
                                //     value: _value,
                                //     decoration: InputDecoration(
                                //       labelText: 'วันที่บันทึก',
                                //       icon: Icon(Icons.calendar_today),
                                //     ),
                                //     items: selectDay.map((String values) {
                                //       // print(values);
                                //       return DropdownMenuItem<String>(
                                //         value: values,
                                //         child: Text(values),
                                //       );
                                //     }).toList(),
                                //     onChanged: (newValue) {
                                //       // print(newValue);
                                //       setState(() {
                                //         // debugger();
                                //         _value = newValue;
                                //         chartData.clear();
                                //         chartData =
                                //             getStepFromDate(getAll, _value);
                                //         showStepCount =
                                //             chartData.first.score.toString();
                                //       });
                                //     },
                                //   ),
                                // ),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 100),
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: crateAtSingleDate,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'กรุณาระบุวันที่บันทึก';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'วัน',
                                          icon: Icon(Icons.calendar_today),
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.cancel),
                                            onPressed: () {
                                              setState(() {
                                                // listitem = listforDf;
                                                crateAtSingleDate.text = "";
                                              });
                                            },
                                          )),
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              showDateSingleWalkCount(
                                                  context,
                                                  getMinDateStep(selectDay),
                                                  DateTime.now(),
                                                  getAll),
                                        ).then((value) {
                                          if (value != null) {
                                            setState(() {
                                              //     listitem = value;
                                              // crateAtDate.text = listitem.first.date +
                                              //     " - " +
                                              //     listforDate.last.date;
                                              showStepCount = value.first.score.toString();
                                              crateAtSingleDate.text = DateThai(value.first.choice);
                                              chartData = value;
                                              print(
                                                  "show chart single ${chartLiner.toList()}");
                                            });
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                // Padding(
                                //   padding: EdgeInsets.only(
                                //     left: 50,
                                //     right: 50,
                                //     top: 70,
                                //   ),
                                // child: TextFormField(
                                //     readOnly: true,
                                //     controller: crateAtDate,
                                //     validator: (value) {
                                //       if (value.isEmpty) {
                                //         return 'กรุณาระบุวันที่บันทึก';
                                //       } else {
                                //         return null;
                                //       }
                                //     },
                                // decoration: InputDecoration(
                                //     labelText: 'วันที่บันทึก',
                                //     icon: Icon(Icons.people),
                                //     suffixIcon: IconButton(
                                //       icon: Icon(Icons.cancel),
                                //       onPressed: () {
                                //         setState(() {
                                //           // listitem.clear();
                                //           // print(listforDf);
                                //           // listitem.clear();
                                //           chartData = getStepFromDate(getAll,
                                //               myDateFormat.format(DateTime.now()));
                                //           showStepCount =
                                //               chartData.first.score.toString();
                                //           crateAtDate.text =
                                //               myDateFormat.format(DateTime.now());
                                //         });
                                //       },
                                //     )),
                                // onTap: () async {
                                //   final DateTime selected = await showDatePicker(
                                //     context: context,
                                //     initialDate: DateTime.now(),
                                //     firstDate: getMinDateStep(selectDay),
                                //     lastDate: DateTime.now(),
                                //   );
                                //   if (selected != null && selected != selectedDate) {
                                //     setState(() {
                                //       selectedDate = selected;
                                //       crateAtDate.text =
                                //           myDateFormat.format(selected);
                                //       chartData.clear();
                                //       chartData = getStepFromDate(
                                //           getAll, myDateFormat.format(selectedDate));
                                //       showStepCount =
                                //           chartData.first.score.toString();
                                //     });
                                //   }
                                // }),
                                // ),
                                SfCircularChart(annotations: <
                                    CircularChartAnnotation>[
                                  CircularChartAnnotation(
                                    widget: Container(
                                      child: Text(
                                        '$showStepCount  ก้าว',
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 0.5),
                                            fontSize: 25),
                                      ),
                                    ),
                                  ),
                                ], series: <CircularSeries>[
                                  RadialBarSeries<KeepChoieAndSocre, String>(
                                      dataSource: chartData,
                                      xValueMapper:
                                          (KeepChoieAndSocre data, _) =>
                                              data.choice,
                                      yValueMapper:
                                          (KeepChoieAndSocre data, _) =>
                                              data.score,
                                      // dataLabelSettings: DataLabelSettings(isVisible: true),
                                      cornerStyle: CornerStyle.bothCurve,
                                      maximumValue: 5000,
                                      innerRadius: '80%',
                                      strokeWidth: 5.0),
                                ])
                              ],
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                        Card(
                          child: SizedBox(
                            height: 500,
                            width: 1000,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        'จำนวนก้าวทั้งหมด',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  // Center(
                                  //   child: Text(
                                  //     "ก้าวเดินที่บันทึกล่าสุดเมื่อวันที่ :  ${snapshot.data.docs.last.get("Date")}",
                                  //     style: TextStyle(fontSize: 25, color: Colors.black),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 100),
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
                                          labelText: 'ช่วงเวลา',
                                          icon: Icon(Icons.calendar_today),
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.cancel),
                                            onPressed: () {
                                              setState(() {
                                                // listitem = listforDf;
                                                crateAtDate.text = "";
                                              });
                                            },
                                          )),
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              showDateRangWalkCount(
                                                  context,
                                                  getMinDateStep(selectDay),
                                                  DateTime.now(),
                                                  getAll),
                                        ).then((value) {
                                          if (value != null) {
                                            setState(() {
                                              //     listitem = value;
                                              // crateAtDate.text = listitem.first.date +
                                              //     " - " +
                                              //     listforDate.last.date;
                                              crateAtDate.text = DateThai(value.first.choice)+" - "+DateThai(value.last.choice);
                                              chartLiner = value;
                                              print(
                                                  "show chart liner ${chartLiner.toList()}");
                                            });
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 40),
                                    // padding: EdgeInsets.only(top: 10),
                                    child: SizedBox(
                                      // width: 500,
                                      // height: 200,
                                      child: SfCartesianChart(
                                        // title: ChartTitle(text: 'จำนวนก้าวทั้งหมด'),
                                        primaryXAxis: CategoryAxis(),
                                        series: <ChartSeries>[
                                          // Renders line chart
                                          LineSeries<KeepChoieAndSocre, String>(
                                              color: Colors.blueAccent,
                                              dataSource: chartLiner,
                                              xValueMapper:
                                                  (KeepChoieAndSocre data, _) =>
                                                      DateThai(data.choice),
                                              yValueMapper:
                                                  (KeepChoieAndSocre data, _) =>
                                                      data.score)
                                        ],
                                        // primaryXAxis: CategoryAxis(
                                        //   // labelRotation: -80
                                        // ),
                                        primaryYAxis: NumericAxis(
                                            edgeLabelPlacement:
                                                EdgeLabelPlacement.shift,
                                            decimalPlaces: 0,
                                            // numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
                                            title:
                                                AxisTitle(text: 'จำนวนก้าว')),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        } else {
          return Text("กำลังโหลด");
        }
      },
    );
  }
}
