import 'package:appilcation_for_ncds/function/GetDataChart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AllStarus extends StatefulWidget {
  AllStarus({Key key}) : super(key: key);

  @override
  State<AllStarus> createState() => _AllSrarusState();
}

class _AllSrarusState extends State<AllStarus> {
  @override
  List getAllData = List();
  List<int> sweetalert = List();
  List<int> fatalert = List();
  List<int> saltalert = List();
  List<int> nomal = List();
  List<int> mediam = List();
  List<int> alert = List();
  List<int> dangerus = List();

  void initState() {
    // print(_userLogId);
    super.initState();
    getAllChartData();
  }

  void getAllChartData() async {
    List listid = List();
    List listData = List();
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
        // print("length is ${value.docs.length}");
        value.docs.forEach((element) {
          if (element.id == "2022-3") {
            print(element.id);
            print("fatalert:${element.get("fatalert")}");
            print("saltalert:${element.get("saltalert")}");
            print("sweetalert:${element.get("sweetalert")}");
          } else {
            // print(2);
          }
        });
      });
    });
    print("this is ${listid.toList()}");
    // print("this is shit${listData.length}");
  }

  Widget build(BuildContext context) {
    List<ChartData> chartData = <ChartData>[
      ChartData('หวาน', 128, 129, 101, 10),
      ChartData('มัน', 123, 92, 93, 10),
      ChartData('เค็ม', 107, 106, 90, 10),
      // ChartData('USA', 87, 95, 71, 10),
    ];
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("MobileUser")
            .where("Role", isEqualTo: "Patient")
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            // getAllDataInSys(snapshot.data.docs);
            return Card(
              child: SizedBox(
                width: 700,
                height: 1000,
                child: Column(
                  children: [
                    SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <CartesianSeries>[
                          ColumnSeries<ChartData, String>(
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y),
                          ColumnSeries<ChartData, String>(
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y1),
                          ColumnSeries<ChartData, String>(
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y2),
                          ColumnSeries<ChartData, String>(
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y3)
                        ])
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

class ChartData {
  ChartData(this.x, this.y, this.y1, this.y2, this.y3);
  final String x;
  final double y;
  final double y1;
  final double y2;
  final double y3;
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
