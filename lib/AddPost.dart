import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appilcation_for_ncds/models/PostContentModels.dart';

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
  RangeValues _currentRangeValues = const RangeValues(0, 100);
  RangeValues _currentRangeValuesBMi = const RangeValues(18.5, 30);

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
                    // print(values);
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Expanded(
              child: RangeSlider(
                values: _currentRangeValuesBMi,
                max: 30,
                min: 18.5,
                divisions: 60,
                labels: RangeLabels(
                  _currentRangeValuesBMi.start.roundToDouble().toString(),
                  _currentRangeValuesBMi.end.roundToDouble().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValuesBMi = values;
                    print(values);
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "กรุณากำหนดโรคที่เหมาะสมกับบทความ";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'บทความเหมาะสำหรับคนเป็นโรค',
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
                  onPressed: () {
                    print(widget.userData["name"]);
                    _postContentModels.createBy =
                        widget.userData["name"] + widget.userData["surname"];
                    _postContentModels.createAt = DateTime.now();
                    _postContentModels.recommentForAge;
                    print(DateTime.now());
                    if (_formPost.currentState.validate()) {
                      FirebaseFirestore.instance
                          .collection("RecommendPost")
                          .add({
                        "topic": _postContentModels.topic,
                        "content": _postContentModels.content,
                        "createAt": _postContentModels.createAt,
                        "recommentForDieases":
                            _postContentModels.recommentForDieases,
                        "recommentForAge": _postContentModels.recommentForAge,
                        "recommentForBMI": _postContentModels.recommentForBMI
                      });
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
}
