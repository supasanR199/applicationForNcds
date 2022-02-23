import 'package:flutter/material.dart';
import 'package:appilcation_for_ncds/function/DisplayTime.dart';

class LabResultsDetail extends StatelessWidget {
  Map<String, dynamic> labResultsData;
  LabResultsDetail({Key key, @required this.labResultsData}) : super(key: key);

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
        backgroundColor: Color.fromRGBO(255, 211, 251, 1),
        body: Center(
          child: Card(
            child: SizedBox(
              height: 700,
              width: 1000,
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("FBSFPG:  ${labResultsData["FBSFPG"]}"),
                    Text("Hb1c:  ${labResultsData["Hb1c"]}"),
                    Text("BUN:  ${labResultsData["BUN"]}"),
                    Text("Cr:  ${labResultsData["Cr"]}"),
                    Text("LDL:  ${labResultsData["LDL"]}"),
                    Text("HDL:  ${labResultsData["HDL"]}"),
                    Text("Chol:  ${labResultsData["Chol"]}"),
                    Text("Microalbumin:  ${labResultsData["Microalbumin"]}"),
                    Text(
                        "Proteininurine:  ${labResultsData["Proteininurine"]}"),
                    Text("Eyetest:  ${labResultsData["Eyetest"]}"),
                    Text("Tg:  ${labResultsData["Tg"]}"),
                    Text(
                      "บันทึกเมื่อวันที่: " +
                          convertDateTimeDisplay(
                              labResultsData["creatAt"].toDate().toString()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
