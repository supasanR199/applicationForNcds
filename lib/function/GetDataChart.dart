import 'dart:developer';

import 'package:appilcation_for_ncds/models/ChartData.dart';
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

getAllDataInSys(List<QueryDocumentSnapshot<Object>> listAllPatien) {
  List getAlert = List();
  // print(listAllPatien.toList());
  listAllPatien.forEach((element) async {
    var getFire = await FirebaseFirestore.instance
        .collection("MobileUser")
        .doc(element.id)
        .collection("eatalert")
        .get()
        .then((value) {
      print(value);
      getAlert.add(value);
    });
    // getAlert.add(getFire);
    // getFire.docs.forEach((element) {
    //   print("this is get ${element}");
    //   getAlert.add(element);
    // });
  });
  // print("this is get ${getAlert.toList()}");
}
