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
              child: SingleChildScrollView(
                child: Form(
                  key: _addForm,
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
                      EvaluateChoice(
                        subject:
                            "1.ฟังก์ชันการทำงานมีความเหมาะสมกับกับการติดตามผู้ป่วย",
                        onChoiceChang: (newValue) {
                          print(newValue);
                          EvaluateTopicModels _evaTopic = EvaluateTopicModels(
                              score: newValue, topic: topic[0]);
                          print(_evaTopic.toString());
                          _evaTopicMain.add(_evaTopic);
                          print(_evaTopicMain.toList());
                          print(_evaTopicMain);
                          FirebaseFirestore.instance
                              .collection("Evaluate")
                              .add({"test": _evaTopic});
                        },
                      ),
                      EvaluateChoice(
                        subject:
                            "2.ฟังก์ชันการทำงานของแอปพลิเคชันช่วยในการประเมินอาการของผู้ป่วยได้ง่ายขึ้น",
                        onChoiceChang: (newValue) {
                          print(newValue.toString());
                        },
                      ),
                      EvaluateChoice(
                        subject:
                            "3.ฟังก์ชันการทำงานของแอปพลิเคชันสามารถแนะนำผู้ป่วยในการใช้ชีวิตประจำวันได้ดี",
                        onChoiceChang: (newValue) {
                          print(newValue.toString());
                        },
                      ),
                      EvaluateChoice(
                        subject: "4.หน้าจอออกแบบสวยงาม ดึงดูดการใช้งานได้ดี",
                        onChoiceChang: (newValue) {
                          print(newValue.toString());
                        },
                      ),
                      EvaluateChoice(
                        subject:
                            "5.แอปพลิเคชันมีความง่ายต่อการบันทึกผลการตรวจของผู้ป่วย",
                        onChoiceChang: (newValue) {
                          print(newValue.toString());
                        },
                      ),
                      EvaluateChoice(
                        subject:
                            "6.ข้อมูลที่ได้รับจากการบันทึกของผู้ป่วยมีประโยชน์ต่อการรักษา",
                        onChoiceChang: (newValue) {
                          print(newValue.toString());
                        },
                      ),
                      EvaluateChoice(
                        subject: "7.แอปพลิเคชันช่วยลดขั้นตอนการทำงานได้",
                        onChoiceChang: (newValue) {
                          print(newValue.toString());
                        },
                      ),
                      EvaluateChoice(
                        subject:
                            "8.การโต้ตอบระหว่างผู้ใช้งานกับแอปพลิเคชัน มีความสะดวกและเข้าใจง่าย",
                        onChoiceChang: (newValue) {
                          print(newValue.toString());
                        },
                      ),
                      EvaluateChoice(
                        subject:
                            "9.แอปพลิเคชันช่วยลดขั้นตอนการทำงานได้เป็นอย่างดี",
                        onChoiceChang: (newValue) {
                          print(newValue.toString());
                        },
                      ),
                      RaisedButton(
                        child: Text('บันทึก'),
                        onPressed: () {
                          _addForm.currentState.save();
                          // if (_addForm.currentState.validate()) {
                          //   _addForm.currentState.save();
                          // } else {
                          //   showDialog(
                          //       context: context,
                          //       builder: (BuildContext context) =>
                          //           alertMessageOnlyOk(
                          //               context, "ท่านยังทำประเมินไม่ครบทุกข้อ"));
                          // }
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
