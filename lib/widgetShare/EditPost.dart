import 'dart:typed_data';

import 'package:appilcation_for_ncds/widgetShare/ProfilePhoto.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_select/smart_select.dart';

class EditPost extends StatefulWidget {
  var postUid;
  var whoEdit;
  EditPost({Key key, @required this.postUid, @required this.whoEdit})
      : super(key: key);

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  @override
  void initState() {
    super.initState();
    getPostEdit();
  }

  getPostEdit() async {
    await FirebaseFirestore.instance
        .collection("RecommendPost")
        .doc(widget.postUid)
        .get()
        .then((value) {
      // setState() {
      topic.text = value.get("topic");
      content.text = value.get("content");
      recommentForAge.text = value.get("recommentForAge").toString();
      recommentForBmi.text = value.get("recommentForBMI").toString();
      recommentForTdee.text = value.get("recommentForTDEE").toString();
      recommentForBmr.text = value.get("recommentForBMR").toString();

      // }
    });
  }

  String _allBMI = "";
  String fileName = "";
  Uint8List fileBytes;
  List _valueNCDs = List();
  List<S2Choice> frameworks = [
    S2Choice(value: "diabetes", title: 'โรคเบาหวาน'),
    S2Choice(value: "pressure", title: 'โรคความดันโลหิต'),
    S2Choice(value: "fat", title: 'โรคอ้วน'),
  ];
  // TextEditingController pathPic = TextEditingController();
  TextEditingController topic = TextEditingController();
  TextEditingController content = TextEditingController();
  TextEditingController recommentForAge = TextEditingController();
  TextEditingController recommentForBmi = TextEditingController();
  TextEditingController recommentForTdee = TextEditingController();
  TextEditingController recommentForBmr = TextEditingController();
  int age;
  int bmi;
  int tdee;
  List recommentForDieases = List();
  int bmr;

  final _formEditPost = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "แก้ไขบทความ",
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      content: SizedBox(
        width: 700,
        height: 500,
        child: SingleChildScrollView(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formEditPost,
                  child: Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // Text("หัวข้อ:"),
                        FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection("RecommendPost")
                                .doc(widget.postUid)
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return Center(
                                  child: proFilePostShow(
                                    context,
                                    snapshot.data.get("imgPath"),
                                  ),
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            }),
                        // Center(child: proFilePostShow(context, pathPic)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: topic,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "กรุณาตั้งหัวข้อ";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              topic.text = value;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'หัวเรื่อง',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: content,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "กรุณาเพิ่มบทความ";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              content.text = value;
                            },
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            maxLines: 10,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'บทความ',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: recommentForAge,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value.isEmpty) {
                                return "กรุณาระบุอายุ";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              age = int.parse(value);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'บทความเหมาะกับผู้ที่มีอายุมากกว่า',
                            ),
                          ),
                        ),

                        Visibility(
                          visible: rangHide(),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: recommentForBmi,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "กรุณาระบุค่า BMI";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                bmi = int.parse(value);
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'บทความเหมาะกับผู้ที่มีBMI มากกว่า',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: recommentForBmr,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value.isEmpty) {
                                return "กรุณาระบุค่า BMR";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              bmr = int.parse(value);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText:
                                  'บทความเหมาะกับผู้ที่มีค่า BMR มากกว่า',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListTile(
                            title: const Text('เหมาะสำหรับผู้ป่วยทุกรูปร่าง'),
                            leading: Radio(
                              value: "all",
                              activeColor: Colors.amber,
                              toggleable: true,
                              onChanged: (value) {
                                setState(() {
                                  if (_allBMI == "all") {
                                    _allBMI = "";
                                  } else if (_allBMI != "all") {
                                    _allBMI = "all";
                                    // _postContentModels.recommentForBMI = 0;
                                  }
                                  // print(_allBMI);
                                  _allBMI = value;
                                });
                              },
                              groupValue: _allBMI,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: TextFormField(
                            controller: recommentForTdee,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value.isEmpty) {
                                return "กรุณาระบุค่า TDEE";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              tdee = int.parse(value);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText:
                                  'บทความเหมาะกับผู้ที่มีค่า TDEE มากกว่า',
                            ),
                          ),
                        ),
                        FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection("RecommendPost")
                                .doc(widget.postUid)
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasData) {
                                _valueNCDs =
                                    snapshot.data.get("recommentForDieases");
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SmartSelect.multiple(
                                    title: 'บทความเหมาะกับเป็นโรค?',
                                    value: _valueNCDs,
                                    choiceItems: frameworks,
                                    onChange: (state) => setState(() {
                                      // print(state.value);
                                      _valueNCDs = state.value;
                                      // _postContentModels.recommentForDieases =
                                      //     state.value;
                                    }),
                                    modalType: S2ModalType.popupDialog,
                                    modalValidation: (value) {
                                      if (value.isEmpty) {
                                        return "เลือกโรคที่เหมาะสมกับบทความ";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            }),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: buttonCorrect(context),
                              ),
                              buttonCancel(),
                            ]),
                      ],
                    ),
                  ),
                ),
                // Expanded(
                //   child: Column(children: <Widget>[]),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonCorrect(context) {
    return RaisedButton(
      onPressed: () async {
        if (_formEditPost.currentState.validate()) {
          showDialog(
                  context: context,
                  builder: (BuildContext content) =>
                      alertMessage(content, "คุณแน่ใจที่จะแก้ไขบทความหรือไม่"))
              .then(
            (value) async {
              if (value == "CONFIRM") {
                await FirebaseFirestore.instance
                    .collection("RecommendPost")
                    .doc(widget.postUid)
                    .update({
                  "topic": topic.text,
                  "content": content.text,
                  "editBy": widget.whoEdit,
                  "recommentForDieases": _valueNCDs,
                  "recommentForAge": age,
                  "recommentForBMI": bmi,
                  "recommentForBMR": bmr,
                  "recommentForTDEE": tdee,
                }).whenComplete(() {
                  showDialog(
                          context: context,
                          builder: (BuildContext content) =>
                              alertMessageOnlyOk(content, "แก้ไขบทความสำเร็จ"))
                      .then(
                    (value) => Navigator.pop(context),
                  );
                });
              } else if (value == 'CANCEL') {
                Navigator.pop(context);
              }
            },
          );
        }
      },
      child: Row(children: [
        Icon(IconData(0xe159, fontFamily: 'MaterialIcons'),
            color: Colors.white),
        Text(
          "ตกลง",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ]),
      color: Colors.green,
      hoverColor: Colors.grey,
      padding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }

  Widget buttonCancel() {
    return RaisedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Row(children: [
        Icon(IconData(0xef58, fontFamily: 'MaterialIcons'),
            color: Colors.white),
        Text(
          "ยกเลิก",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ]),
      color: Colors.red,
      hoverColor: Colors.grey,
      padding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }

  bool rangHide() {
    if (_allBMI == "all") {
      return false;
    } else if (_allBMI != "all") {
      return true;
    }
  }
}
