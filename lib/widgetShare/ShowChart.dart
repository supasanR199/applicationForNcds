import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:appilcation_for_ncds/models/ChartData.dart';

class ShowChart extends StatefulWidget {
  double scoreMax;
  List<ChartData> dataSource;
  ShowChart({Key key, @required this.scoreMax, this.dataSource})
      : super(key: key);

  @override
  _ShowChartState createState() => _ShowChartState();
}

class _ShowChartState extends State<ShowChart> {
  @override
  List<ChartData> listDataChart = List<ChartData>();
  double scoreCount;
  double scoreMax;
  // void initState() {
  //   super.initState();
  // }

  var _tooltip = TooltipBehavior(enable: true);
  Widget build(BuildContext context) {
    // getDataChart();
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis:
          NumericAxis(minimum: 0, maximum: widget.scoreMax, interval: 1),
      tooltipBehavior: _tooltip,
      series: <ChartSeries<ChartData, String>>[
        BarSeries<ChartData, String>(
            dataSource: widget.dataSource,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            name: 'คะแนนการประเมิน',
            color: Color.fromRGBO(8, 142, 255, 1))
      ],
    );
  }

  // Future getDataChart() async {
  //   QuerySnapshot querySnapshot =
  //       await FirebaseFirestore.instance.collection("Evaluate").get();
  //   QuerySnapshot querySnapshot_topic;

  //   // print("scoreMax: $scoreMax");
  //   querySnapshot.docs.forEach((element) async {
  //     querySnapshot_topic = await FirebaseFirestore.instance
  //         .collection("Evaluate")
  //         .doc(element.id)
  //         .collection("topic")
  //         .get();
  //     // print(element.id);
  //     // print(element.data());
  //     // print("----------------------------------------");
  //     querySnapshot_topic.docs.forEach((element) {
  //       _ChartData keepData =
  //           _ChartData(element.get("topic"), element.get("score"));
  //       // print(element.get("topic"));
  //       // print(element.get("score"));
  //       setState(() {
  //         scoreMax = (querySnapshot.docs.length * 4) as double;
  //         listDataChart.add(keepData);
  //       });

  //       // inspect(element.data());
  //       // scoreCount = element.get("score") + scoreCount;
  //       // print("sum is: {$scoreCount}");
  //       // snapshot = element.data();
  //       // print(snapshot);
  //     });
  //     // print("+++++++++++++++++++++++++++++++++++++++++++");
  //     // print(listDataChart.length);
  //     // print("score is: $scoreMax");
  //   });
  // }

}

// class _ChartData {
//   _ChartData(this.x, this.y);

//   final String x;
//   final double y;
// }
