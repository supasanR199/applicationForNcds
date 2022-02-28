import 'package:appilcation_for_ncds/widgetShare/EvaluateChoice.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:appilcation_for_ncds/models/EvaluateModels.dart';
import 'package:radio_button_form_field/radio_button_form_field.dart';

class EvaulatePage extends StatefulWidget {
  String role;
  EvaulatePage({Key key, @required this.role}) : super(key: key);

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
  final List<Map> data = [
    {'value': 4, 'display': 'ดีมาก'},
    {'value': 3, 'display': 'ดี'},
    // {'value': 3, 'display': 'ปานกลาง'},
    {'value': 2, 'display': 'พอใช้'},
    {'value': 1, 'display': 'ปรับปรุง'},
  ];
  @override
  Widget build(BuildContext context) {
    List<EvaluateTopicModels> _evaTopicMain = List();
    return Container(
      child: Scaffold(
        appBar: AppBar(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'ประเมินการใช้งาน',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      EvaluateChoice(
                        subject:
                            "1.ฟังก์ชันการทำงานมีความเหมาะสมกับกับการติดตามผู้ป่วย",
                      ),
                      RadioButtonFormField(
                        // toggleable: true,
                        padding: EdgeInsets.all(8),
                        context: context,
                        value: 'value',
                        display: 'display',
                        data: data,
                        onSaved: (newValue) {
                          print(newValue);
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
                        subject:
                            "2.ฟังก์ชันการทำงานของแอปพลิเคชันช่วยในการประเมินอาการของผู้ป่วยได้ง่ายขึ้น",
                      ),
                      RadioButtonFormField(
                        // toggleable: true,
                        padding: EdgeInsets.all(8),
                        context: context,
                        value: 'value',
                        display: 'display',
                        data: data,
                        onSaved: (newValue) {
                          print(newValue);
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
                        subject:
                            "3.ฟังก์ชันการทำงานของแอปพลิเคชันสามารถแนะนำผู้ป่วยในการใช้ชีวิตประจำวันได้ดี",
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
                        subject: "4.หน้าจอออกแบบสวยงาม ดึงดูดการใช้งานได้ดี",
                      ),
                      RadioButtonFormField(
                        // toggleable: true,
                        padding: EdgeInsets.all(8),
                        context: context,
                        value: 'value',
                        display: 'display',
                        data: data,
                        onSaved: (newValue) {
                          print(newValue);
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
                      EvaluateChoice(
                        subject:
                            "5.แอปพลิเคชันมีความง่ายต่อการบันทึกผลการตรวจของผู้ป่วย",
                      ),
                      RadioButtonFormField(
                        // toggleable: true,
                        padding: EdgeInsets.all(8),
                        context: context,
                        value: 'value',
                        display: 'display',
                        data: data,
                        onSaved: (newValue) {
                          print(newValue);
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
                      EvaluateChoice(
                        subject:
                            "6.ข้อมูลที่ได้รับจากการบันทึกของผู้ป่วยมีประโยชน์ต่อการรักษา",
                      ),
                      RadioButtonFormField(
                        // toggleable: true,
                        padding: EdgeInsets.all(8),
                        context: context,
                        value: 'value',
                        display: 'display',
                        data: data,
                        onSaved: (newValue) {
                          print(newValue);
                          evaTopic_5.score = newValue;
                          evaTopic_5.topic =
                              "ข้อมูลที่ได้รับจากการบันทึกของผู้ป่วยมีประโยชน์ต่อการรักษา";
                          _evaList.add(evaTopic_5);
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
                        subject: "7.แอปพลิเคชันช่วยลดขั้นตอนการทำงานได้",
                      ),
                      RadioButtonFormField(
                        // toggleable: true,
                        padding: EdgeInsets.all(8),
                        context: context,
                        value: 'value',
                        display: 'display',
                        data: data,
                        onSaved: (newValue) {
                          print(newValue);
                          evaTopic_6.score = newValue;
                          evaTopic_6.topic =
                              "แอปพลิเคชันช่วยลดขั้นตอนการทำงานได้";
                          _evaList.add(evaTopic_6);
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
                        subject:
                            "8.การโต้ตอบระหว่างผู้ใช้งานกับแอปพลิเคชัน มีความสะดวกและเข้าใจง่าย",
                      ),
                      RadioButtonFormField(
                        // toggleable: true,
                        padding: EdgeInsets.all(8),
                        context: context,
                        value: 'value',
                        display: 'display',
                        data: data,
                        onSaved: (newValue) {
                          print(newValue);
                          evaTopic_7.score = newValue;
                          evaTopic_7.topic =
                              "การโต้ตอบระหว่างผู้ใช้งานกับแอปพลิเคชัน มีความสะดวกและเข้าใจง่าย";
                          _evaList.add(evaTopic_7);
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
                        subject:
                            "9.แอปพลิเคชันช่วยลดขั้นตอนการทำงานได้เป็นอย่างดี",
                      ),
                      RadioButtonFormField(
                        // toggleable: true,
                        padding: EdgeInsets.all(8),
                        context: context,
                        value: 'value',
                        display: 'display',
                        data: data,
                        onSaved: (newValue) {
                          print(newValue);
                          evaTopic_8.score = newValue;
                          evaTopic_8.topic =
                              "แอปพลิเคชันช่วยลดขั้นตอนการทำงานได้เป็นอย่างดี";
                          _evaList.add(evaTopic_8);
                        },
                        validator: (value) {
                          if (value == null) {
                            return "โปรดให้คะแนนการประเมิน";
                          } else {
                            return null;
                          }
                        },
                      ),
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

                      RaisedButton(
                        child: Text('บันทึก'),
                        onPressed: () {
                          if (_addForm.currentState.validate()) {
                            _addForm.currentState.save();
                            FirebaseFirestore.instance
                                .collection("Evaluate")
                                .add({
                              "createAt": DateTime.now(),
                              "role": widget.role
                            }).then((value) {
                              _evaList.forEach((element) {
                                FirebaseFirestore.instance
                                    .collection("Evaluate")
                                    .doc(value.id)
                                    .collection("topic")
                                    .add({
                                  "topic": element.topic,
                                  "score": element.score
                                });
                              });
                            });
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    alertMessageOnlyOk(context,
                                        "ท่านยังทำประเมินไม่ครบทุกข้อ"));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}