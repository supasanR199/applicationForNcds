import 'dart:html';

import 'package:appilcation_for_ncds/widgetShare/BuildBarChart.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowChart.dart';
import 'package:appilcation_for_ncds/widgetShare/UserLogAdmin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appilcation_for_ncds/function/DisplayTime.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:appilcation_for_ncds/models/ChartData.dart';
import 'package:appilcation_for_ncds/function/GetDataChart.dart';

import 'EvaluateSoftwarePage.dart';
import 'services/shared_preferences_service.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';

class adminMain extends StatefulWidget {
  @override
  _adminMainState createState() => _adminMainState();
}

class _adminMainState extends State<adminMain> {
  @override
  List<String> evaIdList = [
    "Hospital",
    "Medicalpersonnel",
    "Patient",
    "Volunteer"
  ];
  void initState() {
    // getDataChart();
    // getAllSumDataChart().then((value) {
    //   setState(() {
    //     keepAllSSumSocre = value;
    //     print(value);
    //   });
    // });
    // FirebaseFirestore.instance.collection("Evaluate").get().then((value) {
    //   print("show new evaluate${value.docs}");
    //   value.docs.forEach((element) {
    //     print("show element${element.id}");
    //   });
    // });
    // evaIdList.forEach((element) {
    //   FirebaseFirestore.instance
    //       .collection("Evaluate")
    //       .doc(element).col
    //       .get()
    //       .then((value) {
    //       });
    // });

    super.initState();
    _items = _generateItems;
    getEvaluate();
  }

