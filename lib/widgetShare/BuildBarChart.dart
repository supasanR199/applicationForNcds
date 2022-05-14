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
        // print(value);
        keepChartList = value;
      });
    });
  }

  Future<List<ChartData>> getEvaluates() async {
    List<Color> colors = [
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red,
      Colors.grey
    ];
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
      keepAllscore.add(keepscore1.average);
      keepAllscore.add(keepscore2.average);
      keepAllscore.add(keepscore3.average);
      keepAllscore.add(keepscore4.average);
      keepAllscore.add(keepscore5.average);
      counter = 0;
      topic.forEach((key, value) {
        ChartData keepchart =
            ChartData(key, keepAllscore[counter], colors[counter]);
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
  // final List<ChartData> chartData = [
  //   ChartData("แอปพลิเคชันทำงานได้อย่างถูกต้อง", 35),
  //   ChartData("แอปพลิเคชันทำงานได้ง่าย", 23),
  //   ChartData("แอปพลิเคชันมีคำอธิบายที่เหมาะสม", 34),
  //   ChartData("แอปพลิเคชันมีความเหมาะสมในการใช้งาน", 25),
  //   ChartData("ความพึงพอใจต่อระบบภาพรวม", 40)
  // ];

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
                  // SfCartesianChart(
                  //   primaryXAxis: CategoryAxis(),
                  //   series: <ChartSeries<ChartData, String>>[
                  //     // Renders bar chart
                  //     BarSeries<ChartData, String>(
                  //         dataSource: keepChartList,
                  //         xValueMapper: (ChartData data, _) => data.x,
                  //         yValueMapper: (ChartData data, _) => data.y)
                  //   ],
                  // ),
                  SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                      decimalPlaces: 0,
                      // title: AxisTitle(text: 'จำนวนคน')
                    ),
                    // tooltipBehavior: _tooltip,
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<dynamic, String>>[
                      ColumnSeries<dynamic, String>(
                        dataSource: keepChartList,
                        xValueMapper: (dynamic data, _) => data.x,
                        yValueMapper: (dynamic data, _) => data.y,
                        pointColorMapper: (dynamic data, _) => data.color,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        name: 'คะแนนการประเมิน',
                        // color: Color.fromARGB(255, 242, 150, 244))
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        // Center(
                        //     child: const Text(
                        //   "สรุป ผลการบริโภคหวาน",
                        //   style: TextStyle(
                        //       fontSize: 20, fontWeight: FontWeight.bold),
                        // )),
                        const SizedBox(
                          height: 15,
                        ),
                        ListTile(
                          leading: Text(
                            'ผลการประเมิน',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text("คะแนน",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Divider(thickness: 2, color: Colors.grey),
                        ListTile(
                          leading: Text(
                            'ข้อ1  แอปพลิเคชันทำงานได้อย่างถูกต้อง :',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                              keepChartList.isEmpty
                                  ? ""
                                  : "${keepChartList[0].y}",
                              style: TextStyle(
                                fontSize: 17,
                              )),
                        ),
                        ListTile(
                          leading: Text(
                            'ข้อ2  แอปพลิเคชันทำงานได้ง่าย :',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                              keepChartList.isEmpty
                                  ? ""
                                  : "${keepChartList[1].y}",
                              style: TextStyle(
                                fontSize: 17,
                              )),
                        ),
                        ListTile(
                          leading: Text(
                            'ข้อ3  แอปพลิเคชันมีคำอธิบายที่เหมาะสม :',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                              keepChartList.isEmpty
                                  ? ""
                                  : "${keepChartList[2].y}",
                              style: TextStyle(
                                fontSize: 17,
                              )),
                        ),
                        ListTile(
                          leading: Text(
                            'ข้อ4  แอปพลิเคชันมีความเหมาะสมในการใช้งาน :',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                              keepChartList.isEmpty
                                  ? ""
                                  : "${keepChartList[3].y}",
                              style: TextStyle(
                                fontSize: 17,
                              )),
                        ),
                        ListTile(
                          leading: Text(
                            'ข้อ5  ความพึงพอใจต่อระบบภาพรวม :',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                              keepChartList.isEmpty
                                  ? ""
                                  : "${keepChartList[4].y}",
                              style: TextStyle(
                                fontSize: 17,
                              )),
                        ),
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
