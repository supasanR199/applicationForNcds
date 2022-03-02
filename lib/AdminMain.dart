import 'dart:developer';
import 'dart:html';

import 'package:appilcation_for_ncds/widgetShare/ShowChart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appilcation_for_ncds/function/DisplayTime.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:appilcation_for_ncds/models/ChartData.dart';
import 'package:appilcation_for_ncds/function/GetDataChart.dart';

class adminMain extends StatefulWidget {
  @override
  _adminMainState createState() => _adminMainState();
}

class _adminMainState extends State<adminMain> {
  @override
  void initState() {
    getDataChart();
    getAllSumDataChart();
    super.initState();
  }

  var _docRef = FirebaseFirestore.instance
      .collection('UserWeb')
      .where("role", isEqualTo: "hospital");
  var _docRefMobile = FirebaseFirestore.instance.collection("MobileUser");
  var docId;
  int index;
  Map<String, dynamic> userData;
  final auth = FirebaseAuth.instance;
  var _userData;
  var _value = 'บุคลากรแพทย์';
  List<ChartData> listDataChart = List<ChartData>();
  double scoreCount;
  double scoreMax;
  List elmentList = List();
  List<Future<List>> keepDataChart = List();
  Map<String, double> keepDataTest = Map();

  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("UserWeb")
                      .doc(auth.currentUser.uid)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      userData = snapshot.data.data() as Map<String, dynamic>;
                      _userData = userData;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "${userData['Firstname']}  ${userData['Lastname']}"),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("กำลังโหลด"),
                        ],
                      );
                    }
                  }),
              // actionMenu(),
            ],
            backgroundColor: Colors.white,
            bottom: TabBar(
              indicatorColor: Color.fromRGBO(255, 211, 251, 1),
              tabs: <Widget>[
                Tab(
                  text: 'อนุมัติเข้าใช้งานของบุคคลากร รพสต.',
                  icon: Icon(Icons.people),
                ),
                Tab(
                  text: 'ประวัติการเข้าใช้งาน',
                  icon: Icon(Icons.beach_access_sharp),
                ),
                Tab(
                  text: 'ประวัติการเข้าใช้งาน',
                  icon: Icon(Icons.beach_access_sharp),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: buildPAcceptPage(context),
              ),
              Center(
                child: buildLogPage(context),
              ),
              Center(
                child: buildBarChart(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPAcceptPage(context) {
    return Container(
      child: Center(
        child: Card(
          child: SizedBox(
            height: 700,
            width: 1000,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "อนุมัติเข้าใข้งาน",
                          style: TextStyle(fontSize: 40),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "บุคคลากร รพสต.",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: _docRef.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return ListView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> snap =
                                  document.data() as Map<String, dynamic>;
                              return ListTile(
                                title: Text("${snap["Firstname"]}"),
                                subtitle: Text("${snap["Lastname"]}"),
                                trailing: Switch(
                                  value: snap["status"],
                                  onChanged: (value) {
                                    docId = (snapshot.data.docs
                                        .map((e) => e.reference)
                                        .toList());
                                    print(
                                        "DocumentReference<Map<String, dynamic>>(UserWeb/" +
                                            document.id +
                                            ")");
                                    // for find index in DocmentReference.
                                    for (int i = 0; i < docId.length; i++) {
                                      if (docId[i].toString() ==
                                          "DocumentReference<Map<String, dynamic>>(UserWeb/" +
                                              document.id +
                                              ")") {
                                        index = i;
                                      }
                                    }
                                    FirebaseFirestore.instance
                                        .runTransaction((transaction) async {
                                      DocumentSnapshot freshSnap =
                                          await transaction.get(docId[index]);
                                      await transaction.update(
                                          freshSnap.reference,
                                          {"status": value});
                                    });
                                  },
                                  activeTrackColor: Colors.lightGreenAccent,
                                  activeColor: Colors.green,
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return Center(
                            child: Text("กำลังโหลด"),
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
          //  margin: EdgeInsets.only(top: 100,bottom: 400,),
        ),
      ),
    );
  }

  Widget buildLogPage(context) {
    return Container(
      child: Center(
        child: Card(
          child: SizedBox(
            height: 700,
            width: 1000,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "อนุมัติเข้าใข้งาน",
                          style: TextStyle(fontSize: 40),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "การเข้าใช้งาน",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("UserLog")
                          .orderBy("timeLogin", descending: true | false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: SingleChildScrollView(
                              child: SizedBox(
                                width: double.infinity,
                                child: DataTable(
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: Text(
                                        'ชื่อ',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'อีเมล',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'ตำแหน่ง',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'เวลาเข้าใช้งาน',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    // DataColumn(
                                    //   label: Text(
                                    //     'สถานะ',
                                    //     style: TextStyle(
                                    //         fontStyle: FontStyle.italic),
                                    //   ),
                                    // ),
                                  ],
                                  rows: _buildList(context, snapshot.data.docs),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return LinearProgressIndicator();
                        }
                      }),
                ),
              ],
            ),
          ),
          //  margin: EdgeInsets.only(top: 100,bottom: 400,),
        ),
      ),
    );
  }

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    Map<String, dynamic> snap = data.data() as Map<String, dynamic>;
    // print(data.data());
    // print(data.get("email"));
    return DataRow(
      cells: [
        DataCell(Text(snap["Firstname"])),
        DataCell(Text(snap["email"])),
        DataCell(Text(snap["role"])),
        DataCell(Text(convertDateTimeDisplayAndTime(snap["timeLogin"]))),
        // DataCell(buildButtonDelectRemainder(context, snap["logoutTime"])),
      ],
    );
  }

  Widget buildButtonDelectRemainder(context, Timestamp status) {
    return RaisedButton(
      onPressed: () => null,
      // color: Colors.accents,
      child: Text("ลบ"),
      color: Colors.redAccent,
      padding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
    );
  }

  Widget fliterLog(context) {
    return DropdownButtonFormField<String>(
      value: _value,
      decoration: InputDecoration(
        labelText: 'หน้าที่การใช้งาน',
        icon: Icon(Icons.people),
      ),
      items: <String>['บุคลากรแพทย์', 'รพสต.'].map((String values) {
        return DropdownMenuItem<String>(
          value: values,
          child: Text(values),
        );
      }).toList(),
      onChanged: (newValue) {
        // print(newValue);
        setState(() {
          _value = newValue;
        });
      },
    );
  }

  Widget buildBarChart(context) {
    return Container(
      child: Center(
        child: Card(
          child: SizedBox(
            height: 700,
            width: 1000,
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
                            "อนุมัติเข้าใข้งาน",
                            style: TextStyle(fontSize: 40),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  ShowChart(
                    dataSource: listDataChart,
                    scoreMax: scoreMax,
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

  Future getDataChart() async {
    await FirebaseFirestore.instance.collection("Evaluate").get().then(
      (value) async {
        value.docs.forEach(
          (element) async {
            setState(() {
              scoreMax = (element.data().length * 4) as double;
            });
            await FirebaseFirestore.instance
                .collection("Evaluate")
                .doc(element.id)
                .collection("topic")
                .orderBy("score", descending: false)
                .get()
                .then(
              (value) {
                value.docs.forEach(
                  (element) {
                    // print(element.data());
                    ChartData keepData =
                        ChartData(element.get("topic"), element.get("score"));
                    // setState(() {
                    elmentList.add(element.data());
                    listDataChart.add(keepData);
                    // });
                  },
                );
                // print(listDataChart.toSet().toList());
                // calScoreFromList(listDataChart);
                // countScore(listDataChart);
              },
            );
          },
        );
      },
    );
    // print(listDataChart);
    // print(elmentList);
    // setState(() {
    //   calScoreFromList(listDataChart, elmentList);
    // });
  }

  calScoreFromList(List elmentList) {
    // List test = getDataChart() as List;
    print(elmentList);
    // List listTopic = [];
    // print(listTopic.toSet().toList());
    // print(listTopic.toSet().toList().length);
    // print(calList);
    // elmentList.sort();
    // print(elmentList);
    // calList.forEach((element) {
    //   listTopic.add(element.x);
    // });
    // for (int i = 0; i <= calList.length; i++) {}
    // print(listTopic.toSet().toList());
    // print(listTopic.toSet().toList().length);
    // calList.forEach((element) {});
    print("======================");
    // print(calList);
  }

  getAverateChart() async {
    var getEva = await FirebaseFirestore.instance.collection("Evaluate").get();
    print(getEva.docs);
    getEva.docs.forEach((element) {
      keepDataChart.add(getDocTopic(element.id));
    });
    // keepDataChart.forEach((element) {
    //   element.then((value) {
    //     value.forEach((element) {
    //       print(element);
    //     });
    //   });
    // });
    // print(keepDataChart);
    // keepDataChart.forEach((element) {
    //   print(element);
    // });
  }

  Future<List> getDocTopic(String uid) async {
    var getDoc = await FirebaseFirestore.instance
        .collection("Evaluate")
        .doc(uid)
        .collection("topic")
        .get();
    List _docs = List();
    List _keepElemnt = List();

    getDoc.docs.forEach((element) {
      ChartData keepData =
          ChartData(element.get("topic"), element.get("score"));
      _keepElemnt.add(keepData);
      // keepDataTest.addEntries({element.get("topic"), element.get("score")});
      print(keepDataTest);
    });
    return _keepElemnt;
  }

  Future<List> getEvaluate() async {
    var getEva = await FirebaseFirestore.instance.collection("Evaluate").get();
    return getEva.docs;
  }

  countScore(List<ChartData> listData) {
    List list4 = List();
    List list3 = List();
    List list2 = List();
    List list1 = List();
    List keepScoreList = List();
    // keepScoreList.add({
    //   "score_4": 0,
    // });
    // keepScoreList.add({
    //   "score_3": 0,
    // });
    // keepScoreList.add({
    //   "score_2": 0,
    // });
    // keepScoreList.add({
    //   "score_1": 0,
    // });
    listData.forEach((element) {
      print("element is:");
      print(element.y);
      if (element.y == 4) {
        list4.add(1);
        // var counter = 0;
        // keepScoreList.add({"score_4": counter + 1});
      } else if (element.y == 3) {
        list3.add(1);
        // var counter = 0;
        // keepScoreList.add({"score_3": counter + 1});
      } else if (element.y == 2) {
        list2.add(1);
        // var counter = 0;
        // keepScoreList.add({"score_2": counter + 1});
      } else if (element.y == 1) {
        list1.add(1);
        // var counter = 0;
        // keepScoreList.add({"score_1": counter + 1});
      }
    });
    // print(list4);
    // print(list3);
    // print(list2);
    // print(list1);
    // print(list1.length+list2.length+list3.length+list4.length);
    // print(keepScoreList.length);
    // print(keepScoreList);

    // print(keepScoreList.indexOf());
    // print(keepScoreList[keepScoreList.indexOf("score_4")]);
  }
}
