import 'dart:developer';

import 'package:appilcation_for_ncds/function/DisplayTime.dart';
import 'package:appilcation_for_ncds/models/KeepRecord.dart';
import 'package:appilcation_for_ncds/models/dairymodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';

List getSumAllChoice(List<DairyModel> snap, List<String> choice) {
  List returnList = List();
  List<KeepChoieAndSocre> keepData = List();
  List<KeepChoieAndSocre> keepDataReturn = List<KeepChoieAndSocre>();
  List<double> scoreList = List();
  snap.forEach((elements) {
    choice.forEach((element) {
      // debugger();
      KeepChoieAndSocre _keepsweet = KeepChoieAndSocre(
          element, int.parse(elements.getByName(element)).toDouble());
      keepData.add(_keepsweet);
    });
  });
  choice.forEach((element) {
    Iterable<KeepChoieAndSocre> sumIter =
        keepData.where((e) => e.choice.contains(element));
    sumIter.forEach((eSum) {
      // if (eSum.score > 0) {
      scoreList.add(eSum.score);
      // }
    });
    KeepChoieAndSocre keepsumall = KeepChoieAndSocre(element, (scoreList.sum));
    print("${scoreList.sum} / ${scoreList.length} ${scoreList.toList()}");
    keepDataReturn.add(keepsumall);
  });
  returnList.add(
    keepDataReturn,
  );
  returnList.add(
      scoreList.reduce((curr, next) => curr > next ? curr : next).toDouble());
  print("show snap ${returnList[0]}${returnList[1]}");
  return returnList;
}

List getSumAllChoiceFood(List<DairyModel> snap, List<String> choice) {
  List returnList = List();
  List<KeepChoieAndSocre> keepData = List();
  List<KeepChoieAndSocre> keepDataReturn = List<KeepChoieAndSocre>();
  List<double> scoreList = List();
  snap.forEach(
    (elements) {
      choice.forEach(
        (element) {
          // if(elements.getByName(element) != "null"){
          //   print(1);
          // }
          // else{
          //   print(0);
          // }
          // debugger();
          if (elements.getByName(element) != "null") {
            print((elements.getByName(element)));
            KeepChoieAndSocre _keepsweet = KeepChoieAndSocre(
                element, int.parse(elements.getByName(element)).toDouble());
            keepData.add(_keepsweet);
          } else {
            print((elements.getByName(element)));
            KeepChoieAndSocre _keepsweets = KeepChoieAndSocre(element, 0);
            keepData.add(_keepsweets);
          }
        },
      );
    },
  );
  choice.forEach((element) {
    Iterable<KeepChoieAndSocre> sumIter =
        keepData.where((e) => e.choice.contains(element));
    sumIter.forEach((eSum) {
      scoreList.add(eSum.score);
    });
    KeepChoieAndSocre keepsumall =
        KeepChoieAndSocre(element, scoreList.average);
    keepDataReturn.add(keepsumall);
  });
  returnList.add(
    keepDataReturn,
  );
  returnList.add(
      scoreList.reduce((curr, next) => curr > next ? curr : next).toDouble());
  print("show snap ${returnList[0]}${returnList[1]}");
  return returnList;
}

List<DairyModel> getValueFromDateRang(
    List<DairyModel> snap, List<DateTime> dateRang) {
  List<String> dateTimeStr = List();
  List<Iterable<DairyModel>> getValueFromRangDate = List();
  List<DairyModel> getValueFromRangDates = List();

  List<DairyModel> getAllValue = List();
  List<DairyModel> getHaveValue = List();
  // convet time to string
  // snap.forEach((element) {
  //   DairyModel model = DairyModel.fromMap(element.data());
  //   getAllValue.add(model);
  // });
  print("keepseethis ${snap.toList()}");
  dateRang.forEach((element) {
    dateTimeStr.add(convertDateToString(element.toString()));
  });
  var counter = 0;
  print("date is ${dateTimeStr.length}");
  dateTimeStr.forEach((element) {
    snap.forEach((e) {
      if (element == e.date) {
        print(e.date);
        getValueFromRangDates.add(e);
        counter++;
        print(counter);
      } else {}
    });
    // Iterable<DairyModel> getIter =
    //     snap.where((e) => e.date.contains(element));
    // // getValueFromRangDate.add(getIter.toList());
    // print("{$getIter}");
  });
  print("get inter is ${getValueFromRangDates.toList()}");
  getValueFromRangDates.forEach((element) {
    print("show element${element.date}");
  });
  // getValueFromRangDate.forEach((e) {
  //   e.forEach((element) {
  //     // print(e.toList());
  //     if (element.toString() != "[]") {
  //       print("element to add ${element}}");
  //       getHaveValue.add(element);
  //     } else {
  //       print(null);
  //     }
  //   });
  // });
  // // getHaveValue.forEach((e){
  // //   print(e.fatchoice1);});
  // print(" have valuse${getHaveValue}");
  return getValueFromRangDates;
}

getDateFromDiary(List<DairyModel> snap) {
  List<String> getDate = List();
  snap.forEach((element) {
    print(element.getByName("date"));
    getDate.add(element.getByName("date"));
  });
  // getDate.sort();
  print(getDate.toList());
}

DateTime getMinDateFromDiary(List<DairyModel> snap) {
  List<String> getDate = List();
  snap.forEach((element) {
    // print(element.get("date"));
    getDate.add(element.getByName("date"));
  });
  print(getDate.first);
  // getDate.sort();
  return DateTime.parse(getDate.first);
}

DateTime getMaxDateFromDiary(List<DairyModel> snap) {
  List<String> getDate = List();
  snap.forEach((element) {
    // print(element.get("date"));
    getDate.add(element.getByName("date"));
  });
  print(getDate.last);
  // getDate.sort();
  return DateTime.parse(getDate.last);
}

List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
  List<DateTime> days = [];
  if (startDate == endDate) {
    days.add(startDate);
    return days;
  }
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    days.add(startDate.add(Duration(days: i)));
  }
  return days;
}

Future<QuerySnapshot> getFutureData(String id) async {
  var _returndata = await FirebaseFirestore.instance
      .collection("MobileUser")
      .doc(id)
      .collection("diary")
      .get();
  return _returndata;
}
