import 'package:appilcation_for_ncds/function/DisplayTime.dart';
import 'package:appilcation_for_ncds/function/GetDataChart.dart';
import 'package:appilcation_for_ncds/models/AlertModels.dart';
import 'package:appilcation_for_ncds/models/AlertMoodModels.dart';
import 'package:appilcation_for_ncds/models/KeepRecord.dart';
import 'package:appilcation_for_ncds/models/MutiChartData.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class AllStarus extends StatefulWidget {
  AllStarus({Key key}) : super(key: key);

  @override
  State<AllStarus> createState() => _AllSrarusState();
}

class _AllSrarusState extends State<AllStarus> {
  @override
  // List getAllData = List();

  List<AlertModels> listData = List();
  List<AlertModels> listDataForDate = List();
  List<AlertMoodModels> listDataMood = List();
  List<AlertMoodModels> listDataForDateMood = List();

  List<MutiChartData> keepChartData = List();
  List<KeepChoieAndSocre> keepChartDataMood = List();
  List<DateTime> initListDate = [DateTime.now()];
  DateTime selectedDate;

  void initState() {
    // print(_userLogId);
    getAllChartData();

    super.initState();
  }

  void getAllChartData() async {
    List listid = List();
    await FirebaseFirestore.instance
        .collection("MobileUser")
        .where("Role", isEqualTo: "Patient")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          listid.add(element.id);
        });
      });
    });
    listid.forEach((e) async {
      await FirebaseFirestore.instance
          .collection("MobileUser")
          .doc(e)
          .collection("eatalert")
          .get()
          .then((value) {
        for (var i in value.docs) {
          AlertModels model = AlertModels.fromMap(i.data());
          setState(() {
            listData.add(model);
            listDataForDate.add(model);
            // print("this is shit${listData.length}");
            // listforDate.add(model);
            keepChartData = getAllAlertDataInSys(listData, DateTime.now());
          });
        }
      });
    });
    listid.forEach((e) async {
      await FirebaseFirestore.instance
          .collection("MobileUser")
          .doc(e)
          .collection("moodalert")
          .get()
          .then((value) {
        for (var i in value.docs) {
          AlertMoodModels model = AlertMoodModels.fromMap(i.data());
          setState(() {
            listDataMood.add(model);
            listDataForDateMood.add(model);
            // print("this is shit${listData.length}");
            // listforDate.add(model);
            keepChartDataMood =
                getAllAlertDataInSysMood(listDataMood, initListDate);
          });
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("MobileUser")
            .where("Role", isEqualTo: "Patient")
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Card(
              child: SizedBox(
                width: 700,
                height: 1000,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Text(
                            'ผลสรุปจากการทำแบบประเมินอาหาร',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      // Center(
                      //   child: Text(
                      //     "ล่าสุดเมื่อเดือนที่ :  ${listDataForDate.last.date}",
                      //     style: TextStyle(fontSize: 14, color: Colors.black38),
                      //   ),
                      // ),
                      FloatingActionButton(
                        onPressed: () {
                          showMonthPicker(
                            context: context,
                            firstDate: getMinDate(listDataForDate),
                            lastDate: getMaxDate(listDataForDate),
                            initialDate: selectedDate ?? DateTime.now(),
                            locale: Locale("en"),
                          ).then((date) {
                            if (date != null) {
                              setState(() {
                                selectedDate = date;
                                keepChartData = getAllAlertDataInSys(
                                    listData, selectedDate);

                                // var b = convertMouth(selectedDate) + "-01";
                                // // convertMouth(selectedDate);
                                // print(b);
                                // var a = DateTime.parse(b);
                                // print(a);
                              });
                            }
                          });
                        },
                        child: Icon(Icons.calendar_today),
                      ),
                      SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <CartesianSeries>[
                          ColumnSeries<MutiChartData, String>(
                              dataSource: keepChartData,
                              xValueMapper: (MutiChartData data, _) => data.x,
                              yValueMapper: (MutiChartData data, _) => data.y),
                          ColumnSeries<MutiChartData, String>(
                              dataSource: keepChartData,
                              xValueMapper: (MutiChartData data, _) => data.x,
                              yValueMapper: (MutiChartData data, _) => data.y1),
                          ColumnSeries<MutiChartData, String>(
                              dataSource: keepChartData,
                              xValueMapper: (MutiChartData data, _) => data.x,
                              yValueMapper: (MutiChartData data, _) => data.y2),
                          ColumnSeries<MutiChartData, String>(
                              dataSource: keepChartData,
                              xValueMapper: (MutiChartData data, _) => data.x,
                              yValueMapper: (MutiChartData data, _) => data.y3)
                        ],
                      ),
                       Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Text(
                            'ผลสรุปจากการทำแบบประเมินอารมณ์',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => showDateRangMood(
                                context,
                                getMinDateMood(listDataForDateMood),
                                getMaxDateMood(listDataForDateMood),
                                listDataForDateMood),
                          ).then((value) {
                            print(value);
                            if (value != null) {
                              setState(() {
                                keepChartDataMood = getAllAlertDataInSysMood(
                                    listDataMood, value);
                              });
                            }
                          });
                        },
                        child: Icon(Icons.calendar_today),
                      ),
                      SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(),
                        // tooltipBehavior: _tooltip,
                        series: <ChartSeries<dynamic, String>>[
                          ColumnSeries<dynamic, String>(
                              dataSource: keepChartDataMood,
                              xValueMapper: (dynamic data, _) => data.choice,
                              yValueMapper: (dynamic data, _) => data.score,
                              name: 'คะแนนการประเมิน',
                              color: Color.fromRGBO(8, 142, 255, 1))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Text("data");
          }
        });
  }
}

statuseat(num val) {
  if (val != 0) {
    if (val == 5) {
      return ["ปรกติ", Colors.green];
    } else if (val >= 6 && val <= 9) {
      return ["มีความเสี่ยงปานกลาง", Colors.yellow.shade600];
    } else if (val >= 10 && val <= 13) {
      return ["มีความเสี่ยงสูง", Colors.orange];
    } else if (val >= 14) {
      return ["มีความเสี่ยงสูงมาก", Colors.red];
    }
  } else {
    return ["ไม่มีข้อมูล", Colors.grey];
  }
}

setData(num val) {
  if (val != 0) {
    if (val == 5) {
      return ["ปรกติ", Colors.green];
    } else if (val >= 6 && val <= 9) {
      return ["มีความเสี่ยงปานกลาง", Colors.yellow.shade600];
    } else if (val >= 10 && val <= 13) {
      return ["มีความเสี่ยงสูง", Colors.orange];
    } else if (val >= 14) {
      return ["มีความเสี่ยงสูงมาก", Colors.red];
    }
  } else {
    return ["ไม่มีข้อมูล", Colors.grey];
  }
}

setToList(num val) {
  List<int> nomal = List();
  List<int> mediam = List();
  List<int> alert = List();
  List<int> dangerus = List();
  if (val != 0) {
    if (val == 5) {
      nomal.add(1);
    } else if (val >= 6 && val <= 9) {
      mediam.add(1);
    } else if (val >= 10 && val <= 13) {
      alert.add(1);
    } else if (val >= 14) {
      dangerus.add(1);
    }
  } else {
    return ["ไม่มีข้อมูล", Colors.grey];
  }
}
