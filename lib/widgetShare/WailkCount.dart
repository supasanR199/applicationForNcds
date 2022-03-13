import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WalkCount extends StatefulWidget {
  DocumentReference patientId;

  WalkCount({Key key, @required this.patientId}) : super(key: key);

  @override
  State<WalkCount> createState() => _WalkCountState();
}

class _WalkCountState extends State<WalkCount> {
  final List<ChartData> chartData = [
    ChartData('David', 25, Color.fromRGBO(9, 0, 136, 1)),
    ChartData('Steve', 38, Color.fromRGBO(147, 0, 119, 1)),
    ChartData('Jack', 34, Color.fromRGBO(228, 0, 124, 1)),
    ChartData('Others', 52, Color.fromRGBO(255, 189, 57, 1))
  ];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection("MobileUser")
          .doc(widget.patientId.id)
          .collection("diary")
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Card(
            child: SizedBox(
              height: 700,
              width: 1000,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Center(
                  //   child: Text("ยังไม่มีการบันทึกประจำวัน"),
                  // ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'จำนวนก้าวเดิน',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  SfCircularChart(series: <CircularSeries>[
                    // Renders doughnut chart
                    DoughnutSeries<ChartData, String>(
                        dataSource: chartData,
                        pointColorMapper: (ChartData data, _) => data.color,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y)
                  ])
                ],
              ),
            ),
          );
        } else {
          return Text("กำลังโหลด");
        }
      },
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color color;
}
