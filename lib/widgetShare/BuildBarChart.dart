import 'package:appilcation_for_ncds/models/ChartData.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowChart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BuildBarChart extends StatefulWidget {
  const BuildBarChart({Key key}) : super(key: key);

  @override
  State<BuildBarChart> createState() => _BuildBarChartState();
}

class _BuildBarChartState extends State<BuildBarChart> {
  @override
  List<ChartData> keepChartList = List();
  void initState() {
    // _items = _generateItems;
    super.initState();

    getEvaluates().then((value) {
      setState(() {
        print(value);
        keepChartList = value;
      });
    });
  }

  Future<List<ChartData>> getEvaluates() async {
    List<ChartData> _returnList = List();
    List<double> keepscore1 = List();
    List<double> keepscore2 = List();
    List<double> keepscore3 = List();
    List<double> keepscore4 = List();
    List<double> keepscore5 = List();
    List<double> keepAllscore = List();
    int counter = 0;

    await FirebaseFirestore.instance
        .collection("Evaluate")
        .doc("Patient")
        .collection("topic")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        topic.forEach((key, value) {
          if (key == "Choice1") {
            keepscore1.add(element.get(key));
          } else if (key == "Choice2") {
            keepscore2.add(element.get(key));
          } else if (key == "Choice3") {
            keepscore3.add(element.get(key));
          } else if (key == "Choice4") {
            keepscore4.add(element.get(key));
          } else if (key == "Choice5") {
            keepscore5.add(element.get(key));
          }
        });
      });
      keepAllscore.add(keepscore1.sum);
      keepAllscore.add(keepscore2.sum);
      keepAllscore.add(keepscore3.sum);
      keepAllscore.add(keepscore4.sum);
      keepAllscore.add(keepscore5.sum);
      counter = 0;
      topic.forEach((key, value) {
        ChartData keepchart = ChartData(value, keepAllscore[counter]);
        _returnList.add(keepchart);
        counter++;
      });
      print("return ${_returnList.toList()}");
    });
    return _returnList;
  }
  // Future<List<dynamic>> getComent()async{
  //   await FirebaseFirestore.instance.collection("Evaluate").doc("comment")
  // }

  List keepList = List();
  final List<String> evaIdList = [
    "Hospital",
    "Medicalpersonnel",
    "Patient",
    "Volunteer"
  ];
  final Map<String, String> topic = {
    "Choice1": "แอปพลิเคชันทำงานได้อย่างถูกต้อง",
    "Choice2": "แอปพลิเคชันทำงานได้ง่าย",
    "Choice3": "แอปพลิเคชันมีคำอธิบายที่เหมาะสม",
    "Choice4": "แอปพลิเคชันมีความเหมาะสมในการใช้งาน",
    "Choice5": "ความพึงพอใจต่อระบบภาพรวม"
  };
  final List<ChartData> chartData = [
    ChartData("แอปพลิเคชันทำงานได้อย่างถูกต้อง", 35),
    ChartData("แอปพลิเคชันทำงานได้ง่าย", 23),
    ChartData("แอปพลิเคชันมีคำอธิบายที่เหมาะสม", 34),
    ChartData("แอปพลิเคชันมีความเหมาะสมในการใช้งาน", 25),
    ChartData("ความพึงพอใจต่อระบบภาพรวม", 40)
  ];

  double scoreCount;
  List<ChartData> keepAllSSumSocre = List();
  double scoreMax;
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Card(
          child: SizedBox(
            height: 700,
            width: 1000,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            "ประเมินการใช้งาน",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                    Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            "ประเมินการใช้งานของผู้ป่วย",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries<ChartData, String>>[
                      // Renders bar chart
                      BarSeries<ChartData, String>(
                          dataSource: keepChartList,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y)
                    ],
                  ),
                    Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            "ข้อเสนอแนะของผู้ป่วย",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //  margin: EdgeInsets.only(top: 100,bottom: 400,),
        ),
      ),
    );
  }
}
