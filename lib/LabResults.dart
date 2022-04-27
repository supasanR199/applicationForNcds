import 'dart:html';

import 'package:appilcation_for_ncds/PatientMain.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appilcation_for_ncds/models/LabResultsModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';

class LabResults extends StatefulWidget {
  Map<String, dynamic> patienData;
  DocumentReference patienDataId;
  LabResults({Key key, @required this.patienData, @required this.patienDataId})
      : super(key: key);
  _LabResults createState() => _LabResults();
}

class _LabResults extends State<LabResults> {
  final _labResultsFrom = GlobalKey<FormState>();
  TextEditingController crateAtDate = TextEditingController();
  TextEditingController bmi = TextEditingController();
  TextEditingController waistline = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController weight = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateFormat myDateFormat = DateFormat("yyyy-MM-dd");
  LabResultsModels _labResultsModels = LabResultsModels();
  double calBmi;
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.blueAccent,
          centerTitle: false,
          title: Text(
            "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.grey.shade200,
        body: Container(
          child: Center(
            child: Card(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: SizedBox(
                  height: 700,
                  width: 1000,
                  child: Form(
                    key: _labResultsFrom,
                    child: ListView(
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 40
                            ),
                            child: Text(
                              'การตรวจร่างกาย',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                            ),
                          ),
                        ),
                        buildWeightField(context),
                        buildHeightField(context),
                        buildBmiField(context),
                        buildWaistlineField(context),
                        buildpulseField(context),
                        buildBreatheField(context),
                        buildBloodPressureField(context),
                        buildDTXField(context),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 40
                            ),
                            child: Text(
                              'ผลตรวจจากห้องปฎิบัติการ',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                            ),
                          ),
                        ),
                        buildFbsFpgField(context),
                        buildHb1cField(context),
                        buildBunField(context),
                        buildCrField(context),
                        buildLdlField(context),
                        buildHdlField(context),
                        buildCholField(context),
                        buildTgField(context),
                        buildMicroalbuminField(context),
                        buildUricacidField(context),
                        buildProteininurineField(context),
                        buildEyetestField(context),
                        buildDateField(context),
                        Row(
                          children: <Widget>[
                            Padding(
                              child: buildButtonRegister(context),
                              padding: EdgeInsets.only(
                                left: 50,
                                right: 20,
                                top: 70,
                                bottom: 50,
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //  margin: EdgeInsets.only(top: 100,bottom: 400,),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildWeightField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 30,
      ),
      child: TextFormField(
        controller: weight,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          // weight.text = value;
          if (_labResultsModels.weight == null) {
            _labResultsModels.weight = value;
          } else {
            _labResultsModels.weight = value;
          }
          calBmi = int.parse(_labResultsModels.weight) /
              ((int.parse(_labResultsModels.height) / 100) *
                  (int.parse(_labResultsModels.height) / 100));
          bmi.text = calBmi.toStringAsFixed(2);
          _labResultsModels.bmi = bmi.text;
        },
        decoration: InputDecoration(
          labelText: 'น้ำหนักผู้ป่วย(KG.)',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildHeightField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        controller: height,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          // height.text = value;
          if (_labResultsModels.height == null) {
            _labResultsModels.height = value;
          } else {
            _labResultsModels.height = value;
          }
          _labResultsModels.height = value;
          calBmi = int.parse(_labResultsModels.weight) /
              ((int.parse(_labResultsModels.height) / 100) *
                  (int.parse(_labResultsModels.height) / 100));
          bmi.text = calBmi.toStringAsFixed(2);
          _labResultsModels.bmi = bmi.text;
        },
        decoration: InputDecoration(
          labelText: 'ส่วนสูงผู้ป่วย(CM.)',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildWaistlineField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        // controller: waistline,

        keyboardType: TextInputType.number,
        onChanged: (value) {
          waistline.text = value;
          if (_labResultsModels.weight == null) {
            _labResultsModels.waistline = value;
          } else {
            _labResultsModels.waistline = value;
          }
          _labResultsModels.waistline = value;
        },
        decoration: InputDecoration(
          labelText: 'รอบเอว ของผู้ป่วย(CM.)',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildBmiField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        controller: bmi,
        keyboardType: TextInputType.number,
        readOnly: true,
        onChanged: (value) {
          // _labResultsModels.height = int.parse(value);
          print(calBmi);
          // bmi =  calBmi.;
        },
        decoration: InputDecoration(
          labelText: 'ค่าBMI ของผู้ป่วย',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildpulseField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          _labResultsModels.pulse = value;
        },
        decoration: InputDecoration(
          labelText: 'ตรวจชีพจรณ์(ครั่ง/ต่อนาที)',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildBreatheField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          _labResultsModels.breathe = value;
        },
        decoration: InputDecoration(
          labelText: 'ตรวจการหายใจ(ครั่ง/ต่อนาที)',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildBloodPressureField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          _labResultsModels.bloodpressure = value;
        },
        decoration: InputDecoration(
          labelText: 'ความดันโลหิต(mmHg/ต่อนาที)',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildDTXField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          _labResultsModels.DTX = value;
        },
        decoration: InputDecoration(
          labelText: 'DTX',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildFbsFpgField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 30,
      ),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(r'[0-9,-]'), allow: true)
        ],
        onChanged: (value) {
          _labResultsModels.FBSFPG = value;
        },
        decoration: InputDecoration(
          labelText: 'FBS/FPG',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildHb1cField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(r'[0-9,-]'), allow: true)
        ],
        onChanged: (value) {
          _labResultsModels.Hb1c = value;
        },
        decoration: InputDecoration(
          labelText: 'Hb1c',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildBunField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(r'[0-9,-]'), allow: true)
        ],
        onChanged: (value) {
          _labResultsModels.BUN = value;
        },
        decoration: InputDecoration(
          labelText: 'BUN',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildCrField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(r'[0-9,-]'), allow: true)
        ],
        onChanged: (value) {
          _labResultsModels.Cr = value;
        },
        decoration: InputDecoration(
          labelText: 'Cr',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildLdlField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(r'[0-9,-]'), allow: true)
        ],
        onChanged: (value) {
          _labResultsModels.LDL = value;
        },
        decoration: InputDecoration(
          labelText: 'LDL',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildHdlField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(r'[0-9,-]'), allow: true)
        ],
        onChanged: (value) {
          _labResultsModels.HDL = value;
        },
        decoration: InputDecoration(
          labelText: 'HDL',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildCholField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(r'[0-9,-]'), allow: true)
        ],
        onChanged: (value) {
          _labResultsModels.Chol = value;
        },
        decoration: InputDecoration(
          labelText: 'Chol',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildTgField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(r'[0-9,-]'), allow: true)
        ],
        onChanged: (value) {
          _labResultsModels.Tg = value;
        },
        decoration: InputDecoration(
          labelText: 'Tg',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildMicroalbuminField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(r'[0-9,-]'), allow: true)
        ],
        onChanged: (value) {
          _labResultsModels.Microalbumin = value;
        },
        decoration: InputDecoration(
          labelText: 'Micro-albumin',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildUricacidField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(r'[0-9,-]'), allow: true)
        ],
        onChanged: (value) {
          _labResultsModels.Uricacid = value;
        },
        decoration: InputDecoration(
          labelText: 'Uric-acid',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildProteininurineField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp(r'[0-9,-]'), allow: true)
        ],
        onChanged: (value) {
          _labResultsModels.Proteininurine = value;
        },
        decoration: InputDecoration(
          labelText: 'Protein-in-urine',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildEyetestField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        onChanged: (value) {
          _labResultsModels.Eyetest = value;
        },
        decoration: InputDecoration(
          labelText: 'Eye-test',
          // icon: Icon(Icons.people),
        ),
      ),
    );
  }

  Padding buildOtherField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        onChanged: (value) {
          _labResultsModels.Other = value;
        },
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        maxLines: 10,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'บันทึกเพิ่มเติม',
        ),
      ),
    );
  }

  Padding buildDateField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
          controller: crateAtDate,
          validator: (value) {
            if (value.isEmpty) {
              return 'กรุณาระบุวันที่บันทึก';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: 'วันที่บันทึก',
            // icon: Icon(Icons.people),
          ),
          onTap: () async {
            final DateTime selected = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2222),
            );
            if (selected != null && selected != selectedDate) {
              setState(() {
                selectedDate = selected;
                // print(selected);
                crateAtDate.text = myDateFormat.format(selected);
                // print(crateAtDate.text);
                _labResultsModels.createAt = selectedDate;
              });
            }
          }),
    );
  }

  Widget buildButtonRegister(context) {
    return RaisedButton(
      // color: Colors.accents,
      hoverColor: Colors.grey,
      child: Text('บันทึก'
      ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
      ),
      onPressed: () {
        if (_labResultsFrom.currentState.validate()) {
          try {
            print(_labResultsModels.height);
            print(_labResultsModels.bmi);
            print(_labResultsModels.waistline);
            print(_labResultsModels.weight);
            showDialog(
                    context: context,
                    builder: (BuildContext context) => alertMessage(
                        context, "ยืนยันการบันทึกผลตรวจจากห้องทดลอง"))
                .then((value) async {
              if (value == "CONFIRM") {
                if (height.text != null) {
                  await FirebaseFirestore.instance
                      .collection("MobileUser")
                      .doc(widget.patienDataId.id)
                      .update({"Height": height.text});
                }
                if (weight.text != null) {
                  await FirebaseFirestore.instance
                      .collection("MobileUser")
                      .doc(widget.patienDataId.id)
                      .update({"Weight": weight.text});
                }
                if (waistline.text != null) {
                  await FirebaseFirestore.instance
                      .collection("MobileUser")
                      .doc(widget.patienDataId.id)
                      .update({"Waistline": waistline.text});
                }

                await FirebaseFirestore.instance
                    .collection("MobileUser")
                    .doc(widget.patienDataId.id)
                    .collection("LabResultsHistory")
                    .doc(crateAtDate.text)
                    .set({
                  "Height": _labResultsModels.height,
                  "Weight": _labResultsModels.weight,
                  "Waistline": _labResultsModels.waistline,
                  "Bmi": _labResultsModels.bmi,
                  "Pulse": _labResultsModels.pulse,
                  "Breat": _labResultsModels.breathe,
                  "BloodPressure": _labResultsModels.bloodpressure,
                  "DTX": _labResultsModels.DTX,
                  "FBSFPG": _labResultsModels.FBSFPG,
                  "Hb1c": _labResultsModels.Hb1c,
                  "BUN": _labResultsModels.BUN,
                  "Cr": _labResultsModels.Cr,
                  "LDL": _labResultsModels.LDL,
                  "HDL": _labResultsModels.HDL,
                  "Chol": _labResultsModels.Chol,
                  "Microalbumin": _labResultsModels.Microalbumin,
                  "Uricacid": _labResultsModels.Uricacid,
                  "Proteininurine": _labResultsModels.Proteininurine,
                  "Eyetest": _labResultsModels.Eyetest,
                  "Tg": _labResultsModels.Tg,
                  "Other": _labResultsModels.Other,
                  "creatAt": _labResultsModels.createAt
                })
                    //     .add({
                    //   "FBSFPG": _labResultsModels.FBSFPG,
                    //   "Hb1c": _labResultsModels.Hb1c,
                    //   "BUN": _labResultsModels.BUN,
                    //   "Cr": _labResultsModels.Cr,
                    //   "LDL": _labResultsModels.LDL,
                    //   "HDL": _labResultsModels.HDL,
                    //   "Chol": _labResultsModels.Chol,
                    //   "Microalbumin": _labResultsModels.Microalbumin,
                    //   "Uricacid": _labResultsModels.Uricacid,
                    //   "Proteininurine": _labResultsModels.Proteininurine,
                    //   "Eyetest": _labResultsModels.Eyetest,
                    //   "Tg": _labResultsModels.Tg,
                    //   "creatAt": _labResultsModels.createAt
                    // })
                    .whenComplete(() {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          alertMessage(context, "บันทึกสำเร็จ")).then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientMain(
                          patienDataId: widget.patienDataId,
                          patienData: widget.patienData,
                          isHospital: true,
                        ),
                      ),
                    );
                  });
                });
              }
            });
          } on FirebaseException catch (e) {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    alertMessage(context, e.toString())).then(
              (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientMain(
                      patienDataId: widget.patienDataId,
                      patienData: widget.patienData,
                      isHospital: true,
                    ),
                  ),
                );
              },
            );
          }
        }
      },
      color: Colors.green,
      padding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }
}
