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

class adminMain extends StatefulWidget {
  @override
  _adminMainState createState() => _adminMainState();
}

class _adminMainState extends State<adminMain> {
  @override
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
  void initState() {
    getDataChart();
    super.initState();
  }

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
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Evaluate").get();
    QuerySnapshot querySnapshot_topic;
    setState(() {
      scoreMax = (querySnapshot.docs.length * 4) as double;
    });
    print(scoreMax);
    // print("scoreMax: $scoreMax");
    querySnapshot.docs.forEach((element) async {
      querySnapshot_topic = await FirebaseFirestore.instance
          .collection("Evaluate")
          .doc(element.id)
          .collection("topic")
          .orderBy("score", descending: false)
          .get();
      // print(element.id);
      // print(element.data());
      // print("----------------------------------------");
      querySnapshot_topic.docs.forEach((element) {
        ChartData keepData =
            ChartData(element.get("topic"), element.get("score"));
        // print(element.get("topic"));
        // print(element.get("score"));

        listDataChart.add(keepData);

        // inspect(element.data());
        // scoreCount = element.get("score") + scoreCount;
        // print("sum is: {$scoreCount}");
        // snapshot = element.data();
        // print(snapshot);
      });
      print("+++++++++++++++++++++++++++++++++++++++++++");
      print(listDataChart.length);
      print("list is: $listDataChart");
    });
  }
}
