import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appilcation_for_ncds/models/LabResultsModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LabResults extends StatefulWidget {
  Map<String, dynamic> patienData;
  DocumentReference  patienDataId;

  LabResults({
    Key key,
    @required this.patienData, @required this.patienDataId
  }) : super(key: key);
  _LabResults createState() => _LabResults();
}

class _LabResults extends State<LabResults> {
  DateTime selectedDate = DateTime.now();
  LabResultsModels _labResultsModels;
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
        backgroundColor: Color.fromRGBO(255, 211, 251, 1),
        body: Container(
          child: Center(
            child: Card(
              child: SizedBox(
                height: 700,
                width: 1000,
                child: Form(
                  child: ListView(
                    children: <Widget>[
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
              //  margin: EdgeInsets.only(top: 100,bottom: 400,),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildFbsFpgField(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 70,
      ),
      child: TextFormField(
        onChanged: (value) {
          _labResultsModels.FBSFPG = value;
        },
        decoration: InputDecoration(
          labelText: 'FBS/FPG',
          icon: Icon(Icons.people),
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
        onChanged: (value) {
          _labResultsModels.Hb1c = value;
        },
        decoration: InputDecoration(
          labelText: 'Hb1c',
          icon: Icon(Icons.people),
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
        onChanged: (value) {
          _labResultsModels.BUN = value;
        },
        decoration: InputDecoration(
          labelText: 'BUN',
          icon: Icon(Icons.people),
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
        onChanged: (value) {
          _labResultsModels.Cr = value;
        },
        decoration: InputDecoration(
          labelText: 'Cr',
          icon: Icon(Icons.people),
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
        onChanged: (value) {
          _labResultsModels.LDL = value;
        },
        decoration: InputDecoration(
          labelText: 'LDL',
          icon: Icon(Icons.people),
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
        onChanged: (value) {
          _labResultsModels.HDL = value;
        },
        decoration: InputDecoration(
          labelText: 'HDL',
          icon: Icon(Icons.people),
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
        onChanged: (value) {
          _labResultsModels.Chol = value;
        },
        decoration: InputDecoration(
          labelText: 'Chol',
          icon: Icon(Icons.people),
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
        onChanged: (value) {
          _labResultsModels.Tg = value;
        },
        decoration: InputDecoration(
          labelText: 'Tg',
          icon: Icon(Icons.people),
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
        onChanged: (value) {
          _labResultsModels.Microalbumin = value;
        },
        decoration: InputDecoration(
          labelText: 'Micro-albumin',
          icon: Icon(Icons.people),
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
        onChanged: (value) {
          _labResultsModels.Uricacid = value;
        },
        decoration: InputDecoration(
          labelText: 'Uric-acid',
          icon: Icon(Icons.people),
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
        onChanged: (value) {
          _labResultsModels.Proteininurine = value;
        },
        decoration: InputDecoration(
          labelText: 'Protein-in-urine',
          icon: Icon(Icons.people),
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
          icon: Icon(Icons.people),
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
          decoration: InputDecoration(
            labelText: 'วันที่บันทึก',
            icon: Icon(Icons.people),
          ),
          onTap: () {
            showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2222));
          }),
    );
  }

  Widget buildButtonRegister(context) {
    return RaisedButton(
      // color: Colors.accents,
      child: Text('บันทึก'),
      onPressed: () {
        print(widget.patienData.toString());
        FirebaseFirestore.instance.collection("MobileUser").doc(widget.patienDataId.toString());
      },
      color: Colors.green,
      padding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
    );
  }
}