  void getEvaluate() async {
    await FirebaseFirestore.instance
        .collection("Evaluate")
        .doc("Patient")
        .collection("topic")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.data());
      });
    });
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
  List<ChartData> keepAllSSumSocre = List();
  final PrefService _prefService = PrefService();
  List<CollapsibleItem> _items;
  String _headline;
  String searchText = '';
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> documents = [];
  Map<String, String> topic = {
    "Choice1": "แอปพลิเคชันทำงานได้อย่างถูกต้อง",
    "Choice2": "แอปพลิเคชันทำงานได้ง่าย",
    "Choice3": "แอปพลิเคชันมีคำอธิบายที่เหมาะสม",
    "Choice4": "แอปพลิเคชันมีความเหมาะสมในการใช้งาน",
    "Choice5": "ความพึงพอใจต่อระบบภาพรวม"
  };

  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
        text: 'อนุมัติเข้าใช้งาน รพสต.',
        icon: IconData(0xe159, fontFamily: 'MaterialIcons'),
        onPressed: () => setState(() => _headline = 'all'),
        isSelected: true,
      ),
      CollapsibleItem(
        text: 'ประวัติการเข้าใช้งาน',
        icon: Icons.assignment_ind,
        onPressed: () => setState(() => _headline = 'patient'),
      ),
      CollapsibleItem(
        text: 'ประเมินการใช้งาน',
        icon: Icons.stacked_bar_chart_sharp,
        onPressed: () => setState(() => _headline = 'volenter'),
      ),
    ];
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // DefaultTabController(
    //   initialIndex: 0,
    //   length: 3,
    return Container(
      child: Scaffold(
        // backgroundColor: Color.fromRGBO(255, 211, 251, 1),
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          leading: Image.asset("icon/logo.png"),
          centerTitle: false,
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
                            "${userData['Firstname']}  ${userData['Lastname']}",
                            style: TextStyle(color: Colors.black)),
                        actionMenu(userData["role"]),
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
          // bottom: TabBar(
          //   indicatorColor: Color.fromRGBO(255, 211, 251, 1),
          //   labelColor: Colors.black,
          //   tabs: <Widget>[
          //     Tab(
          //       text: 'อนุมัติเข้าใช้งานของบุคคลากร รพสต.',
          //       icon: Icon(Icons.people),
          //     ),
          //     Tab(
          //       text: 'ประวัติการเข้าใช้งาน',
          //       icon: Icon(Icons.beach_access_sharp),
          //     ),
          //     Tab(
          //       text: 'ประเมินการใช้งาน',
          //       icon: Icon(Icons.beach_access_sharp),
          //     ),
          //   ],
          // ),
        ),
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("UserWeb")
                .doc(auth.currentUser.uid)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                userData = snapshot.data.data() as Map<String, dynamic>;
                _userData = userData;
                var userName = _userData["Firstname"] + _userData["Lastname"];
                return CollapsibleSidebar(
                  // isCollapsed: true,
                  selectedIconColor: Colors.white,
                  items: _items,
                  isCollapsed: true,
                  title: userName,
                  showToggleButton: true,
                  // title: 'MENU',
                  // avatarImg:false,
                  avatarImg: AssetImage('assets/icon/logo.png'),
                  // title: 'John Smith',
                  // onTitleTap: () {
                  //   // ScaffoldMessenger.of(context).showSnackBar(
                  //   //     SnackBar(content: Text('Yay! Flutter Collapsible Sidebar!')));
                  // },
                  toggleTitle: 'ปิดแถบเมนู',
                  body: _body(size, context, _headline),
                  backgroundColor: Colors.grey.shade900,
                  selectedTextColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 15,
                  ),
                  titleStyle: TextStyle(
                      fontSize: 20,
                      // fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                  toggleTitleStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

                  sidebarBoxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 20,
                      spreadRadius: 0.01,
                      offset: Offset(3, 3),
                    ),
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
        // TabBarView(
        //   children: [
        //     Center(
        //       child: buildPAcceptPage(context),
        //     ),
        //     Center(
        //       child: buildLogPage(context),
        //     ),
        //     Center(
        //       child: buildBarChart(context),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  Widget _body(Size size, BuildContext context, String selected) {
    if (selected == "all") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blueGrey[50],
        child: Center(child: buildPAcceptPage(context)),
      );
    } else if (selected == "patient") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        // color: Colors.blueGrey[50],
        child: Center(child: buildLogPage(context)),
      );
    } else if (selected == "volenter") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        // color: Colors.blueGrey[50],
        child: Center(child: BuildBarChart()),
      );
    }
    return Container(
      height: double.infinity,
      width: double.infinity,
      // color: Colors.blueGrey[50],
      child: Center(child: buildPAcceptPage(context)),
    );
  }

  Widget buildPAcceptPage(context) {
    return Container(
      child: Center(
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 60),
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
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'ค้นหา',
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
                            documents = snapshot.data.docs;
                            if (searchText.length > 0) {
                              documents = documents.where((element) {
                                return element
                                    .get('Firstname')
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchText.toLowerCase());
                              }).toList();
                            }
                            return ListView.builder(
                                itemCount: documents.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                        "${documents[index]["Firstname"]} ${documents[index]["Lastname"]}"),
                                    // subtitle: Text("${snap["Lastname"]}"),
                                    trailing: Switch(
                                      value: documents[index]["status"],
                                      onChanged: (value) {
                                        docId = (snapshot.data.docs
                                            .map((e) => e.reference)
                                            .toList());
                                        // print(
                                        //     "DocumentReference<Map<String, dynamic>>(UserWeb/" +
                                        //         document.id +
                                        //         ")");
                                        // for find index in DocmentReference.
                                        for (int i = 0; i < docId.length; i++) {
                                          if (docId[i].toString() ==
                                              "DocumentReference<Map<String, dynamic>>(UserWeb/" +
                                                  documents[index].id +
                                                  ")") {
                                            index = i;
                                          }
                                        }
                                        FirebaseFirestore.instance
                                            .runTransaction(
                                                (transaction) async {
                                          DocumentSnapshot freshSnap =
                                              await transaction
                                                  .get(docId[index]);
                                          await transaction.update(
                                              freshSnap.reference,
                                              {"status": value});
                                        });
                                      },
                                      activeTrackColor: Colors.lightGreenAccent,
                                      activeColor: Colors.green,
                                    ),
                                  );
                                });
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
          ),
          //  margin: EdgeInsets.only(top: 100,bottom: 400,),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
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
                          "การเข้าใช้งาน",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("UserLog")
                          .orderBy("timeLogin", descending: true | false)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: UserLog(),
                          );
                        } else {
                          return Center(
                            child: Text("กำลังโหลดข้อมูล.."),
                          );
                          // CircularProgressIndicator();
                        }
                      }),
                ),
              ],
            ),
          ),
          //  margin: EdgeInsets.only(top: 100,bottom: 400,),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
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
                            "ประเมินการใช้งาน",
                            style: TextStyle(fontSize: 40),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  ShowChart(
                    dataSource: keepAllSSumSocre,
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

  // Future getDataChart() async {
  //   await FirebaseFirestore.instance.collection("Evaluate").get().then(
  //     (value) async {
  //       value.docs.forEach(
  //         (element) async {
  //           setState(() {
  //             scoreMax = (element.data().length * 4) as double;
  //           });
  //           await FirebaseFirestore.instance
  //               .collection("Evaluate")
  //               .doc(element.id)
  //               .collection("topic")
  //               .orderBy("score", descending: false)
  //               .get()
  //               .then(
  //             (value) {
  //               value.docs.forEach(
  //                 (element) {
  //                   // print(element.data());
  //                   ChartData keepData =
  //                       ChartData(element.get("topic"), element.get("score"));
  //                   // setState(() {
  //                   elmentList.add(element.data());
  //                   listDataChart.add(keepData);
  //                   // });
  //                 },
  //               );
  //             },
  //           );
  //         },
  //       );
  //     },
  //   );
  //   // print(listDataChart);
  //   // print(elmentList);
  //   // setState(() {
  //   //   calScoreFromList(listDataChart, elmentList);
  //   // });
  // }

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

  Widget actionMenu(String role) {
    return PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: Colors.black,
        ),
        // child: Text(userData["name"]),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.add_chart_outlined),
                  title: Text('ประเมินการใช้งาน'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EvaulatePage(
                          role: role,
                        ),
                      ),
                    );
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('ออกจากระบบ'),
                    onTap: () async {
                      auth.signOut().then((value) {
                        _prefService.removeCache("email");
                        _prefService.removeCache("password");
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              alertMessageOnlyOk(context, "ออกจากระบบแล้ว"),
                        ).then((value) {
                          if (value == "CONFIRM") {
                            Navigator.pushNamed(context, "/");
                          }
                        });
                      });
                    }),
              ),
            ]);
  }
}
