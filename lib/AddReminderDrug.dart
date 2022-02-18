import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_select/smart_select.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:appilcation_for_ncds/models/RemindeDrugModels.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:radio_button_form_field/radio_button_form_field.dart';

class AddReminderDrug extends StatefulWidget {
  Map<String, dynamic> patienData;
  DocumentReference patienDataId;
  AddReminderDrug(
      {Key key, @required this.patienData, @required this.patienDataId})
      : super(key: key);

  @override
  _AddReminderDrugState createState() => _AddReminderDrugState();
}

class _AddReminderDrugState extends State<AddReminderDrug> {
  DateTime selectedDate = DateTime.now();
  TextEditingController exdDate = TextEditingController();
  DateFormat myDateFormat = DateFormat("dd-MM-yyyy");
  List<S2Choice<String>> _time = [
    S2Choice<String>(value: "morning", title: 'เช้า'),
    S2Choice<String>(value: "affternoon", title: 'กลางวัน'),
    S2Choice<String>(value: "evening", title: 'เย็น'),
    S2Choice<String>(value: "ninght", title: 'ก่อนนอน'),
  ];
  List<String> _valueTime = List();
  String timeToEat = "";
  RemindeDrugModels _remindeDrugModels = RemindeDrugModels();
  final _addRemindForm = GlobalKey<FormState>();
  final List<Map> data = [
    {'value': "before_meals", 'display': 'ก่อนอาหาร'},
    {'value': "after_meals", 'display': 'หลังอาหาร'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          child: Center(
            child: Card(
              child: SizedBox(
                height: 700,
                width: 1000,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    key: _addRemindForm,
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(
                              'เตือนความจำผู้ป่วยรับประทานยา',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                        TextFormField(
                          onChanged: (value) {
                            _remindeDrugModels.nameDrug = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "โปรดระบุชื่อยา";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'ชื่อยา',
                          ),
                        ),
                        SmartSelect<String>.multiple(
                          title: "ช่วงเวลารับประทานยา",
                          // modalConfig: ,
                          choiceItems: _time,
                          value: _valueTime,
                          modalValidation: (value) {
                            if (value.isEmpty) {
                              return "เลือกเวลาในการรับประทานยา";
                            } else {
                              return null;
                            }
                          },
                          onChange: (value) {
                            setState(() {
                              print(value.value);
                              _valueTime = value.value;
                              _remindeDrugModels.time = _valueTime;
                            });
                          },
                        ),
                        // ListTile(
                        //   title: Text('ก่อนอาหาร'),
                        //   leading: Radio(
                        //     value: "before_meals",
                        //     activeColor: Colors.amber,
                        //     toggleable: true,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         print(value);
                        //         timeToEat = value;
                        //       });
                        //     },
                        //     groupValue: timeToEat,
                        //   ),
                        // ),
                        // ListTile(
                        //   title: Text('หลังอาหาร'),
                        //   leading: Radio(
                        //     value: "after_meals",
                        //     activeColor: Colors.amber,
                        //     toggleable: true,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         print(value);
                        //         timeToEat = value;
                        //       });
                        //     },
                        //     groupValue: timeToEat,
                        //   ),
                        // ),
                        RadioButtonFormField(
                          toggleable: true,
                          padding: EdgeInsets.all(8),
                          context: context,
                          value: 'value',
                          display: 'display',
                          data: data,
                          validator: (value) {
                            if (value == "") {
                              return "โปรดเลือกการกินยา";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            setState(() {
                              print(value);
                              _remindeDrugModels.timeToEat = value;
                              // myValue = value.toString();
                            });
                          },
                        ),
                        TextFormField(
                          onChanged: (value) {
                            _remindeDrugModels.note = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'หมายเหตุ',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: TextFormField(
                              readOnly: true,
                              controller: exdDate,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'กรุณาระบุวันหมดอายุของยา';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'วันหมดอายุของยา',
                                icon: Icon(Icons.people),
                              ),
                              onTap: () async {
                                final DateTime selected = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2222),
                                );
                                if (selected != null &&
                                    selected != selectedDate) {
                                  setState(() {
                                    selectedDate = selected;
                                    exdDate.text =
                                        myDateFormat.format(selected);
                                    print(selected);
                                    _remindeDrugModels.exdDate = selectedDate;
                                  });
                                }
                              }),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              buildButtonAddReminded(context),
                              Padding(
                                  padding: EdgeInsets.only(right: 8, left: 8)),
                              buildButtonCancle(context)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtonAddReminded(context) {
    return RaisedButton(
      // color: Colors.accents,
      child: Text('บันทึก'),
      onPressed: () async {
        try {
          if (_addRemindForm.currentState.validate()) {
            _addRemindForm.currentState.save();
            await FirebaseFirestore.instance
                .collection("MobileUser")
                .doc(widget.patienDataId.id)
                .collection("ReminderDrug")
                .add({
              "name": _remindeDrugModels.nameDrug,
              "TimeToEat": _remindeDrugModels.time,
              "After/Befor": _remindeDrugModels.timeToEat,
              "Note": _remindeDrugModels.note,
              "DateEXP": _remindeDrugModels.exdDate
            }).whenComplete(() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      alertMessageOnlyOk(context, "บันทึกสำเร็จ"));
            });
          }
        } on FirebaseException catch (e) {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  alertMessage(context, e.toString()));
        }
      },
      color: Colors.green,
      padding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
    );
  }

  Widget buildButtonCancle(context) {
    return RaisedButton(
      // color: Colors.accents,
      child: Text('ยกเลิก'),
      onPressed: () {
        Navigator.pop(context);
      },
      padding: EdgeInsets.all(20),
      color: Colors.redAccent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
    );
  }
}
