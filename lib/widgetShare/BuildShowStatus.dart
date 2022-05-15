import 'package:appilcation_for_ncds/models/AlertModels.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:date_time/date_time.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../function/DisplayTime.dart';
import '../function/GetDataChart.dart';
import '../mobilecode/function/datethai.dart';

class BuildShowStatus extends StatefulWidget {
  int fatalert;
  int saltalert;
  int sweetalert;
  int moodalert;
  String dayFood;
  String dayMood;
  List<DateTime> initMoodDate;
  AsyncSnapshot<QuerySnapshot<Object>> snapshotMood;
  AsyncSnapshot<QuerySnapshot<Object>> snapshotFood;

  BuildShowStatus(
      {Key key,
      @required this.fatalert,
      @required this.saltalert,
      @required this.sweetalert,
      @required moodalert,
      @required dayFood,
      @required this.dayMood,
      @required this.initMoodDate,
      @required this.snapshotMood,
      @required this.snapshotFood})
      : super(key: key);

  @override
  State<BuildShowStatus> createState() => _BuildShowStatusState();
}

class _BuildShowStatusState extends State<BuildShowStatus> {
  @override
  initState() {
    super.initState();
    widget.snapshotFood.data.docs.forEach((e) {
      getMouth.add(e.get("Date"));
    });
    getFatalert = widget.fatalert;
    getSaltalert = widget.saltalert;
    getSweetalert = widget.sweetalert;
    dateFood = getMothFormFirebase(getMouth.last).toString();
    // print(getMouth.toList());
  }

  String selectDateFood;
  List<String> getMouth = List();
  String dateMood = DateTime.now().toString();
  int moodStatus;
  int getFatalert;
  int getSaltalert;
  int getSweetalert;
  String dateFood;
  TextEditingController dateSelect = TextEditingController();
  TextEditingController dateSelectFood = TextEditingController();
  QueryDocumentSnapshot<Object> selectDataFood;

