import 'package:flutter/material.dart';

class VisitDetail extends StatelessWidget {
  var visit;
  VisitDetail({Key key, @required this.visit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
            style: TextStyle(color: Colors.black),
          ),
          foregroundColor: Colors.blueAccent,
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Card(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),            
            child: SizedBox(
              height: 800,
              width: 1000,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40,bottom: 20),
                        child: Text(
                          'บันทึกการลงพื้นที่ของอาสาสมัคร',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),
                        ),
                      ),
                    ),
                                    ListTile(
                                        leading: Text('การบันทึก',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                                        trailing: Text("ค่าที่ได้",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),
                                            ),                                               
                                    Divider(thickness: 2, color: Colors.grey,),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  ListTile(
                                                    leading: Text('น้ำหนัก ณวันที่ลงพื้นที่ :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                    trailing: Text("${visit['Visitheight']} กก.",style: TextStyle(fontSize: 17,)),
                                                  ),
                                                  // Divider(thickness: 2, color: Colors.grey.shade300,)
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  ListTile(
                                                    leading: Text('ส่วนสูง ณวันที่ลงพื้นที่ :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                    trailing: Text("${visit["Visitheight"]} ซม.",style: TextStyle(fontSize: 17,)),
                                                  ),
                                                  // Divider(thickness: 2, color: Colors.grey.shade300,)
                                                ],
                                              ),  
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  ListTile(
                                                    leading: Text('รอบเอว ณวันที่ลงพื้นที่ :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                    trailing: Text("${visit["Visitwaistline"]} นิ้ว",style: TextStyle(fontSize: 17,)),
                                                  ),
                                                  // Divider(thickness: 2, color: Colors.grey.shade300,)
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  ListTile(
                                                    leading: Text('ความดันโลหิต ณวันที่ลงพื้นที่ :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                    trailing: Text("${visit["Visitbloodpressure"]} mmHg",style: TextStyle(fontSize: 17,)),
                                                  ),
                                                  // Divider(thickness: 2, color: Colors.grey.shade300,)
                                                ],
                                              ),  
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  ListTile(
                                                    leading: Text('อุณหภูมิ ณวันที่ลงพื้นที่ :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                    trailing: Text("${visit["Visittemperature"]} องศา",style: TextStyle(fontSize: 17,)),
                                                  ),
                                                  // Divider(thickness: 2, color: Colors.grey.shade300,)
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  ListTile(
                                                    leading: Text('น้ำตาลในเลือด :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                    trailing: Text("${visit["VisitDTX"]} mg%",style: TextStyle(fontSize: 17,)),
                                                  ),
                                                  // Divider(thickness: 2, color: Colors.grey.shade300,)
                                                ],
                                              ),                                              
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  ListTile(
                                                    leading: Text('BMI ณวันที่ลงพื้นที่ :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                    trailing: Text("${visit["VisitBMI"]}",style: TextStyle(fontSize: 17,)),
                                                  ),
                                                  // Divider(thickness: 2, color: Colors.grey.shade300,)
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  ListTile(
                                                    leading: Text('รูปร่าง ณวันที่ลงพื้นที่ :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                    trailing: Text("${visit["VisitBodyByBMI"]}",style: TextStyle(fontSize: 17,)),
                                                  ),
                                                  // Divider(thickness: 2, color: Colors.grey.shade300,)
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  ListTile(
                                                    leading: Text('บันทึกเพิ่มเติม :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                    trailing: Text("${visit["Visitother"]}",style: TextStyle(fontSize: 17,)),
                                                  ),
                                                  // Divider(thickness: 2, color: Colors.grey.shade300,)
                                                ],
                                              ),                                                                                                                                                                                                                                                                                                                                                 
                    // Text("ส่วนสูง ณวันที่ลงพื้นที่: ${visit["Visitheight"]}"),
                    // Text("น้ำหนัก ณวันที่ลงพื้นที่:  ${visit["Visitweight"]}"),
                    // Text("รอบเอว ณวันที่ลงพื้นที่ :  ${visit["Visitwaistline"]}"),
                    // Text(
                    //     "ความดันโลหิต ณวันที่ลงพื้นที่ :  ${visit["Visitbloodpressure"]}"),
                    // Text(
                    //     "อุณหภูมิ ณวันที่ลงพื้นที่:  ${visit["Visittemperature"]}"),
                    // Text("BMI ณวันที่ลงพื้นที่:  ${visit["VisitBMI"]}"),
                    // Text("รูปร่าง ณวันที่ลงพื้นที่:  ${visit["VisitBodyByBMI"]}"),
                    // Text("บันทึกเพิ่มเติม:  ${visit["Visitother"]}"),

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
      ),
    );
  }
}
