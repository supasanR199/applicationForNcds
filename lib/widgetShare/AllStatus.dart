import 'package:appilcation_for_ncds/function/DisplayTime.dart';
import 'package:appilcation_for_ncds/function/GetDataChart.dart';
import 'package:appilcation_for_ncds/models/AlertModels.dart';
import 'package:appilcation_for_ncds/models/MutiChartData.dart';
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
  List<int> sweetalert = List();
  List<int> fatalert = List();
  List<int> saltalert = List();
  List<int> nomal = List();
  List<int> mediam = List();
  List<int> alert = List();
  List<int> dangerus = List();
  List<AlertModels> listData = List();
  List<MutiChartData> keepChartData = List();
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
            // print("this is shit${listData.length}");
            // listforDate.add(model);
          });
        }
      });
    });
  }

  Widget build(BuildContext context) {
    // List<MutiChartData> chartData = <MutiChartData>[
    //   MutiChartData('หวาน', 128, 129, 101, 10),
    //   MutiChartData('มัน', 123, 92, 93, 10),
    //   MutiChartData('เค็ม', 107, 106, 90, 10),
    //   // ChartData('USA', 87, 95, 71, 10),
    // ];
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("MobileUser")
            .where("Role", isEqualTo: "Patient")
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            keepChartData = getAllAlertDataInSys(listData);

            return Card(
              child: SizedBox(
                width: 700,
                height: 1000,
                child: Column(
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        showMonthPicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year - 1, 5),
                          lastDate: DateTime(DateTime.now().year + 1, 9),
                          initialDate: selectedDate ?? DateTime.now(),
                          locale: Locale("en"),
                        ).then((date) {
                          if (date != null) {
                            setState(() {
                              selectedDate = date;
                              var b = convertMouth(selectedDate) + "-01";
                              // convertMouth(selectedDate);
                              print(b);
                              var a = DateTime.parse(b);
                              print(a);
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
                  ],
                ),
              ),
            );
          } else {
            return Text("data");
          }
        });
  }
}

class SumModels {
  SumModels(this.x, this.y, this.y1, this.y2);
  final String x;
  final double y;
  final double y1;
  final double y2;
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
