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
  int peopleCount;
  List<ChartData> keepChartList = List();
  List<ChartData> keepChartListVol = List();
  List<ChartData> keepChartListHos = List();
  List<ChartData> keepChartListMe = List();
  List<List<ChartData>> keepAllRoles = List();
  List<int> keepCountPeplo = List();
  List<String> getCommentHos = List();
  List<String> getCommentMd = List();
  List<String> getCommentPa = List();
  List<String> getCommentVol = List();
  final List<String> evaIdList = [
    "Hospital",
    "Medicalpersonnel",
    "Patient",
    "Volunteer"
  ];

  void initState() {
    // _items = _generateItems;
    super.initState();

    evaIdList.forEach((e) {
      getEvaluates(e).then((value) {
        List<ChartData> keepChartList = List();
        keepChartList = value;
        setState(() {
          keepAllRoles.add(keepChartList);
        });
      });
      getCountPeplo(e).then((value) {
        int keepCount;
        keepCount = value;
        setState(() {
          keepCountPeplo.add(keepCount);
        });
      });
      getComment(e);
    });
    // print(keepCountPeplo);
    // getEvaluates().then((value) {
    //   setState(() {
    //     // print(value);
    //     keepChartListPt = value;
    //   });
    // });
  }

  getComment(String id) async {
    List<String> getCommentStr = List();
    await FirebaseFirestore.instance
        .collection("Evaluate")
        .doc(id)
        .collection("comment")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        getCommentStr.add(element.get("comment"));
      });
      if (id == "Hospital") {
        setState(() {
          getCommentHos = getCommentStr;
        });
      } else if (id == "Medicalpersonnel") {
        setState(() {
          getCommentMd = getCommentStr;
        });
      } else if (id == "Patient") {
        setState(() {
          getCommentPa = getCommentStr;
        });
      } else if (id == "Volunteer") {
        setState(() {
          getCommentVol = getCommentStr;
        });
      }

      // print("show ${value.docs.toList()}");
      // print("show ${value.docs.}");
    });
  }

  Future<int> getCountPeplo(String id) async {
    int peploCount;
    await FirebaseFirestore.instance
        .collection("Evaluate")
        .doc(id)
        .collection("topic")
        .get()
        .then((value) {
      // peploCount = value.docs.length;
      // setState(() {
      peploCount = value.docs.length;
      // print(peploCount);
      // });
      // return value.docs.length;
    });
    return peploCount;

    // print(peopleCount);
    // return peopleCount;
  }

  Future<List<ChartData>> getEvaluates(String id) async {
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
        .doc(id)
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
            ChartData(topicThai[key], keepAllscore[counter], colors[counter]);
        _returnList.add(keepchart);
        counter++;
      });
    });
    return _returnList;
  }

  List keepList = List();

  final Map<String, String> topic = {
    "Choice1": "แอปพลิเคชันทำงานได้อย่างถูกต้อง",
    "Choice2": "แอปพลิเคชันทำงานได้ง่าย",
    "Choice3": "แอปพลิเคชันมีคำอธิบายที่เหมาะสม",
    "Choice4": "แอปพลิเคชันมีความเหมาะสมในการใช้งาน",
    "Choice5": "ความพึงพอใจต่อระบบภาพรวม"
  };
  final Map<String, String> topicThai = {
    "Choice1": "ข้อ1",
    "Choice2": "ข้อ2",
    "Choice3": "ข้อ3",
    "Choice4": "ข้อ4",
    "Choice5": "ข้อ5"
  };
  double scoreCount;
  List<ChartData> keepAllSSumSocre = List();
  double scoreMax;
  Widget build(BuildContext context) {
    if (keepAllRoles.isEmpty || keepAllRoles.length != 4) {
      return Center(child: Text("กำลังโหลด"));
    } else {
      return Container(
        child: Center(
          child: Card(
            child: SizedBox(
              height: 800,
              width: 1400,
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
                          dataSource: keepAllRoles[2],
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
                              'ข้อ1  แสดงข้อมูลได้ถูกต้องครบถ้วน :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[2].isEmpty
                                    ? ""
                                    : "${keepAllRoles[2][0].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          ListTile(
                            leading: Text(
                              'ข้อ2  ระบบใช้งานง่ายไม่ซับซ้อน :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[2].isEmpty
                                    ? ""
                                    : "${keepAllRoles[2][1].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          ListTile(
                            leading: Text(
                              'ข้อ3  ความเหมาะสมในการใช้ ข้อความ รูปภาพ และสัญลักษณ์ ในการสื่อความหมาย :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[2].isEmpty
                                    ? ""
                                    : "${keepAllRoles[2][2].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          ListTile(
                            leading: Text(
                              'ข้อ4  ความเสถียรในการใช้งานระบบ :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[2].isEmpty
                                    ? ""
                                    : "${keepAllRoles[2][3].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          ListTile(
                            leading: Text(
                              'ข้อ5  ความพึงพอใจในการใช้งานระบบโดยรวม :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[2].isEmpty
                                    ? ""
                                    : "${keepAllRoles[2][4].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          Divider(thickness: 2, color: Colors.grey),
                          ListTile(
                            leading: Text(
                              'มีผู้ประเมินทั้งหมด :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepCountPeplo.isEmpty
                                    ? ""
                                    : "${keepCountPeplo[2]} คน",
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
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height- 190,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: getCommentPa.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: Text("${index + 1}."),
                              title: Text("${getCommentPa[index]}"),
                            );
                          },
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              "ประเมินการใช้งานของ อสม.",
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
                      primaryYAxis: NumericAxis(
                        decimalPlaces: 0,
                        // title: AxisTitle(text: 'จำนวนคน')
                      ),
                      // tooltipBehavior: _tooltip,
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<dynamic, String>>[
                        ColumnSeries<dynamic, String>(
                          dataSource: keepAllRoles[3],
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
                              'ข้อ1  แสดงข้อมูลได้ถูกต้องครบถ้วน :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[3].isEmpty
                                    ? ""
                                    : "${keepAllRoles[3][0].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          ListTile(
                            leading: Text(
                              'ข้อ2  ระบบใช้งานง่ายไม่ซับซ้อน :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[3].isEmpty
                                    ? ""
                                    : "${keepAllRoles[3][1].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          ListTile(
                            leading: Text(
                              'ข้อ3  ความเหมาะสมในการใช้ ข้อความ รูปภาพ และสัญลักษณ์ ในการสื่อความหมาย :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[3].isEmpty
                                    ? ""
                                    : "${keepAllRoles[3][2].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          ListTile(
                            leading: Text(
                              'ข้อ4  ความเสถียรในการใช้งานระบบ :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[3].isEmpty
                                    ? ""
                                    : "${keepAllRoles[3][3].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          ListTile(
                            leading: Text(
                              'ข้อ5  ความพึงพอใจในการใช้งานระบบโดยรวม :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[3].isEmpty
                                    ? ""
                                    : "${keepAllRoles[3][4].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          Divider(thickness: 2, color: Colors.grey),
                          ListTile(
                            leading: Text(
                              'มีผู้ประเมินทั้งหมด :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepCountPeplo.isEmpty
                                    ? ""
                                    : "${keepCountPeplo[3]} คน",
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
                              "ข้อเสนอแนะของ  อสม.",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height- 190,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: getCommentVol.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: Text("${index + 1}."),
                              title: Text("${getCommentVol[index]}"),
                            );
                          },
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              "ประเมินการใช้งานของ รพสต.",
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
                      primaryYAxis: NumericAxis(
                        decimalPlaces: 0,
                        // title: AxisTitle(text: 'จำนวนคน')
                      ),
                      // tooltipBehavior: _tooltip,
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<dynamic, String>>[
                        ColumnSeries<dynamic, String>(
                          dataSource: keepAllRoles[0],
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
                              'ข้อ1  แสดงข้อมูลได้ถูกต้องครบถ้วน :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[0].isEmpty
                                    ? ""
                                    : "${keepAllRoles[0][0].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          ListTile(
                            leading: Text(
                              'ข้อ2  ระบบใช้งานง่ายไม่ซับซ้อน :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[0].isEmpty
                                    ? ""
                                    : "${keepAllRoles[0][1].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          ListTile(
                            leading: Text(
                              'ข้อ3  ความเหมาะสมในการใช้ ข้อความ รูปภาพ และสัญลักษณ์ ในการสื่อความหมาย :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[0].isEmpty
                                    ? ""
                                    : "${keepAllRoles[0][2].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          ListTile(
                            leading: Text(
                              'ข้อ4  ความเสถียรในการใช้งานระบบ :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[0].isEmpty
                                    ? ""
                                    : "${keepAllRoles[0][3].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          ListTile(
                            leading: Text(
                              'ข้อ5  ความพึงพอใจในการใช้งานระบบโดยรวม :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[0].isEmpty
                                    ? ""
                                    : "${keepAllRoles[0][4].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          Divider(thickness: 2, color: Colors.grey),
                          ListTile(
                            leading: Text(
                              'มีผู้ประเมินทั้งหมด :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepCountPeplo.isEmpty
                                    ? ""
                                    : "${keepCountPeplo[0]} คน",
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
                              "ข้อเสนอแนะของ  รพสต.",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height- 190,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: getCommentHos.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: Text("${index + 1}."),
                              title: Text("${getCommentHos[index]}"),
                            );
                          },
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              "ประเมินการใช้งานของบุคลากรทางการแพทย์",
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
                      primaryYAxis: NumericAxis(
                        decimalPlaces: 0,
                        // title: AxisTitle(text: 'จำนวนคน')
                      ),
                      // tooltipBehavior: _tooltip,
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<dynamic, String>>[
                        ColumnSeries<dynamic, String>(
                          dataSource: keepAllRoles[1],
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
                              'ข้อ1  แสดงข้อมูลได้ถูกต้องครบถ้วน :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[1].isEmpty
                                    ? ""
                                    : "${keepAllRoles[1][0].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          ListTile(
                            leading: Text(
                              'ข้อ2  ระบบใช้งานง่ายไม่ซับซ้อน :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[1].isEmpty
                                    ? ""
                                    : "${keepAllRoles[1][1].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          ListTile(
                            leading: Text(
                              'ข้อ3  ความเหมาะสมในการใช้ ข้อความ รูปภาพ และสัญลักษณ์ ในการสื่อความหมาย :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[1].isEmpty
                                    ? ""
                                    : "${keepAllRoles[1][2].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          ListTile(
                            leading: Text(
                              'ข้อ4  ความเสถียรในการใช้งานระบบ :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[1].isEmpty
                                    ? ""
                                    : "${keepAllRoles[1][3].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          ListTile(
                            leading: Text(
                              'ข้อ5  ความพึงพอใจในการใช้งานระบบโดยรวม :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepAllRoles[1].isEmpty
                                    ? ""
                                    : "${keepAllRoles[1][4].y}",
                                style: TextStyle(
                                  fontSize: 17,
                                )),
                          ),
                          Divider(thickness: 2, color: Colors.grey),
                          ListTile(
                            leading: Text(
                              'มีผู้ประเมินทั้งหมด :',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                                keepCountPeplo.isEmpty
                                    ? ""
                                    : "${keepCountPeplo[1]} คน",
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
                              "ข้อเสนอแนะของบุคลากรทางการแพทย์",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height- 190,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: getCommentMd.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: Text("${index + 1}."),
                              title: Text("${getCommentMd[index]}"),
                            );
                          },
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                        ),
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
}
