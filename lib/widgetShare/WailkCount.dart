import 'package:appilcation_for_ncds/function/GetDataChart.dart';
import 'package:appilcation_for_ncds/models/KeepRecord.dart';
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
  final List<KeepChoieAndSocre> chartData = List();
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
          // print();
          // showStep.choice = snapshot.data.docs.last.get("Date");
          // showStep.score  = snapshot.data.docs.last.get("Step");
          KeepChoieAndSocre showStep = KeepChoieAndSocre(
            snapshot.data.docs.last.get("Date"),
            snapshot.data.docs.last.get("Step"),
          );
          chartData.add(showStep);
          return Card(
            child: SizedBox(
              height: 700,
              width: 1000,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                  Center(
                    child: Text(
                      "จำนวนก้าวเดินล่าสุดเมื่อวันที่ :  ${snapshot.data.docs.last.get("Date")}",
                      style: TextStyle(fontSize: 14, color: Colors.black38),
                    ),
                  ),
                  SfCircularChart(series: <CircularSeries>[
                    RadialBarSeries<KeepChoieAndSocre, String>(
                        dataSource: chartData,
                        xValueMapper: (KeepChoieAndSocre data, _) =>
                            data.choice,
                        yValueMapper: (KeepChoieAndSocre data, _) => data.score,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        cornerStyle: CornerStyle.bothCurve,
                        maximumValue: 100,
                        innerRadius: '80%',
                        strokeWidth: 5.0),
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