  Widget build(BuildContext context) {
    return AlertDialog(
      // title: Text("สถานะ"),
      content: SizedBox(
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      "พฤติกรรมการบริโภค",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text("(ในเดือน ${DateMouthAndYearThai(dateFood)})",
                        style: TextStyle(fontSize: 14, color: Colors.black38)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: dateSelectFood,
                          readOnly: true,
                          onTap: () {
                            showMonthPicker(
                              context: context,
                              firstDate: getMinDateFood(getMouth),
                              lastDate: getMaxDateFood(getMouth),
                              initialDate: DateTime.now(),
                              // selectDateFood.isEmpty
                              //     ? DateTime.now()
                              //     : selectDateFood,
                              locale: Locale("en"),
                            ).then((value) {
                              if (value != null) {
                                setState(() {
                                  selectDataFood = getDataFormDateFood(
                                      value, widget.snapshotFood);
                                  getFatalert = selectDataFood.get("fatalert");
                                  getSaltalert =
                                      selectDataFood.get("saltalert");
                                  getSweetalert =
                                      selectDataFood.get("sweetalert");
                                  dateSelectFood.text =
                                      DateMouthAndYearThai(value.toString());
                                });
                              } else {
                                setState(() {
                                  getFatalert = widget.fatalert;
                                  getSaltalert = widget.saltalert;
                                  getSweetalert = widget.sweetalert;
                                  dateFood = getMothFormFirebase(getMouth.last)
                                      .toString();
                                  dateSelectFood.text = "";
                                });
                              }
                            });
                            // showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) =>
                            //         selectIsMoodHaveData(
                            //             context,
                            //             widget.initMoodDate,
                            //             widget.snapshotMood)).then((value) {
                            //   if (value != null) {
                            //     setState(() {
                            //       dateMood = value.get("Date");
                            //       moodStatus = value.get("moodtoday");
                            //       dateSelectFood.text = checkDateMood(dateFood);
                            //     });
                            //   } else {
                            //     setState(() {
                            //       getFatalert = widget.fatalert;
                            //       getSaltalert = widget.saltalert;
                            //       getSweetalert = widget.sweetalert;
                            //     });
                            //   }
                            // });
                          },
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.calendar_month_outlined),
                            labelText: '',
                            enabledBorder: OutlineInputBorder(
                              // borderSide: const BorderSide(width: 3, color: Colors.blue),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // borderSide: const BorderSide(width: 3, color: Colors.red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: statuseat(getSweetalert)[1],
                    size: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "บริโภคหวาน",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      statuseat(getSweetalert)[0],
                      style: TextStyle(fontSize: 14, color: Colors.black38),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: statuseat(getFatalert)[1],
                    size: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "บริโภคมัน",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      statuseat(getFatalert)[0],
                      style: TextStyle(fontSize: 14, color: Colors.black38),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: statuseat(getSaltalert)[1],
                    size: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "บริโภคเค็ม",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      statuseat(getSaltalert)[0],
                      style: TextStyle(fontSize: 14, color: Colors.black38),
                    ),
                  ),
                ],
              ),
              Center(
                child: Column(
                  children: [
                    Text(
                      "อารมณ์",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      // "",
                      checkDateMood(dateMood),
                      // dateMood,
                      style: TextStyle(fontSize: 14, color: Colors.black38),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: dateSelect,
                          readOnly: true,
                          onTap: () async {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    selectIsMoodHaveData(
                                        context,
                                        widget.initMoodDate,
                                        widget.snapshotMood)).then((value) {
                              if (value != null) {
                                setState(() {
                                  dateMood = value.get("Date");
                                  moodStatus = value.get("moodtoday");
                                  dateSelect.text = DateThai(dateMood);

                                  // print(dateMood);
                                  // print(moodStatus);
                                });
                              } else {
                                setState(() {
                                  dateMood = widget.dayMood;

                                  moodStatus = widget.moodalert;
                                  dateSelect.text =
                                      DateThai(DateTime.now().toString());
                                  dateSelect.text = "";
                                });
                              }
                            });
                          },
                          onChanged: (value) => {setState(() {})},
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.calendar_month_outlined),
                            labelText: '',
                            enabledBorder: OutlineInputBorder(
                              // borderSide: const BorderSide(width: 3, color: Colors.blue),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // borderSide: const BorderSide(width: 3, color: Colors.red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: moodstatus(moodStatus, dateMood)[1],
                            size: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "แบบทดสอบอารมณ์",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: Text(
                            moodstatus(moodStatus, dateMood)[0],
                            style:
                                TextStyle(fontSize: 14, color: Colors.black38),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

isAlert(bool isalert) {
  if (isalert) {
    return Colors.red;
  } else {
    return Colors.green;
  }
}

checkDateMood(String dayMood) {
  String dayNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
  // print(DateThai(dayMood));
  if (dayNow == dayMood) {
    return DateThai(dayNow);
  } else if (dayMood == null) {
    return DateThai(dayNow);
  } else {
    return DateThai(dayNow);
  }
}

moodstatus(int val, String date) {
  // String dayNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
  // if (dayNow == date) {
  print(val);
  if (val != null) {
    if (val <= 4) {
      return ["เครียดน้อย", Colors.green];
    } else if (val >= 5 && val <= 7) {
      return ["เครียดปานกลาง", Colors.yellow.shade700];
    } else if (val >= 8 && val <= 9) {
      return ["เครียดมาก", Colors.orange];
    } else if (val >= 10) {
      return ["เครียดมากที่สุด", Colors.red];
    }
  } else if (val == null) {
    return ["ไม่มีข้อมูล", Colors.grey];
  }
  // }
  // return ["ไม่มีข้อมูล", Colors.grey];
}

getDate(String mount) {
  DateTime dateTime = DateTime.parse(mount + "-1");
  print(dateTime);
}
