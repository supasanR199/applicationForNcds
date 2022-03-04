import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:appilcation_for_ncds/models/ChartData.dart';

class ShowChartBar extends StatefulWidget {
  double scoreMax;
  List<dynamic> dataSource;
  ShowChartBar({Key key, @required this.scoreMax, this.dataSource})
      : super(key: key);

  @override
  _ShowChartState createState() => _ShowChartState();
}

class _ShowChartState extends State<ShowChartBar> {
  @override
  List<dynamic> listDataChart = List<dynamic>();
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
      primaryYAxis: NumericAxis(),
      tooltipBehavior: _tooltip,
      series: <ChartSeries<dynamic, String>>[
        ColumnSeries<dynamic, String>(
            dataSource: widget.dataSource,
            xValueMapper: (dynamic data, _) => data.choice,
            yValueMapper: (dynamic data, _) => data.score,
            name: 'คะแนนการประเมิน',
            color: Color.fromRGBO(8, 142, 255, 1))
      ],
    );
  }
}
