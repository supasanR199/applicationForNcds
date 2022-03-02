import 'package:appilcation_for_ncds/models/ChartData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

List<ChartData> keepDataTest = List<ChartData>();

getAllSumDataChart() async {
  List keepDataChart = List();
  var getEva = await FirebaseFirestore.instance.collection("Evaluate").get();
  print(getEva.docs);
  getEva.docs.forEach((element) {
    keepDataChart.add(getDocTopic(element.id));
  });
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
    // keepDataTest.addEntries({element.get("topic"), element.get("score")});
    print("keep see it $keepDataTest");
  });
  Iterable<ChartData> test = keepDataTest.where((element) => element.x
      .contains("ฟังก์ชันการทำงานมีความเหมาะสมกับกับการติดตามผู้ป่วย"));
  print("see this $test");
  test.forEach((element) {
    print(element.y);
    numTest.add(element.y);
  });
  print(numTest.sum);

  return keepDataTest;
}

Future<List> getEvaluate() async {
  var getEva = await FirebaseFirestore.instance.collection("Evaluate").get();
  return getEva.docs;
}
