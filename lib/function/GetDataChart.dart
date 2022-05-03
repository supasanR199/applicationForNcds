import 'dart:developer';

import 'package:appilcation_for_ncds/function/DisplayTime.dart';
import 'package:appilcation_for_ncds/models/AlertModels.dart';
import 'package:appilcation_for_ncds/models/AlertMoodModels.dart';
import 'package:appilcation_for_ncds/models/ChartData.dart';
import 'package:appilcation_for_ncds/models/KeepRecord.dart';
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

List<MutiChartData> getAllAlertDataInSys(
    List<AlertModels> listAllPatien, DateTime dateSelect) {
  String initMouth = convertMouth(dateSelect);
  //
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
    if (element.date == initMouth) {
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
  _returnList.forEach((e) {});

  return _returnList;
}

List<KeepChoieAndSocre> getAllAlertDataInSysFood(
    List<AlertModels> listAllPatien, DateTime dateSelect, String foodCategory) {
  String initMouth = convertMouth(dateSelect);
  //
  List getScore = List();
  List getAlert = List();
  //
  List<KeepChoieAndSocre> _returnList = List();
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
    if (element.date == initMouth) {
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
  if (foodCategory == "sweet") {
    KeepChoieAndSocre keepsweetnomal =
        KeepChoieAndSocre("ปกติ", sweetalertnomal.sum.toDouble());
    KeepChoieAndSocre keepsweetmediam =
        KeepChoieAndSocre("ปานกลาง", sweetalertmediam.sum.toDouble());
    KeepChoieAndSocre keepsweetalert =
        KeepChoieAndSocre("มีความเสี่ยง", sweetalertalert.sum.toDouble());
    KeepChoieAndSocre keepsweetdangerus =
        KeepChoieAndSocre("อันตราย", sweetalertdangerus.sum.toDouble());
    _returnList.add(keepsweetnomal);
    _returnList.add(keepsweetmediam);
    _returnList.add(keepsweetalert);
    _returnList.add(keepsweetdangerus);
    return _returnList;
  } else if (foodCategory == "selt") {
    KeepChoieAndSocre keepseltnomal =
        KeepChoieAndSocre("ปกติ", saltalertnomal.sum.toDouble());
    KeepChoieAndSocre keepseltmediam =
        KeepChoieAndSocre("ปานกลาง", saltalertmediam.sum.toDouble());
    KeepChoieAndSocre keepseltalert =
        KeepChoieAndSocre("มีความเสี่ยง", saltalertalert.sum.toDouble());
    KeepChoieAndSocre keepseltdangerus =
        KeepChoieAndSocre("อันตราย", saltalertangerus.sum.toDouble());
    _returnList.add(keepseltnomal);
    _returnList.add(keepseltmediam);
    _returnList.add(keepseltalert);
    _returnList.add(keepseltdangerus);
    return _returnList;
  } else if (foodCategory == "fat") {
    KeepChoieAndSocre keepfatnomal =
        KeepChoieAndSocre("ปกติ", fatalertnomal.sum.toDouble());
    KeepChoieAndSocre keepfatmediam =
        KeepChoieAndSocre("ปานกลาง", fatalertmediam.sum.toDouble());
    KeepChoieAndSocre keepfatalert =
        KeepChoieAndSocre("มีความเสี่ยง", fatalertalert.sum.toDouble());
    KeepChoieAndSocre keepfatdangerus =
        KeepChoieAndSocre("อันตราย", fatalertdangerus.sum.toDouble());
    _returnList.add(keepfatnomal);
    _returnList.add(keepfatmediam);
    _returnList.add(keepfatalert);
    _returnList.add(keepfatdangerus);
    return _returnList;
  }
}

List<KeepChoieAndSocre> getAllAlertDataInSysMood(
    List<AlertMoodModels> listAllPatien, List<DateTime> dateSelect) {
  List<String> dateToSring = List();
  // String initDay = convertDay(dateSelect);
  //
  List getScore = List();
  List getAlert = List();
  //
  List<KeepChoieAndSocre> _returnList = List();
  //

  List<int> moodalertnomal = List();
  List<int> moodalertmediam = List();
  List<int> moodalertalert = List();
  List<int> moodalertdangerus = List();

  dateSelect.forEach((element) {
    dateToSring.add(convertDay(element));
  });

  listAllPatien.forEach((element) {
    dateToSring.forEach((e) {
      if (e == element.date) {
        if (element.moodtoday == 5) {
          moodalertnomal.add(1);
        } else if (element.moodtoday >= 6 && element.moodtoday <= 9) {
          moodalertmediam.add(1);
        } else if (element.moodtoday >= 10 && element.moodtoday <= 13) {
          moodalertalert.add(1);
        } else if (element.moodtoday >= 14) {
          moodalertdangerus.add(1);
        }
      }
    });
    // if (element.date == initDay) {
    //   if (element.moodtoday != 0) {
    //     if (element.moodtoday == 5) {
    //       moodalertnomal.add(1);
    //     } else if (element.moodtoday >= 6 && element.moodtoday <= 9) {
    //       moodalertmediam.add(1);
    //     } else if (element.moodtoday >= 10 && element.moodtoday <= 13) {
    //       moodalertalert.add(1);
    //     } else if (element.moodtoday >= 14) {
    //       moodalertdangerus.add(1);
    //     }
    //   }
    // }
  });
  KeepChoieAndSocre nomal =
      KeepChoieAndSocre("nomal", moodalertnomal.sum.toDouble());
  KeepChoieAndSocre mediam =
      KeepChoieAndSocre("mediam", moodalertmediam.sum.toDouble());
  KeepChoieAndSocre alert =
      KeepChoieAndSocre("alert", moodalertalert.sum.toDouble());
  KeepChoieAndSocre dangerus =
      KeepChoieAndSocre("dangerus", moodalertnomal.sum.toDouble());

  // MutiChartData keepfat = MutiChartData(
  //     "มัน",
  //     fatalertnomal.sum.toDouble(),
  //     fatalertmediam.sum.toDouble(),
  //     fatalertalert.sum.toDouble(),
  //     fatalertdangerus.sum.toDouble());
  // MutiChartData keepsalt = MutiChartData(
  //     "เค็ม",
  //     saltalertnomal.sum.toDouble(),
  //     saltalertmediam.sum.toDouble(),
  //     saltalertalert.sum.toDouble(),
  //     saltalertangerus.sum.toDouble());
  // MutiChartData keepsweet = MutiChartData(
  //     "หวาน",
  //     sweetalertnomal.sum.toDouble(),
  //     sweetalertmediam.sum.toDouble(),
  //     sweetalertalert.sum.toDouble(),
  //     sweetalertdangerus.sum.toDouble());
  _returnList.add(nomal);
  _returnList.add(mediam);
  _returnList.add(alert);
  _returnList.add(dangerus);

  // _returnList.forEach((e) {});

  return _returnList;
}

DateTime getMinDate(List<AlertModels> snap) {
  List<String> getDate = List();
  snap.forEach((element) {
    // print(element.get("date"));
    getDate.add(element.getByName("date"));
  });
  String a = getDate.min;
  var b = a.substring(0, 5) + "0" + a.substring(5) + "-01";
  print(b);
  // print(getDate.min+"-1");
  // getDate.sort();
  return DateTime.parse(b);
}

DateTime getMaxDate(List<AlertModels> snap) {
  List<String> getDate = List();
  snap.forEach((element) {
    // print(element.get("date"));
    getDate.add(element.getByName("date"));
  });
  String a = getDate.max;
  var b = a.substring(0, 5) + "0" + a.substring(5) + "-01";
  print(b);
  // print(getDate.max+"-1");
  // getDate.sort();
  return DateTime.parse(b);
}

DateTime getMinDateMood(List<AlertMoodModels> snap) {
  List<String> getDate = List();
  snap.forEach((element) {
    // print(element.get("date"));
    getDate.add(element.getByName("date"));
  });

  return DateTime.parse(getDate.min);
}

DateTime getMaxDateMood(List<AlertMoodModels> snap) {
  List<String> getDate = List();
  snap.forEach((element) {
    // print(element.get("date"));
    getDate.add(element.getByName("date"));
  });

  return DateTime.parse(getDate.max);
}

DateTime getMinDateStep(List<String> snap) {
  // List<String> getDate = List();
  // snap.forEach((element) {
  //   // print(element.get("date"));
  //   getDate.add(element.getByName("date"));
  // });

  return DateTime.parse(snap.min);
}
