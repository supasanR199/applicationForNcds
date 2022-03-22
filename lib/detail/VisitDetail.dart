import 'package:flutter/material.dart';

class VisitDetail extends StatelessWidget {
  var visit;
  VisitDetail({Key key, @required this.visit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 211, 251, 1),
        appBar: AppBar(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'บันทึกผลตรวจจากการลงพื้นที่ของอาสาสมัคร',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  Text("ส่วนสูง ณวันที่ลงพื้นที่: ${visit["Visitheight"]}"),
                  Text("น้ำหนัก ณวันที่ลงพื้นที่:  ${visit["Visitweight"]}"),
                  Text("รอบเอว ณวันที่ลงพื้นที่:  ${visit["Visitwaistline"]}"),
                  Text(
                      "ความดันโลหิต ณวันที่ลงพื้นที่:  ${visit["Visitbloodpressure"]}"),
                  Text(
                      "อุณหภูมิ ณวันที่ลงพื้นที่:  ${visit["Visittemperature"]}"),
                  Text("BMI ณวันที่ลงพื้นที่:  ${visit["VisitBMI"]}"),
                  Text("รูปร่าง ณวันที่ลงพื้นที่:  ${visit["VisitBodyByBMI"]}"),
                  Text("บันทึกเพิ่มเติม:  ${visit["Visitother"]}"),

                  // Expanded(
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Column(
                  //           children: [
                  //             Text("น้ำหนัก ณวันที่ลงพื้นที่:"),
                  //             Text("ส่วนสูง ณวันที่ลงพื้นที่:"),
                  //             Text("รอบเอว ณวันที่ลงพื้นที่:"),
                  //           ],
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Column(
                  //           children: [
                  //             Text("ความดันโลหิต ณวันที่ลงพื้นที่:"),
                  //             Text("อุณหภูมิ ณวันที่ลงพื้นที่:"),
                  //             Text("รอบเอว ณวันที่ลงพื้นที่:"),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
