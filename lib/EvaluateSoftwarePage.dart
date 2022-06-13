import 'package:appilcation_for_ncds/widgetShare/EvaluateChoice.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:appilcation_for_ncds/models/EvaluateModels.dart';
import 'package:radio_button_form_field/radio_button_form_field.dart';

class EvaulatePage extends StatefulWidget {
  String role;
  String id;
  EvaulatePage({Key key, @required this.role, @required this.id})
      : super(key: key);

  @override
  _EvaulatePageState createState() => _EvaulatePageState();
}

class _EvaulatePageState extends State<EvaulatePage> {
  final _addForm = GlobalKey<FormState>();
  List<EvaluateTopicModels> _evaList = List<EvaluateTopicModels>();
  EvaluateTopicModels evaTopic_0 = EvaluateTopicModels();
  EvaluateTopicModels evaTopic_1 = EvaluateTopicModels();
  EvaluateTopicModels evaTopic_2 = EvaluateTopicModels();
  EvaluateTopicModels evaTopic_3 = EvaluateTopicModels();
  EvaluateTopicModels evaTopic_4 = EvaluateTopicModels();
  EvaluateTopicModels evaTopic_5 = EvaluateTopicModels();
  EvaluateTopicModels evaTopic_6 = EvaluateTopicModels();
  EvaluateTopicModels evaTopic_7 = EvaluateTopicModels();
  EvaluateTopicModels evaTopic_8 = EvaluateTopicModels();
  EvaluateTopicModels evaComment = EvaluateTopicModels();
  TextEditingController evaCommentCon = TextEditingController();
  String evaCommentStr;

  List topic = [
    "ฟังก์ชันการทำงานมีความเหมาะสมกับกับการติดตามผู้ป่วย",
    "ฟังก์ชันการทำงานของแอปพลิเคชันช่วยในการประเมินอาการของผู้ป่วยได้ง่ายขึ้น",
    "ฟังก์ชันการทำงานของแอปพลิเคชันสามารถแนะนำผู้ป่วยในการใช้ชีวิตประจำวันได้ดี",
    "หน้าจอออกแบบสวยงาม ดึงดูดการใช้งานได้ดี",
    "แอปพลิเคชันมีความง่ายต่อการบันทึกผลการตรวจของผู้ป่วย",
    "ข้อมูลที่ได้รับจากการบันทึกของผู้ป่วยมีประโยชน์ต่อการรักษา",
    "แอปพลิเคชันช่วยลดขั้นตอนการทำงานได้",
    "การโต้ตอบระหว่างผู้ใช้งานกับแอปพลิเคชัน มีความสะดวกและเข้าใจง่าย",
    "แอปพลิเคชันช่วยลดขั้นตอนการทำงานได้เป็นอย่างดี"
  ];
  List topicVersion2 = [
    "แสดงข้อมูลได้ถูกต้องครบถ้วน",
    "ระบบใช้งานง่ายไม่ซับซ้อน",
    "ความเหมาะสมในการใช้ ข้อความ รูปภาพ และสัญลักษณ์ ในการสื่อความหมาย",
    "ความเสถียรในการใช้งานระบบ",
    "ความพึงพอใจในการใช้งานระบบโดยรวม"
  ];
  final List<Map> data = [
    {'value': 5, 'display': 'มากที่สุด'},
    {'value': 4, 'display': 'มาก'},
    {'value': 3, 'display': 'ปานกลาง'},
    {'value': 2, 'display': 'น้อย'},
    {'value': 1, 'display': 'น้อยมาก'},
  ];
  void initState() {
    super.initState();
    if (widget.role == "hospital") {
      roleH = "Hospital";
    } else if (widget.role == "medicalpersonnel") {
      roleH = "Medicalpersonnel";
    }
  }

