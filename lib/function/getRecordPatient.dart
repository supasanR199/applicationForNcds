import 'dart:developer';
import 'dart:math';

import 'package:appilcation_for_ncds/function/DisplayTime.dart';
import 'package:appilcation_for_ncds/models/KeepRecord.dart';
import 'package:appilcation_for_ncds/models/dairymodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

List<KeepChoieAndSocre> getStepListSelectDate(
    List<KeepChoieAndSocre> snap, List<DateTime> dateList) {
  DateFormat myDateFormat = DateFormat("yyyy-MM-dd");
  List<String> dateStr = List();
  List<KeepChoieAndSocre> returnList = List();
  dateList.forEach((element) {
    dateStr.add(myDateFormat.format(element));
  });
  // print(snap.toList());
  // print(snap.length);
  snap.forEach((eSnap) {
    print("show choice ${eSnap.choice}");
    dateStr.forEach((eDate) {
      // print("select date rang $eDate");
      if (eSnap.choice == eDate) {
        print(1);
        returnList.add(eSnap);
      }
    });
  });
  // print("show counter list $returnList");
  return returnList;
}

List getSumAllChoice(List<DairyModel> snap, List<String> choice) {
  List returnList = List();
  List<KeepChoieAndSocre> keepData = List();
  List<KeepChoieAndSocre> keepDataReturn = List<KeepChoieAndSocre>();
  // List<double> scoreList = List();
  List<double> scoreList = List();
  List<double> testSumList = List();
  Iterable<KeepChoieAndSocre> sumIters;
  List<Iterable<KeepChoieAndSocre>> getNewIters = List();
  List<double> keepScoreAll = List();

  // print("show the fuck this ${testSumList.sum}  ${testSumList.toList()}");

  snap.forEach((elements) {
    choice.forEach((element) {
      // debugger();
      KeepChoieAndSocre _keepsweet = KeepChoieAndSocre(
          element, int.parse(elements.getByName(element)).toDouble());
      // print("show befor add ${_keepsweet.choice} ${_keepsweet.score}");

      keepData.add(_keepsweet);
    });
  });

  choice.forEach((element) {
    sumIters = keepData.where((e) => e.choice.contains(element));
    getNewIters.add(sumIters);
  });
  getNewIters.forEach((element) {
    String keepStrChoice;
    List<double> scoreLists = List();
    element.forEach(
      (e) {
        scoreLists.add(e.score);
        keepStrChoice = e.choice;
        // print(e.choice);
      },
    );
    keepScoreAll.add(scoreLists.sum);
    KeepChoieAndSocre keepsumall =
        KeepChoieAndSocre(keepStrChoice, scoreLists.sum);

    keepDataReturn.add(keepsumall);
  });
  print("sum iter all element ${getNewIters.length} ${sumIters.toList()}}");

  returnList.add(
    keepDataReturn,
  );

  returnList.add(keepScoreAll
      .reduce((curr, next) => curr > next ? curr : next)
      .toDouble());
  // print("show snap ${returnList[0]}${returnList[1]}");

  return returnList;
}

// List getSumAllChoice(List<DairyModel> snap, List<String> choice) {
//   List returnList = List();
//   List<KeepChoieAndSocre> keepData = List();
//   List<KeepChoieAndSocre> keepDataReturn = List<KeepChoieAndSocre>();
//   List<double> scoreList = List();
//   snap.forEach((elements) {
//     choice.forEach((element) {
//       // debugger();
//       KeepChoieAndSocre _keepsweet = KeepChoieAndSocre(
//           element, int.parse(elements.getByName(element)).toDouble());
//       keepData.add(_keepsweet);
//     });
//   });
//   choice.forEach((element) {
//     Iterable<KeepChoieAndSocre> sumIter =
//         keepData.where((e) => e.choice.contains(element));
//     sumIter.forEach((eSum) {
//       // if (eSum.score > 0) {
//       scoreList.add(eSum.score);
//       // }
//     });
//     // print("show sum all keep sweet food. ${element}: ${scoreList.sum}");
//     KeepChoieAndSocre keepsumall = KeepChoieAndSocre(element, (scoreList.sum));
//     // print("${scoreList.sum} / ${scoreList.length} ${scoreList.toList()}");
//     keepDataReturn.add(keepsumall);
//   });
//   returnList.add(
//     keepDataReturn,
//   );
//   returnList.add(
//       scoreList.reduce((curr, next) => curr > next ? curr : next).toDouble());
//   // print("show snap ${returnList[0]}${returnList[1]}");
//   // keepDataReturn.forEach((e) {
//   //   print("show sum all sweet food. ${e.choice}: ${e.score}");
//   // });
//   return returnList;
// }

List getSumAllChoiceMood(List<DairyModel> snap, List<String> choice) {
  List returnList = List();
  List<KeepChoieAndSocre> keepData = List();
  List<KeepChoieAndSocre> keepDataReturn = List<KeepChoieAndSocre>();
  List<double> scoreList = List();
  Iterable<KeepChoieAndSocre> sumIters;
  List<Iterable<KeepChoieAndSocre>> getNewIters = List();
  List<double> keepScoreAll = List();
  snap.forEach(
    (elements) {
      choice.forEach(
        (element) {
          if (elements.getByName(element) != "null") {
            KeepChoieAndSocre _keepsweet = KeepChoieAndSocre(
                element, int.parse(elements.getByName(element)).toDouble());
            keepData.add(_keepsweet);
          } else {
            KeepChoieAndSocre _keepsweets = KeepChoieAndSocre(element, 0);
            keepData.add(_keepsweets);
          }
        },
      );
    },
  );
  choice.forEach((element) {
    sumIters = keepData.where((e) => e.choice.contains(element));
    getNewIters.add(sumIters);
  });
  getNewIters.forEach((element) {
    String keepStrChoice;
    List<double> scoreLists = List();
    element.forEach(
      (e) {
        scoreLists.add(e.score);
        keepStrChoice = e.choice;
        // print(e.choice);
      },
    );
    keepScoreAll.add(scoreLists.sum);
    KeepChoieAndSocre keepsumall =
        KeepChoieAndSocre(keepStrChoice, scoreLists.sum);

    keepDataReturn.add(keepsumall);
  });
  returnList.add(
    keepDataReturn,
  );
  returnList.add(
      keepScoreAll.reduce((curr, next) => curr > next ? curr : next).toDouble());

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
  // print("keepseethis ${snap.toList()}");
  dateRang.forEach((element) {
    dateTimeStr.add(convertDateToString(element.toString()));
  });
  var counter = 0;
  // print("date is ${dateTimeStr.length}");
  dateTimeStr.forEach((element) {
    snap.forEach((e) {
      if (element == e.date) {
        // print(e.date);
        getValueFromRangDates.add(e);
        counter++;
        // print(counter);
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

List<KeepChoieAndSocre> getStepFromDate(
    List<KeepChoieAndSocre> getAll, String select) {
  List<KeepChoieAndSocre> _listReturn = List();
  Iterable<KeepChoieAndSocre> getItemFormDate;
  // debugger();
  getAll.forEach((element) {
    getItemFormDate = getAll.where((e) => e.choice.contains(select));
  });
  // print(getItemFormDate.toList());
  if (getItemFormDate.isEmpty) {
    KeepChoieAndSocre zero = KeepChoieAndSocre(select, 0);
    _listReturn.add(zero);
  } else {
    getItemFormDate.forEach((element) {
      _listReturn.add(element);
    });
  }

  return _listReturn;
}
