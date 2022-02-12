import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appilcation_for_ncds/models/PostContentModels.dart';
import 'package:smart_select/smart_select.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';

class AddPost extends StatefulWidget {
  Map<String, dynamic> userData;
  AddPost({Key key, @required this.userData}) : super(key: key);
  _AddPost createState() => _AddPost();
}

class _AddPost extends State<AddPost> {
  final _formPost = GlobalKey<FormState>();
  TextEditingController age = TextEditingController();
  TextEditingController age1 = TextEditingController();
  PostContentModels _postContentModels = PostContentModels();
  RangeValues _currentRangeValues = RangeValues(0, 100);
  RangeValues _currentRangeValuesBMi = RangeValues(18.5, 30);
  List<String> _valueNCDs = List();
  List<S2Choice<String>> frameworks = [
    S2Choice<String>(value: "diabetes", title: 'โรคเบาหวาน'),
    S2Choice<String>(value: "hypertension", title: 'โรคความดันโลหิต'),
    S2Choice<String>(value: "fat", title: 'โรคอ้วน'),
  ];
  String _allBMI = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: Center(
            child: Card(
              child: SizedBox(
                height: 700,
                width: 1000,
                child: ListView(
                  children: <Widget>[
                    Form(
                      key: _formPost,
                      child: buildInputPostFrom(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Color.fromRGBO(255, 211, 251, 1),
      ),
    );
  }

  Widget buildInputPostFrom(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "กรุณาตั้งหัวข้อ";
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                _postContentModels.topic = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'หัวเรื่อง',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 5,
              top: 20,
              right: 20,
              left: 20,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'อายุ',
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Expanded(
              child: RangeSlider(
                values: _currentRangeValues,
                max: 100,
                divisions: 100,
                labels: RangeLabels(
                  _currentRangeValues.start.round().toString(),
                  _currentRangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                  });
                },
              ),
            ),
          ),
          Visibility(
            visible: rangHide(),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 5,
                top: 20,
                right: 20,
                left: 20,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'BMI',
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          Visibility(
            visible: rangHide(),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Expanded(
                child: RangeSlider(
                  values: _currentRangeValuesBMi,
                  max: 30,
                  min: 18.5,
                  divisions: 11,
                  labels: RangeLabels(
                    _currentRangeValuesBMi.start.toStringAsFixed(1),
                    _currentRangeValuesBMi.end.toStringAsFixed(1),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _currentRangeValuesBMi = values;
                    });
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
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
                      _postContentModels.recommentForBMI.add("all");
                    }
                    print(_allBMI);
                    _allBMI = value;
                  });
                },
                groupValue: _allBMI,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SmartSelect<String>.multiple(
              modalValidation: (value) {
                if (value.isEmpty) {
                  return "เลือกโรคที่เหมาะสมกับบทความ";
                } else {
                  return null;
                }
              },
              title: 'บทความเหมาะกับเป็นโรค?',
              value: _valueNCDs,
              choiceItems: frameworks,
              onChange: (state) => setState(() {
                print(state.value);
                _valueNCDs = state.value;
                _postContentModels.recommentForDieases = state.value;
              }),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 5,
              top: 20,
              right: 20,
              left: 20,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'เนื้อหาโพสต์',
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 20,
              top: 0,
              right: 20,
              left: 20,
            ),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "กรุณาระบุบทความ";
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                _postContentModels.content = value;
              },
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              maxLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'เนื้อหาโพสต์',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: RaisedButton(
              // color: Colors.accents,
              onPressed: () => Navigator.pushNamed(context, '/mainpage'),
              color: Colors.white,
              child: Text('ฮัพโหลดรูปภาพ'),
              padding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: RaisedButton(
                  onPressed: () async {
                    if (_formPost.currentState.validate()) {
                      initDataToDb();
                      try {
                        await FirebaseFirestore.instance
                            .collection("RecommendPost")
                            .add({
                          "topic": _postContentModels.topic,
                          "content": _postContentModels.content,
                          "createAt": _postContentModels.createAt,
                          "recommentForDieases":
                              _postContentModels.recommentForDieases,
                          "recommentForAge": _postContentModels.recommentForAge,
                          "recommentForBMI": _postContentModels.recommentForBMI,
                          "createBy": _postContentModels.createBy
                        }).whenComplete(() {
                          showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      alertMessageOnlyOk(context,
                                          "เพิ่มโพสต์แนะนำเรียบร้อยแล้ว"))
                              .then((value) {
                            if (value == "CONFIRM") {
                              Navigator.pop(context);
                            }
                          });
                        });
                      } on FirebaseException catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              alertMessageOnlyOk(context, e.toString()),
                        );
                      }
                    }
                  },
                  color: Colors.green[100],
                  child: Text('บันทึก'),
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: RaisedButton(
                  onPressed: () => Navigator.pushNamed(context, '/mainpage'),
                  color: Colors.red[100],
                  child: Text('ยกเลิก'),
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  bool rangHide() {
    if (_allBMI == "all") {
      return false;
    } else if (_allBMI != "all") {
      return true;
    }
  }

  initDataToDb() {
    _postContentModels.createBy =
        widget.userData["name"] + widget.userData["surname"];
    _postContentModels.createAt = DateTime.now();
    _postContentModels.recommentForAge = [];
    _postContentModels.recommentForBMI = [];
    _postContentModels.recommentForAge.add(_currentRangeValues.start.round());
    _postContentModels.recommentForAge.add(_currentRangeValues.end.round());
    if (_allBMI == "all") {
      _postContentModels.recommentForBMI.clear();
      _postContentModels.recommentForBMI.add("all");
    } else if (_allBMI != "all") {
      _postContentModels.recommentForBMI.add(_currentRangeValuesBMi.start);
      _postContentModels.recommentForBMI.add(_currentRangeValuesBMi.end);
    }
  }
}
