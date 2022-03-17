import 'dart:developer';

import 'package:appilcation_for_ncds/models/AlertModels.dart';
import 'package:appilcation_for_ncds/models/ChartData.dart';
import 'package:appilcation_for_ncds/models/MutiChartData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

List<ChartData> keepDataTest = List<ChartData>();
List topic = [
  "ฟังก์ชันการทำงานมีความเหมาะสมกับกับการติดตามผู้ป่วย",
  "ฟังก์ชันการทำงานของแอปพลิเคชันช่วยในการประเมินอาการของผู้ป่วยได้ง่ายขึ้น",
  "ฟังก์ชันการทำงานของแอปพลิเคชันสามารถแนะนำผู้ป่วยในการใช้ชีวิตประจำวันได้ดี",
  "หน้าจอออกแบบสวยงาม ดึงดูดการใช้งานได้ดี",
  "แอปพลิเคชันมีความง่ายต่อการบันทึกผลการตรวจของผู้ป่วย",
  "ข้อมูลที่ได้รับจากการบันทึกของผู้ป่วยมีประโยชน์ต่อการรักษา",
  "แอปพลิเคชันช่วยลดขั้นตอนการทำงานได้",
  "การโต้ตอบระหว่างผู้ใช้งานกับแอปพลิเคชัน มีความสะดวกและเข้าใจง่าย",
];
List<Iterable<ChartData>> keepIter = List();
List<ChartData> keepChartDataList = List();
Future<List<ChartData>> getAllSumDataChart() async {
  List keepDataChart = List();
  var getEva = await FirebaseFirestore.instance.collection("Evaluate").get();

  getEva.docs.forEach((element) {
    keepDataChart.add(getDocTopic(element.id));
  });
  return keepChartDataList;
}

Future<List> getDocTopic(String uid) async {
  var getDoc = await FirebaseFirestore.instance
      .collection("Evaluate")
      .doc(uid)
      .collection("topic")
      .get();
  List<double> numTest = List();
  List _docs = List();
  List _keepElemnt = List();
  getDoc.docs.forEach((element) {
    ChartData keepData = ChartData(element.get("topic"), element.get("score"));
    keepDataTest.add(keepData);
  });
  topic.forEach((element) {
    var topic = element;
    List<double> numList = List();
    Iterable<ChartData> keepTopic =
        keepDataTest.where((element) => element.x.contains(topic));
    keepTopic.forEach((element) {
      numList.add(element.y);
    });
    ChartData keepChart = ChartData(topic, numList.sum);
    keepChartDataList.add(keepChart);
  });
  // Iterable<ChartData> test = keepDataTest.where((element) => element.x
  //     .contains("ฟังก์ชันการทำงานมีความเหมาะสมกับกับการติดตามผู้ป่วย"));
  // print("see this $test");
  // test.forEach((element) {
  //   print(element.y);
  //   numTest.add(element.y);
  // });
  // print(numTest.sum);

  return keepChartDataList;
}

Future<List> getEvaluate() async {
  var getEva = await FirebaseFirestore.instance.collection("Evaluate").get();
  return getEva.docs;
}

List<MutiChartData> getAllAlertDataInSys(List<AlertModels> listAllPatien) {
  List getScore = List();
  List getAlert = List();
  //
  List<MutiChartData> _returnList = List();
  //
  List<int> fatalertnomal = List();
  List<int> fatalertmediam = List();
  List<int> fatalertalert = List();
  List<int> fatalertdangerus = List();
  //
  List<int> saltalertnomal = List();
  List<int> saltalertmediam = List();
  List<int> saltalertalert = List();
  List<int> saltalertangerus = List();
  //
  List<int> sweetalertnomal = List();
  List<int> sweetalertmediam = List();
  List<int> sweetalertalert = List();
  List<int> sweetalertdangerus = List();

  listAllPatien.forEach((element) {
    if (element.date == "2022-3") {
      if (element.fatalert != 0) {
        if (element.fatalert == 5) {
          fatalertnomal.add(1);
        } else if (element.fatalert >= 6 && element.fatalert <= 9) {
          fatalertmediam.add(1);
        } else if (element.fatalert >= 10 && element.fatalert <= 13) {
          fatalertalert.add(1);
        } else if (element.fatalert >= 14) {
          fatalertdangerus.add(1);
        }
      }
      //
      if (element.saltalert != 0) {
        if (element.saltalert == 5) {
          saltalertnomal.add(1);
        } else if (element.saltalert >= 6 && element.saltalert <= 9) {
          saltalertmediam.add(1);
        } else if (element.saltalert >= 10 && element.saltalert <= 13) {
          saltalertalert.add(1);
        } else if (element.saltalert >= 14) {
          saltalertangerus.add(1);
        }
      }
      //
      if (element.sweetalert != 0) {
        if (element.sweetalert == 5) {
          sweetalertnomal.add(1);
        } else if (element.sweetalert >= 6 && element.sweetalert <= 9) {
          sweetalertmediam.add(1);
        } else if (element.sweetalert >= 10 && element.sweetalert <= 13) {
          sweetalertalert.add(1);
        } else if (element.sweetalert >= 14) {
          sweetalertdangerus.add(1);
        }
      }
      //
    }
  });
  MutiChartData keepfat = MutiChartData(
      "มัน",
      fatalertnomal.sum.toDouble(),
      fatalertmediam.sum.toDouble(),
      fatalertalert.sum.toDouble(),
      fatalertdangerus.sum.toDouble());
  MutiChartData keepsalt = MutiChartData(
      "เค็ม",
      saltalertnomal.sum.toDouble(),
      saltalertmediam.sum.toDouble(),
      saltalertalert.sum.toDouble(),
      saltalertangerus.sum.toDouble());
  MutiChartData keepsweet = MutiChartData(
      "หวาน",
      sweetalertnomal.sum.toDouble(),
      sweetalertmediam.sum.toDouble(),
      sweetalertalert.sum.toDouble(),
      sweetalertdangerus.sum.toDouble());
  _returnList.add(keepfat);
  _returnList.add(keepsalt);
  _returnList.add(keepsweet);
  _returnList.forEach((e) {
    print("this name  ${e.x}");
    print("this nomal ${e.y}");
    print("this mediam  ${e.y1}");
    print("this alert ${e.y2}");
    print("this dangerus  ${e.y3}");
  });
  // print("this nomal ${fatalertnomal.toList()}");
  // print("this mediam${fatalertmediam.toList()}");
  // print("this alert${fatalertalert.toList()}");
  // print("this dangerus ${fatalertdangerus.toList()}");

  // print("this nomal ${saltalertnomal.toList()}");
  // print("this mediam${saltalertmediam.toList()}");
  // print("this alert${saltalertalert.toList()}");
  // print("this dangerus ${saltalertangerus.toList()}");

  // print("this nomal ${sweetalertnomal.toList()}");
  // print("this mediam${sweetalertmediam.toList()}");
  // print("this alert${sweetalertalert.toList()}");
  // print("this dangerus ${sweetalertdangerus.toList()}");

  return _returnList;
}

setToList(num val) {
  List<int> fatalertnomal = List();
  List<int> fatalertmediam = List();
  List<int> fatalertalert = List();
  List<int> fatalertdangerus = List();
  //
  List<int> saltalertnomal = List();
  List<int> saltalertmediam = List();
  List<int> saltalertalert = List();
  List<int> saltalertangerus = List();
  //
  List<int> sweetalerttnomal = List();
  List<int> sweetalerttmediam = List();
  List<int> sweetalertalert = List();
  List<int> sweetalertdangerus = List();
}