  String roleH;
  @override
  Widget build(BuildContext context) {
    List<EvaluateTopicModels> _evaTopicMain = List();
    return Container(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          foregroundColor: Colors.blueAccent,
          centerTitle: false,
          title: Text(
            "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Card(
            child: SizedBox(
              height: 700,
              width: 1000,
              child: Form(
                key: _addForm,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Text(
                              'ประเมินการใช้งาน',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        EvaluateChoice(
                          subject: "1.แสดงข้อมูลได้ถูกต้องครบถ้วน",
                        ),
                        RadioButtonFormField(
                          // toggleable: true,
                          padding: EdgeInsets.all(8),
                          context: context,
                          value: 'value',
                          display: 'display',
                          data: data,
                          onSaved: (newValue) {
                            // print(newValue);
                            evaTopic_0.score = newValue;
                            evaTopic_0.topic =
                                "ฟังก์ชันการทำงานมีความเหมาะสมกับกับการติดตามผู้ป่วย";
                            _evaList.add(evaTopic_0);
                          },
                          validator: (value) {
                            if (value == null) {
                              return "โปรดให้คะแนนการประเมิน";
                            } else {
                              return null;
                            }
                          },
                        ),
                        EvaluateChoice(
                          subject: "2.ระบบใช้งานง่ายไม่ซับซ้อน",
                        ),
                        RadioButtonFormField(
                          // toggleable: true,
                          padding: EdgeInsets.all(8),
                          context: context,
                          value: 'value',
                          display: 'display',
                          data: data,
                          onSaved: (newValue) {
                            // print(newValue);
                            evaTopic_1.score = newValue;
                            evaTopic_1.topic =
                                "ฟังก์ชันการทำงานของแอปพลิเคชันช่วยในการประเมินอาการของผู้ป่วยได้ง่ายขึ้น";
                            _evaList.add(evaTopic_1);
                          },
                          validator: (value) {
                            if (value == null) {
                              return "โปรดให้คะแนนการประเมิน";
                            } else {
                              return null;
                            }
                          },
                        ),
                        EvaluateChoice(
                          subject: "3.ความเหมาะสมในการใช้ ข้อความ รูปภาพ และสัญลักษณ์ ในการสื่อความหมาย",
                        ),
                        RadioButtonFormField(
                          // toggleable: true,
                          padding: EdgeInsets.all(8),
                          context: context,
                          value: 'value',
                          display: 'display',
                          data: data,
                          onSaved: (newValue) {
                            evaTopic_2.score = newValue;
                            evaTopic_2.topic =
                                "ฟังก์ชันการทำงานของแอปพลิเคชันสามารถแนะนำผู้ป่วยในการใช้ชีวิตประจำวันได้ดี";
                            _evaList.add(evaTopic_2);
                          },
                          validator: (value) {
                            if (value == null) {
                              return "โปรดให้คะแนนการประเมิน";
                            } else {
                              return null;
                            }
                          },
                        ),
                        EvaluateChoice(
                          subject: "4.ความเสถียรในการใช้งานระบบ",
                        ),
                        RadioButtonFormField(
                          // toggleable: true,
                          padding: EdgeInsets.all(8),
                          context: context,
                          value: 'value',
                          display: 'display',
                          data: data,
                          onSaved: (newValue) {
                            // print(newValue);
                            evaTopic_3.score = newValue;
                            evaTopic_3.topic =
                                "หน้าจอออกแบบสวยงาม ดึงดูดการใช้งานได้ดี";
                            _evaList.add(evaTopic_3);
                          },
                          validator: (value) {
                            if (value == null) {
                              return "โปรดให้คะแนนการประเมิน";
                            } else {
                              return null;
                            }
                          },
                        ),
                        EvaluateChoice(subject: "5.ความพึงพอใจในการใช้งานระบบโดยรวม"),
                        RadioButtonFormField(
                          // toggleable: true,
                          padding: EdgeInsets.all(8),
                          context: context,
                          value: 'value',
                          display: 'display',
                          data: data,
                          onSaved: (newValue) {
                            // print(newValue);
                            evaTopic_4.score = newValue;
                            evaTopic_4.topic =
                                "แอปพลิเคชันมีความง่ายต่อการบันทึกผลการตรวจของผู้ป่วย";
                            _evaList.add(evaTopic_4);
                          },
                          validator: (value) {
                            if (value == null) {
                              return "โปรดให้คะแนนการประเมิน";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "ข้อเสนอแนะเพิ่มเติม",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: evaCommentCon,
                            onSaved: (newValue) {
                              evaCommentStr = newValue;
                            },
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            maxLines: 10,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              // labelText: 'บทความ',
                            ),
                          ),
                        ),
                        // EvaluateChoice(
                        //   subject:
                        //       "6.ข้อมูลที่ได้รับจากการบันทึกของผู้ป่วยมีประโยชน์ต่อการรักษา",
                        // ),
                        // RadioButtonFormField(
                        //   // toggleable: true,
                        //   padding: EdgeInsets.all(8),
                        //   context: context,
                        //   value: 'value',
                        //   display: 'display',
                        //   data: data,
                        //   onSaved: (newValue) {
                        //     // print(newValue);
                        //     evaTopic_5.score = newValue;
                        //     evaTopic_5.topic =
                        //         "ข้อมูลที่ได้รับจากการบันทึกของผู้ป่วยมีประโยชน์ต่อการรักษา";
                        //     _evaList.add(evaTopic_5);
                        //   },
                        //   validator: (value) {
                        //     if (value == null) {
                        //       return "โปรดให้คะแนนการประเมิน";
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        // ),
                        // EvaluateChoice(
                        //   subject: "7.แอปพลิเคชันช่วยลดขั้นตอนการทำงานได้",
                        // ),
                        // RadioButtonFormField(
                        //   // toggleable: true,
                        //   padding: EdgeInsets.all(8),
                        //   context: context,
                        //   value: 'value',
                        //   display: 'display',
                        //   data: data,
                        //   onSaved: (newValue) {
                        //     // print(newValue);
                        //     evaTopic_6.score = newValue;
                        //     evaTopic_6.topic =
                        //         "แอปพลิเคชันช่วยลดขั้นตอนการทำงานได้";
                        //     _evaList.add(evaTopic_6);
                        //   },
                        //   validator: (value) {
                        //     if (value == null) {
                        //       return "โปรดให้คะแนนการประเมิน";
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        // ),
                        // EvaluateChoice(
                        //   subject:
                        //       "8.การโต้ตอบระหว่างผู้ใช้งานกับแอปพลิเคชัน มีความสะดวกและเข้าใจง่าย",
                        // ),
                        // RadioButtonFormField(
                        //   // toggleable: true,
                        //   padding: EdgeInsets.all(8),
                        //   context: context,
                        //   value: 'value',
                        //   display: 'display',
                        //   data: data,
                        //   onSaved: (newValue) {
                        //     // print(newValue);
                        //     evaTopic_7.score = newValue;
                        //     evaTopic_7.topic =
                        //         "การโต้ตอบระหว่างผู้ใช้งานกับแอปพลิเคชัน มีความสะดวกและเข้าใจง่าย";
                        //     _evaList.add(evaTopic_7);
                        //   },
                        //   validator: (value) {
                        //     if (value == null) {
                        //       return "โปรดให้คะแนนการประเมิน";
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        // ),
                        // EvaluateChoice(
                        //   subject:
                        //       "9.แอปพลิเคชันช่วยลดขั้นตอนการทำงานได้เป็นอย่างดี",
                        // ),
                        // RadioButtonFormField(
                        //   // toggleable: true,
                        //   padding: EdgeInsets.all(8),
                        //   context: context,
                        //   value: 'value',
                        //   display: 'display',
                        //   data: data,
                        //   onSaved: (newValue) {
                        //     print(newValue);
                        //     evaTopic_8.score = newValue;
                        //     evaTopic_8.topic =
                        //         "แอปพลิเคชันช่วยลดขั้นตอนการทำงานได้เป็นอย่างดี";
                        //     _evaList.add(evaTopic_8);
                        //   },
                        //   validator: (value) {
                        //     if (value == null) {
                        //       return "โปรดให้คะแนนการประเมิน";
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        // ),
                        // Expanded(
                        //   child: Form(
                        //     key: _addForm,
                        //     child: ListView.builder(
                        //       itemCount: topic.length,
                        //       shrinkWrap: true,
                        //       itemBuilder: (context, index) {
                        //         print(index);
                        //         return Column(
                        //           children: [
                        //             EvaluateChoiceLess(
                        //               subject: "${index + 1}" + topic[index],
                        //             ),
                        //             RadioButtonFormField(
                        //               // toggleable: true,
                        //               padding: EdgeInsets.all(8),
                        //               context: context,
                        //               value: 'value',
                        //               display: 'display',
                        //               data: data,
                        //               onSaved: (newValue) {
                        //                 print(newValue);
                        //                 // widget.onChoiceChang(newValue);
                        //               },
                        //               validator: (value) {
                        //                 if (value == null) {
                        //                   return "โปรดให้คะแนนการประเมิน";
                        //                 } else {
                        //                   return null;
                        //                 }
                        //               },
                        //             ),
                        //           ],
                        //         );
                        //       },
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            width: 100,
                            height: 40,
                            child: RaisedButton(
                              child: Text(
                                'บันทึก',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              hoverColor: Colors.grey.shade200,
                              color: Colors.green,
                              onPressed: () {
                                if (_addForm.currentState.validate()) {
                                  _addForm.currentState.save();
                                  if (evaCommentStr.isNotEmpty) {
                                    FirebaseFirestore.instance
                                        .collection("Evaluate")
                                        .doc(roleH)
                                        .collection("comment")
                                        .doc(widget.id)
                                        .set({
                                      "comment": evaCommentStr,
                                      "date": DateTime.now(),
                                    });
                                  }

                                  FirebaseFirestore.instance
                                      .collection("Evaluate")
                                      .doc(roleH)
                                      .collection("topic")
                                      .doc(widget.id)
                                      .set({
                                    "Choice1": _evaList[0].score,
                                    "Choice2": _evaList[1].score,
                                    "Choice3": _evaList[2].score,
                                    "Choice4": _evaList[3].score,
                                    "Choice5": _evaList[4].score,
                                    "date": DateTime.now(),
                                  }).whenComplete(() {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            alertMessageOnlyOk(
                                                context, "ประเมินสำเร็จ"));
                                  });
                                  Navigator.pop(context);

                                  // FirebaseFirestore.instance
                                  //     .collection("Evaluate")
                                  //     .add({
                                  //   "createAt": DateTime.now(),
                                  //   "role": widget.role
                                  // }).then((value) {
                                  //   _evaList.forEach((element) {
                                  //     FirebaseFirestore.instance
                                  //         .collection("Evaluate")
                                  //         .doc(value.id)
                                  //         .collection("topic")
                                  //         .add({
                                  //       "topic": element.topic,
                                  //       "score": element.score,
                                  //     });
                                  //   });
                                  // });
                                  print(_evaTopicMain.toList());
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          alertMessageOnlyOk(context,
                                              "ท่านยังทำประเมินไม่ครบทุกข้อ"));
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
        ),
      ),
    );
  }
}
