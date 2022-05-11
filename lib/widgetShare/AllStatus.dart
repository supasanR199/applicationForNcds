import 'dart:html';

import 'package:appilcation_for_ncds/function/DisplayTime.dart';
import 'package:appilcation_for_ncds/function/GetDataChart.dart';
import 'package:appilcation_for_ncds/mobilecode/function/datethai.dart';
import 'package:appilcation_for_ncds/models/AlertModels.dart';
import 'package:appilcation_for_ncds/models/AlertMoodModels.dart';
import 'package:appilcation_for_ncds/models/KeepRecord.dart';
import 'package:appilcation_for_ncds/models/MutiChartData.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
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

  List<AlertModels> listData = List();
  List<AlertModels> listDataForDate = List();
  List<AlertMoodModels> listDataMood = List();
  List<AlertMoodModels> listDataForDateMood = List();
  List<MutiChartData> keepChartData = List();
  List<KeepChoieAndSocre> listKeepFoodSweet = List();
  List<KeepChoieAndSocre> listKeepFoodSelt = List();
  List<KeepChoieAndSocre> listKeepFoodFat = List();

  List<KeepChoieAndSocre> keepChartDataMood = List();
  List<DateTime> initListDate = [DateTime.now()];
  DateTime selectedDate = DateTime.now();
  DateTime selectDateMood = DateTime.now();

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
            listDataForDate.add(model);
            // print("this is shit${listData.length}");
            // listforDate.add(model);
            keepChartData = getAllAlertDataInSys(listData, DateTime.now());
            listKeepFoodSweet =
                getAllAlertDataInSysFood(listData, DateTime.now(), "sweet");
            listKeepFoodSelt =
                getAllAlertDataInSysFood(listData, DateTime.now(), "selt");
            listKeepFoodFat =
                getAllAlertDataInSysFood(listData, DateTime.now(), "fat");
          });
        }
      });
    });
    listid.forEach((e) async {
      await FirebaseFirestore.instance
          .collection("MobileUser")
          .doc(e)
          .collection("moodalert")
          .get()
          .then((value) {
        for (var i in value.docs) {
          AlertMoodModels model = AlertMoodModels.fromMap(i.data());
          setState(() {
            listDataMood.add(model);
            listDataForDateMood.add(model);
            // print("this is shit${listData.length}");
            // listforDate.add(model);
            keepChartDataMood =
                getAllAlertDataInSysMood(listDataMood, initListDate);
          });
        }
      });
    });
  }

  Widget build(BuildContext context) {
    final List<Color> color = <Color>[];
    // color.add(Colors.deepOrange[50]);
    // color.add(Colors.deepOrange[200]);
    // color.add(Colors.deepOrange);
    color.add(Colors.green);
    color.add(Colors.yellow);
    color.add(Colors.orange);
    color.add(Colors.red);

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);
    stops.add(1.5);

    final LinearGradient gradientColors =
        LinearGradient(colors: color, stops: stops);
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("MobileUser")
            .where("Role", isEqualTo: "Patient")
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Card(
              child: SizedBox(
                width: 900,
                height: 1000,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(
                              'ผลสรุปจากการทำแบบประเมินอาหาร',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // Center(
                        //   child: Text(
                        //     "ล่าสุดเมื่อเดือนที่ :  ${listDataForDate.last.date}",
                        //     style: TextStyle(fontSize: 14, color: Colors.black38),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(DateMouthAndYearThai(
                              selectedDate.toString().isEmpty
                                  ? DateTime.now().toString()
                                  : selectedDate.toString())),
                        ),
                        FloatingActionButton.small(
                          backgroundColor: Colors.blueAccent,
                          hoverColor: Colors.grey.shade200,
                          onPressed: () {
                            showMonthPicker(
                              context: context,
                              firstDate: getMinDate(listDataForDate),
                              lastDate: getMaxDate(listDataForDate),
                              initialDate: selectedDate ?? DateTime.now(),
                              locale: Locale("en"),
                            ).then((date) {
                              if (date != null) {
                                setState(() {
                                  selectedDate = date;
                                  keepChartData = getAllAlertDataInSys(
                                      listData, selectedDate);
                                  listKeepFoodSweet = getAllAlertDataInSysFood(
                                      listData, selectedDate, "sweet");
                                  listKeepFoodSelt = getAllAlertDataInSysFood(
                                      listData, selectedDate, "selt");
                                  listKeepFoodFat = getAllAlertDataInSysFood(
                                      listData, selectedDate, "fat");
                                  // var b = convertMouth(selectedDate) + "-01";
                                  // // convertMouth(selectedDate);
                                  // print(b);
                                  // var a = DateTime.parse(b);
                                  // print(a);
                                });
                              }
                            });
                          },
                          child: Icon(Icons.calendar_today),
                        ),

                        // SfCartesianChart(
                        //   primaryXAxis: CategoryAxis(),
                        //   series: <CartesianSeries>[
                        //     ColumnSeries<MutiChartData, String>(
                        //         dataSource: keepChartData,
                        //         xValueMapper: (MutiChartData data, _) => data.x,
                        //         yValueMapper: (MutiChartData data, _) => data.y),
                        //     ColumnSeries<MutiChartData, String>(
                        //         dataSource: keepChartData,
                        //         xValueMapper: (MutiChartData data, _) => data.x,
                        //         yValueMapper: (MutiChartData data, _) => data.y1),
                        //     ColumnSeries<MutiChartData, String>(
                        //         dataSource: keepChartData,
                        //         xValueMapper: (MutiChartData data, _) => data.x,
                        //         yValueMapper: (MutiChartData data, _) => data.y2),
                        //     ColumnSeries<MutiChartData, String>(
                        //         dataSource: keepChartData,
                        //         xValueMapper: (MutiChartData data, _) => data.x,
                        //         yValueMapper: (MutiChartData data, _) => data.y3)
                        //   ],
                        // ),
                        Column(
                          children: [
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  'ผลการบริโภคหวาน',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              primaryYAxis: NumericAxis(
                                  decimalPlaces: 0,
                                  title: AxisTitle(text: 'จำนวนคน')),
                              // tooltipBehavior: _tooltip,
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <ChartSeries<dynamic, String>>[
                                ColumnSeries<dynamic, String>(
                                  dataSource: listKeepFoodSweet,
                                  xValueMapper: (dynamic data, _) =>
                                      data.choice,
                                  yValueMapper: (dynamic data, _) => data.score,
                                  pointColorMapper: (dynamic data, _) =>
                                      data.color,
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true),
                                  name: 'คะแนนการประเมิน',
                                  // color: Color.fromARGB(255, 242, 150, 244))
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                    child: const Text(
                                  "สรุป ผลการบริโภคหวาน",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
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
                                  trailing: Text("คน",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Divider(thickness: 2, color: Colors.grey),
                                ListTile(
                                  leading: Text(
                                    'ข้อ1  อยู่ระดับปรกติ :',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                      listKeepFoodSweet.isEmpty
                                          ? ""
                                          : "${listKeepFoodSweet[0].score}",
                                      style: TextStyle(
                                        fontSize: 17,
                                      )),
                                ),
                                ListTile(
                                  leading: Text(
                                    'ข้อ2  อยู่ระดับปานกลาง :',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                      listKeepFoodSweet.isEmpty
                                          ? ""
                                          : "${listKeepFoodSweet[1].score}",
                                      style: TextStyle(
                                        fontSize: 17,
                                      )),
                                ),
                                ListTile(
                                  leading: Text(
                                    'ข้อ3  มีความเสี่ยงต่อโรค :',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                      listKeepFoodSweet.isEmpty
                                          ? ""
                                          : "${listKeepFoodSweet[2].score}",
                                      style: TextStyle(
                                        fontSize: 17,
                                      )),
                                ),
                                ListTile(
                                  leading: Text(
                                    'ข้อ4  มีความเสี่ยงสูงต่อโรค :',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                      listKeepFoodSweet.isEmpty
                                          ? ""
                                          : "${listKeepFoodSweet[3].score}",
                                      style: TextStyle(
                                        fontSize: 17,
                                      )),
                                ),
                                // Divider(thickness: 2, color: Colors.grey.shade300,)
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          child: Divider(
                            thickness: 4,
                            color: Colors.black87,
                          ),
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                        ),
                        Column(
                          children: [
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  'ผลการบริโภคมัน',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              primaryYAxis: NumericAxis(
                                  decimalPlaces: 0,
                                  title: AxisTitle(text: 'จำนวนคน')),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              // tooltipBehavior: _tooltip,
                              series: <ChartSeries<dynamic, String>>[
                                ColumnSeries<dynamic, String>(
                                    dataSource: listKeepFoodFat,
                                    xValueMapper: (dynamic data, _) =>
                                        data.choice,
                                    yValueMapper: (dynamic data, _) =>
                                        data.score,
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: true),
                                    pointColorMapper: (dynamic data, _) =>
                                        data.color,
                                    name: 'คะแนนการประเมิน',
                                    color: Color.fromARGB(255, 255, 229, 150))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                    child: const Text(
                                  "สรุป ผลการบริโภคมัน",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
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
                                  trailing: Text("คน",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Divider(thickness: 2, color: Colors.grey),
                                ListTile(
                                  leading: Text(
                                    'ข้อ1  อยู่ระดับปรกติ :',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                      listKeepFoodFat.isEmpty
                                          ? ""
                                          : "${listKeepFoodFat[0].score}",
                                      style: TextStyle(
                                        fontSize: 17,
                                      )),
                                ),
                                ListTile(
                                  leading: Text(
                                    'ข้อ2  อยู่ระดับปานกลาง :',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                      listKeepFoodFat.isEmpty
                                          ? ""
                                          : "${listKeepFoodFat[1].score}",
                                      style: TextStyle(
                                        fontSize: 17,
                                      )),
                                ),
                                ListTile(
                                  leading: Text(
                                    'ข้อ3  มีความเสี่ยงต่อโรค :',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                      listKeepFoodFat.isEmpty
                                          ? ""
                                          : "${listKeepFoodFat[2].score}",
                                      style: TextStyle(
                                        fontSize: 17,
                                      )),
                                ),
                                ListTile(
                                  leading: Text(
                                    'ข้อ4  มีความเสี่ยงสูงต่อโรค :',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                      listKeepFoodFat.isEmpty
                                          ? ""
                                          : "${listKeepFoodFat[3].score}",
                                      style: TextStyle(
                                        fontSize: 17,
                                      )),
                                ),
                                // Divider(thickness: 2, color: Colors.grey.shade300,)
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          child: Divider(
                            thickness: 4,
                            color: Colors.black87,
                          ),
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                        ),
                        Column(
                          children: [
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  'ผลการบริโภคเค็ม',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              primaryYAxis: NumericAxis(
                                  decimalPlaces: 0,
                                  title: AxisTitle(text: 'จำนวนคน')),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              // tooltipBehavior: _tooltip,
                              series: <ChartSeries<dynamic, String>>[
                                ColumnSeries<dynamic, String>(
                                  dataSource: listKeepFoodSelt,
                                  xValueMapper: (dynamic data, _) =>
                                      data.choice,
                                  yValueMapper: (dynamic data, _) => data.score,
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true),
                                  pointColorMapper: (dynamic data, _) =>
                                      data.color,
                                  name: 'คะแนนการประเมิน',
                                  // color: Color.fromARGB(255, 133, 105, 59),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                    child: const Text(
                                  "สรุป ผลการบริโภคเค็ม",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
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
                                  trailing: Text("คน",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.grey,
                                ),
                                ListTile(
                                  leading: Text(
                                    'ข้อ1  อยู่ระดับปรกติ :',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                      listKeepFoodSelt.isEmpty
                                          ? ""
                                          : "${listKeepFoodSelt[0].score}",
                                      style: TextStyle(
                                        fontSize: 17,
                                      )),
                                ),
                                ListTile(
                                  leading: Text(
                                    'ข้อ2  อยู่ระดับปานกลาง :',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                      listKeepFoodSelt.isEmpty
                                          ? ""
                                          : "${listKeepFoodSelt[1].score}",
                                      style: TextStyle(
                                        fontSize: 17,
                                      )),
                                ),
                                ListTile(
                                  leading: Text(
                                    'ข้อ3  มีความเสี่ยงต่อโรค :',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                      listKeepFoodSelt.isEmpty
                                          ? ""
                                          : "${listKeepFoodSelt[2].score}",
                                      style: TextStyle(
                                        fontSize: 17,
                                      )),
                                ),
                                ListTile(
                                  leading: Text(
                                    'ข้อ4  มีความเสี่ยงสูงต่อโรค :',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                      listKeepFoodSelt.isEmpty
                                          ? ""
                                          : "${listKeepFoodSelt[3].score}",
                                      style: TextStyle(
                                        fontSize: 17,
                                      )),
                                ),
                                // Divider(thickness: 2, color: Colors.grey.shade300,)
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          child: Divider(
                            thickness: 4,
                            color: Colors.black87,
                          ),
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                        ),
                        Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Text(
                                  'ผลสรุปจากการทำแบบประเมินอารมณ์',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(DateThai(
                                  selectDateMood.toString().isEmpty
                                      ? DateTime.now().toString()
                                      : selectDateMood.toString())),
                            ),
                            FloatingActionButton.small(
                              backgroundColor: Colors.blueAccent,
                              hoverColor: Colors.grey.shade200,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      showDateRangMood(
                                          context,
                                          getMinDateMood(listDataForDateMood),
                                          getMaxDateMood(listDataForDateMood),
                                          listDataForDateMood),
                                ).then((value) {
                                  // selectDateMood = value;
                                  print(value);
                                  if (value != null) {
                                    setState(() {
                                      keepChartDataMood =
                                          getAllAlertDataInSysMood(
                                              listDataMood, value);
                                    });
                                  }
                                });
                              },
                              child: Icon(Icons.calendar_today),
                            ),
                            SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              primaryYAxis: NumericAxis(
                                  decimalPlaces: 0,
                                  title: AxisTitle(text: 'จำนวนคน')),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              // tooltipBehavior: _tooltip,
                              series: <ChartSeries<dynamic, String>>[
                                ColumnSeries<dynamic, String>(
                                  dataSource: keepChartDataMood,
                                  xValueMapper: (dynamic data, _) =>
                                      data.choice,
                                  yValueMapper: (dynamic data, _) => data.score,
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true),
                                  pointColorMapper: (dynamic data, _) =>
                                      data.color,
                                  name: 'คะแนนการประเมิน',
                                  // color: Color.fromARGB(255, 237, 141, 111),
                                )
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                                child: const Text(
                              "สรุป ผลแบบประเมินอารมณ์",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
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
                              trailing: Text("คน",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Divider(thickness: 2, color: Colors.grey),
                            ListTile(
                              leading: Text(
                                'ข้อ1  ไม่มีความเครียด :',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                  keepChartDataMood.isEmpty
                                      ? ""
                                      : "${keepChartDataMood[0].score}",
                                  style: TextStyle(
                                    fontSize: 17,
                                  )),
                            ),
                            ListTile(
                              leading: Text(
                                'ข้อ2  อยู่ระดับปานกลาง :',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                  keepChartDataMood.isEmpty
                                      ? ""
                                      : "${keepChartDataMood[1].score}",
                                  style: TextStyle(
                                    fontSize: 17,
                                  )),
                            ),
                            ListTile(
                              leading: Text(
                                'ข้อ3  อยู่ระดับสูง :',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                  keepChartDataMood.isEmpty
                                      ? ""
                                      : "${keepChartDataMood[2].score}",
                                  style: TextStyle(
                                    fontSize: 17,
                                  )),
                            ),
                            ListTile(
                              leading: Text(
                                'ข้อ4  อยู่ระดับสูงที่สุด :',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                  keepChartDataMood.isEmpty
                                      ? ""
                                      : "${keepChartDataMood[3].score}",
                                  style: TextStyle(
                                    fontSize: 17,
                                  )),
                            ),
                            // Divider(thickness: 2, color: Colors.grey.shade300,)
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            );
          } else {
            return Text("กำลังโหลด");
          }
        });
  }
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
