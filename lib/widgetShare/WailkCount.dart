import 'dart:developer';

import 'package:appilcation_for_ncds/function/GetDataChart.dart';
import 'package:appilcation_for_ncds/function/getRecordPatient.dart';
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
  List<KeepChoieAndSocre> chartData = List();
  List<KeepChoieAndSocre> getAll = List();
  List<String> selectDay = List();
  String showStepCount;
  var _value;
  void initState() {
    FirebaseFirestore.instance
        .collection("MobileUser")
        .doc(widget.patientId.id)
        .collection("sensordiary")
        .orderBy("Date", descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        KeepChoieAndSocre getEle =
            KeepChoieAndSocre(element.get("Date"), element.get("Step"));
        setState(() {
          getAll.add(getEle);
        });
      });
      setState(() {
        getAll.forEach((element) {
          selectDay.add(element.choice);
        });
        chartData.add(getAll.first);
        showStepCount = getAll.first.score.toString();
        _value = getAll.first.choice.toString();
      });
    });
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
          return Card(
            child: SizedBox(
              height: 700,
              width: 1000,
              child: SingleChildScrollView(
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
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: 500,
                        height: 200,
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          series: <ChartSeries>[
                            // Renders line chart
                            LineSeries<KeepChoieAndSocre, String>(
                                dataSource: getAll,
                                xValueMapper: (KeepChoieAndSocre data, _) =>
                                    data.choice,
                                yValueMapper: (KeepChoieAndSocre data, _) =>
                                    data.score)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 50,
                        right: 50,
                        top: 70,
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _value,
                        decoration: InputDecoration(
                          labelText: 'วันที่บันทึก',
                          icon: Icon(Icons.people),
                        ),
                        items: selectDay.map((String values) {
                          // print(values);
                          return DropdownMenuItem<String>(
                            value: values,
                            child: Text(values),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          // print(newValue);
                          setState(() {
                            // debugger();
                            _value = newValue;
                            chartData.clear();
                            chartData = getStepFromDate(getAll, _value);
                            showStepCount = chartData.first.score.toString();
                          });
                        },
                      ),
                    ),
                    SfCircularChart(annotations: <CircularChartAnnotation>[
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
                          xValueMapper: (KeepChoieAndSocre data, _) =>
                              data.choice,
                          yValueMapper: (KeepChoieAndSocre data, _) =>
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
            ),
          );
        } else {
          return Text("กำลังโหลด");
        }
      },
    );
  }
}
