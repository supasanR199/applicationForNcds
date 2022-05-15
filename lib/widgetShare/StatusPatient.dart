import 'dart:developer';

import 'package:appilcation_for_ncds/mobilecode/function/datethai.dart';
import 'package:appilcation_for_ncds/widgetShare/BuildShowStatus.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatusAlert extends StatefulWidget {
  String id;
  StatusAlert({Key key, @required this.id}) : super(key: key);

  @override
  State<StatusAlert> createState() => _StatusAlertState();
}

class _StatusAlertState extends State<StatusAlert> {
  @override
  Widget build(BuildContext context) {
    int fatalert;
    int saltalert;
    int sweetalert;
    List<DateTime> keepMoodHaveData = List();
    List<String> keepStrMoodDate = List();
    bool alert;

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("MobileUser")
          .doc(widget.id)
          .collection("eatalert")
          .get(),
      builder:
          ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotFood) {
        if (snapshotFood.hasData) {
          if (snapshotFood.data.docs.isEmpty) {
            return Text("");
          }
          return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("MobileUser")
                  .doc(widget.id)
                  .collection("moodalert")
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshotMood) {
                if (snapshotMood.hasData) {
                  snapshotMood.data.docs.forEach((e) {
                    keepStrMoodDate.add(e.get("Date"));
                  });
                  keepStrMoodDate.forEach((e) {
                    keepMoodHaveData.add(DateTime.parse(e));
                  });
                  if (snapshotMood.data.docs.isEmpty) {
                    alert = snapshotFood.data.docs.last.get("alert");
                    return IconButton(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) => StatefulBuilder(
                                  builder: (context, setState) =>
                                      BuildShowStatus(
                                    fatalert: snapshotFood.data.docs.last
                                        .get("fatalert"),
                                    saltalert: snapshotFood.data.docs.last
                                        .get("saltalert"),
                                    sweetalert: snapshotFood.data.docs.last
                                        .get("sweetalert"),
                                    moodalert: null,
                                    dayFood: snapshotFood.data.docs.last.id,
                                    dayMood: null,
                                    initMoodDate: keepMoodHaveData,
                                    snapshotMood: snapshotMood,
                                  ),
                                  // showStaus(
                                  //     snapshotFood.data.docs.last.get("fatalert"),
                                  //     snapshotFood.data.docs.last.get("saltalert"),
                                  //     snapshotFood.data.docs.last.get("sweetalert"),
                                  //     null,
                                  //     snapshotFood.data.docs.last.id,
                                  //     null,
                                  //     context,
                                  //     keepMoodHaveData,
                                  //     snapshotMood)
                                ));
                      },
                      icon: Icon(
                        IconData(0xe04a, fontFamily: 'MaterialIcons'),
                        color: isAlert(
                          alert,
                        ),
                      ),
                    );
                  } else {
                    String dayNow =
                        DateFormat('yyyy-MM-dd').format(DateTime.now());

                    bool moodAlert =
                        snapshotMood.data.docs.last.get("Date") == dayNow
                            ? snapshotMood.data.docs.last.get("alert")
                            : false;
                    alert =
                        snapshotFood.data.docs.last.get("alert") || moodAlert;
                    // print(alert);
                    return IconButton(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) => StatefulBuilder(
                                  builder: (context, setState) =>
                                      BuildShowStatus(
                                    fatalert: snapshotFood.data.docs.last
                                        .get("fatalert"),
                                    saltalert: snapshotFood.data.docs.last
                                        .get("saltalert"),
                                    sweetalert: snapshotFood.data.docs.last
                                        .get("sweetalert"),
                                    moodalert: snapshotMood.data.docs.last
                                        .get("moodtoday"),
                                    dayFood: snapshotFood.data.docs.last.id,
                                    dayMood: snapshotMood.data.docs.last.id,
                                    initMoodDate: keepMoodHaveData,
                                    snapshotMood: snapshotMood,
                                  ),
                                )

                            // showStaus(
                            //     snapshotFood.data.docs.last.get("fatalert"),
                            //     snapshotFood.data.docs.last.get("saltalert"),
                            //     snapshotFood.data.docs.last.get("sweetalert"),
                            //     snapshotMood.data.docs.last.get("moodtoday"),
                            //     snapshotFood.data.docs.last.id,
                            //     snapshotMood.data.docs.last.id,
                            //     context,
                            //     keepMoodHaveData,
                            //     snapshotMood),
                            );
                      },
                      icon: Icon(
                        IconData(0xe04a, fontFamily: 'MaterialIcons'),
                        color: isAlert(
                          alert,
                        ),
                      ),
                    );
                  }
                } else {
                  return Text("กำลังโหลด");
                }
              });
        }
        return Text("กำลังโหลด");
      }),
    );
  }

  Widget showStaus(
      int fatalert,
      int saltalert,
      int sweetalert,
      int moodalert,
      String dayFood,
      String dayMood,
      context,
      List<DateTime> initMoodDate,
      AsyncSnapshot<QuerySnapshot<Object>> snapshotMood) {
    // print("--------------------------------------------------------");

    // print("show data ${fatalert}");
    // print("show data ${saltalert}");
    // print("show data ${sweetalert}");
    // print("show data ${moodalert}");
    // print("show data ${dayFood}");
    // print("show data ${dayMood}");
    String dateMood;
    int moodStatus;
    TextEditingController dateSelect = TextEditingController();

    // debugger();
    // print(getDate(dayFood));
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
                    Text("(ในเดือน $dayFood)",
                        style: TextStyle(fontSize: 14, color: Colors.black38)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: dateSelect,
                          readOnly: true,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    selectIsMoodHaveData(context, initMoodDate,
                                        snapshotMood)).then((value) {
                              if (value != null) {
                                // setState(() {
                                dateMood = value.get("Date");
                                moodStatus = value.get("moodtoday");
                                dateSelect.text = checkDateMood(dateMood);

                                print(dateMood);
                                print(moodStatus);
                                // });
                              }
                            });
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
                    color: statuseat(sweetalert)[1],
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
                      statuseat(sweetalert)[0],
                      style: TextStyle(fontSize: 14, color: Colors.black38),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: statuseat(fatalert)[1],
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
                      statuseat(fatalert)[0],
                      style: TextStyle(fontSize: 14, color: Colors.black38),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: statuseat(saltalert)[1],
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
                      statuseat(saltalert)[0],
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
                      style: TextStyle(fontSize: 14, color: Colors.black38),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: dateSelect,
                          readOnly: true,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    selectIsMoodHaveData(context, initMoodDate,
                                        snapshotMood)).then((value) {
                              if (value != null) {
                                setState(() {
                                  dateMood = value.get("Date");
                                  moodStatus = value.get("moodtoday");
                                  dateSelect.text = checkDateMood(dateMood);

                                  print(dateMood);
                                  print(moodStatus);
                                });
                              }
                            });
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
    String dayNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (dayNow == date) {
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
      } else {
        return ["ไม่มีข้อมูล", Colors.grey];
      }
    }
    return ["ไม่มีข้อมูล", Colors.grey];
  }

  getDate(String mount) {
    DateTime dateTime = DateTime.parse(mount + "-1");
    print(dateTime);
  }
}
