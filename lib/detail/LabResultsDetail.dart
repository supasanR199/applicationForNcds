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
          centerTitle: false,
          title: Text(
            "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
            style: TextStyle(color: Colors.black),
          ),
          foregroundColor: Colors.blueAccent,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.grey.shade200,
        body: Center(
          child: Card(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
            child: SizedBox(
              height: 800,
              width: 1000,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 120),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40,),
                      Text('การตรวจร่างกาย',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),),
                      SizedBox(height: 20,),
                                                 ListTile(
                                                  leading: Text('การตรวจ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                                                  trailing: Text("ค่าที่ได้",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),
                                                ),                                               
                                                Divider(thickness: 2, color: Colors.grey,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ListTile(
                                                  leading: Text('น้ำหนัก :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                  trailing: Text("${labResultsData['Weight']} กก.",style: TextStyle(fontSize: 17,)),
                                                ),
                                                // Divider(thickness: 2, color: Colors.grey.shade300,)
                                              ],
                                            ),                      
                                            // RichText(
                                            //   text: TextSpan(
                                            //     style: TextStyle(color: Colors.black),
                                            //         children: <TextSpan>[
                                            //         TextSpan(text: 'น้ำหนัก :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                            //         TextSpan(text: ' ${labResultsData['Weight']} กก.',style: TextStyle(fontSize: 17,)),
                                            //       ],
                                            //   ),
                                            // ),                                  
                                          // SizedBox(height: 10,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ListTile(
                                                  leading: Text('ส่วนสูง :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                  trailing: Text("${labResultsData['Height']} ซม.",style: TextStyle(fontSize: 17,)),
                                                ),
                                                // Divider(thickness: 2, color: Colors.grey.shade300,)
                                              ],
                                            ),                                            
                                            // RichText(
                                            //   text: TextSpan(
                                            //     style: TextStyle(color: Colors.black),
                                            //         children: <TextSpan>[
                                            //         TextSpan(text: 'ส่วนสูง :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                            //         TextSpan(text: ' ${labResultsData['Height']} ซม.',style: TextStyle(fontSize: 17,)),
                                            //       ],
                                            //   ),
                                            // ),                                       
                                          // SizedBox(height: 10,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ListTile(
                                                  leading: Text('รอบเอว :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                  trailing: Text("${labResultsData["Waistline"]} นิ้ว",style: TextStyle(fontSize: 17,)),
                                                ),
                                                // Divider(thickness: 2, color: Colors.grey.shade300,)
                                              ],
                                            ),                                                
                                            // RichText(
                                            //   text: TextSpan(
                                            //     style: TextStyle(color: Colors.black),
                                            //         children: <TextSpan>[
                                            //         TextSpan(text: 'รอบเอว :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                            //         TextSpan(text: ' ${labResultsData["Waistline"]} นิ้ว',style: TextStyle(fontSize: 17,)),
                                            //       ],
                                            //   ),
                                            // ),                                                                 
                                          // SizedBox(height: 10,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ListTile(
                                                  leading: Text('ค่าดัชนีมวลกาย :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                  trailing: Text("${labResultsData["Bmi"]}",style: TextStyle(fontSize: 17,)),
                                                ),
                                                // Divider(thickness: 2, color: Colors.grey.shade300,)
                                              ],
                                            ),                                             
                                            // RichText(
                                            //   text: TextSpan(
                                            //     style: TextStyle(color: Colors.black),
                                            //         children: <TextSpan>[
                                            //         TextSpan(text: 'ค่าดัชนีมวลกาย :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                            //         TextSpan(text: ' ${labResultsData["Bmi"]}',style: TextStyle(fontSize: 17,)),
                                            //       ],
                                            //   ),
                                            // ),                                      
                                          // SizedBox(height: 10,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ListTile(
                                                  leading: Text('ตรวจชีพจรณ์ :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                  trailing: Text("${labResultsData["Pulse"]} ครั้ง/นาที",style: TextStyle(fontSize: 17,)),
                                                ),
                                                // Divider(thickness: 2, color: Colors.grey.shade300,)
                                              ],
                                            ),                                            
                                            // RichText(
                                            //   text: TextSpan(
                                            //     style: TextStyle(color: Colors.black),
                                            //         children: <TextSpan>[
                                            //         TextSpan(text: 'ตรวจชีพจรณ์ :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                            //         TextSpan(text: ' ${labResultsData["Pulse"]} ครั้ง/นาที',style: TextStyle(fontSize: 17,)),
                                            //       ],
                                            //   ),
                                            // ),                                      
                                          // SizedBox(height: 10,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ListTile(
                                                  leading: Text('ตรวจการหายใจ :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                  trailing: Text("${labResultsData["Breat"]} ครั้ง/นาที",style: TextStyle(fontSize: 17,)),
                                                ),
                                                // Divider(thickness: 2, color: Colors.grey.shade300,)
                                              ],
                                            ),                                             
                                            // RichText(
                                            //   text: TextSpan(
                                            //     style: TextStyle(color: Colors.black),
                                            //         children: <TextSpan>[
                                            //         TextSpan(text: 'ตรวจการหายใจ :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                            //         TextSpan(text: ' ${labResultsData["Breat"]} ครั้ง/นาที',style: TextStyle(fontSize: 17,)),
                                            //       ],
                                            //   ),
                                            // ),                                       
                                          // SizedBox(height: 10,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ListTile(
                                                  leading: Text('ความดันโลหิต :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                  trailing: Text("${labResultsData["BloodPressure"]} mmHg",style: TextStyle(fontSize: 17,)),
                                                ),
                                                // Divider(thickness: 2, color: Colors.grey.shade300,)
                                              ],
                                            ),                                               
                                            // RichText(
                                            //   text: TextSpan(
                                            //     style: TextStyle(color: Colors.black),
                                            //         children: <TextSpan>[
                                            //         TextSpan(text: 'ความดันโลหิต :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                            //         TextSpan(text: ' ${labResultsData["BloodPressure"]} mmHg',style: TextStyle(fontSize: 17,)),
                                            //       ],
                                            //   ),
                                            // ),                                      
                                        //  SizedBox(height: 10,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ListTile(
                                                  leading: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('DTX :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                      Text("(ค่าปริมาณน้ำตาลในกระแสเลือดใน 1 หยด)"),
                                                    ],
                                                  ),
                                                  trailing: Text("${labResultsData["DTX"]} mg%",style: TextStyle(fontSize: 17,)),
                                                ),
                                                // Divider(thickness: 2, color: Colors.grey.shade300,)
                                              ],
                                            ),                                            
                                            // RichText(
                                            //   text: TextSpan(
                                            //     style: TextStyle(color: Colors.black),
                                            //         children: <TextSpan>[
                                            //         TextSpan(text: 'DTX :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                            //         TextSpan(text: ' ${labResultsData["DTX"]} mg%',style: TextStyle(fontSize: 17,)),
                                            //       ],
                                            //   ),
                                            // ),                                      
                                          // Text("(ค่าปริมาณน้ำตาลในกระแสเลือดใน 1 หยด)"),
              SizedBox(height: 40,),
                                            Text('ผลตรวจจากห้องปฏิบัติการ',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),),
              SizedBox(height: 20,),
                                                 ListTile(
                                                  leading: Text('การตรวจ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                                                  trailing: Text("ค่าที่ได้",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),
                                                ),                                                 
                                            Divider(thickness: 2, color: Colors.grey,),                                            
                                            ListTile(
                                              leading: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('FBG/FPG :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                  Text("(ผลการเจาะน้ำตาลหลังอดอาหาร 8 ชม.)"),
                                                ],
                                              ),
                                              trailing: Text("${labResultsData["FBSFPG"]}",style: TextStyle(fontSize: 17,)),
                                            ),
                                         SizedBox(height: 10,),
                                            ListTile(
                                              leading: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('HbA1c :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                  Text("(ค่าน้ำตาลที่สะสมอยู่ในเลือดในระยะเวลา 2-3 เดือน)"),
                                                ],
                                              ),
                                              trailing: Text("${labResultsData["Hb1c"]}",style: TextStyle(fontSize: 17,)),
                                            ),                                         
                                            // RichText(
                                            //   text: TextSpan(
                                            //     style: TextStyle(color: Colors.black),
                                            //         children: <TextSpan>[
                                            //         TextSpan(text: 'HbA1c :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                            //         TextSpan(text: ' ${labResultsData["Hb1c"]}',style: TextStyle(fontSize: 17,)),
                                            //       ],
                                            //   ),
                                            // ),                                      
                                          // Text("(ค่าน้ำตาลที่สะสมอยู่ในเลือดในระยะเวลา 2-3 เดือน)"),
                                         SizedBox(height: 10,),                                            
                                         ListTile(
                                              leading: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('BUN :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                  Text("(ปริมาณไนโตรเจนในกระแสเลือด)"),
                                                ],
                                              ),
                                              trailing: Text("${labResultsData["BUN"]}",style: TextStyle(fontSize: 17,)),
                                            ),  

                                          //   RichText(
                                          //     text: TextSpan(
                                          //       style: TextStyle(color: Colors.black),
                                          //           children: <TextSpan>[
                                          //           TextSpan(text: 'BUN :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                          //           TextSpan(text: ' ${labResultsData["BUN"]}',style: TextStyle(fontSize: 17,)),
                                          //         ],
                                          //     ),
                                          //   ),                                       
                                          // Text("(ปริมาณไนโตรเจนในกระแสเลือด)"),                                       
                                         SizedBox(height: 10,),
                                         ListTile(
                                              leading: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Cr :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                  Text("(ตรวจสอบการทำงานของไต)"),
                                                ],
                                              ),
                                              trailing: Text("${labResultsData["Cr"]}",style: TextStyle(fontSize: 17,)),
                                            ),                                         
                                          //   RichText(
                                          //     text: TextSpan(
                                          //       style: TextStyle(color: Colors.black),
                                          //           children: <TextSpan>[
                                          //           TextSpan(text: 'Cr :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                          //           TextSpan(text: ' ${labResultsData["Cr"]}',style: TextStyle(fontSize: 17,)),
                                          //         ],
                                          //     ),
                                          //   ),                                       
                                          // Text("(ตรวจสอบการทำงานของไต)"),
                                         SizedBox(height: 10,),
                                         ListTile(
                                              leading: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('LDL :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                  Text("(ปริมาณไขมันที่ไม่ดีในร่างกาย)"),
                                                ],
                                              ),
                                              trailing: Text("${labResultsData["LDL"]}",style: TextStyle(fontSize: 17,)),
                                            ),                                              
                                          //   RichText(
                                          //     text: TextSpan(
                                          //       style: TextStyle(color: Colors.black),
                                          //           children: <TextSpan>[
                                          //           TextSpan(text: 'LDL :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                          //           TextSpan(text: ' ${labResultsData["LDL"]}',style: TextStyle(fontSize: 17,)),
                                          //         ],
                                          //     ),
                                          //   ),                                      
                                          // Text("(ปริมาณไขมันที่ไม่ดีในร่างกาย)"), 
                                         SizedBox(height: 10,),
                                         ListTile(
                                              leading: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('HDL :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                  Text("(ปริมาณไขมันที่ดีในร่างกาย)"),
                                                ],
                                              ),
                                              trailing: Text("${labResultsData["HDL"]}",style: TextStyle(fontSize: 17,)),
                                            ),                                            
                                          //   RichText(
                                          //     text: TextSpan(
                                          //       style: TextStyle(color: Colors.black),
                                          //           children: <TextSpan>[
                                          //           TextSpan(text: 'HDL :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                          //           TextSpan(text: ' ${labResultsData["HDL"]}',style: TextStyle(fontSize: 17,)),
                                          //         ],
                                          //     ),
                                          //   ),                                     
                                          // Text("(ปริมาณไขมันที่ดีในร่างกาย)"),
                                         SizedBox(height: 10,),
                                         ListTile(
                                              leading: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Chlo :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                  Text("(ปริมาณคอเลสเตอรอล)"),
                                                ],
                                              ),
                                              trailing: Text("${labResultsData["Chol"]}",style: TextStyle(fontSize: 17,)),
                                            ),                                          
                                          //   RichText(
                                          //     text: TextSpan(
                                          //       style: TextStyle(color: Colors.black),
                                          //           children: <TextSpan>[
                                          //           TextSpan(text: 'Chlo :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                          //           TextSpan(text: ' ${labResultsData["Chol"]}',style: TextStyle(fontSize: 17,)),
                                          //         ],
                                          //     ),
                                          //   ),                                     
                                          // Text("(ปริมาณคอเลสเตอรอล)"), 
                                         SizedBox(height: 10,),
                                         ListTile(
                                              leading: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Tg :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                  Text("(การตรวจไขมันในเลือด)"),
                                                ],
                                              ),
                                              trailing: Text("${labResultsData["Tg"]}",style: TextStyle(fontSize: 17,)),
                                            ),                                            
                                          //   RichText(
                                          //     text: TextSpan(
                                          //       style: TextStyle(color: Colors.black),
                                          //           children: <TextSpan>[
                                          //           TextSpan(text: 'Tg :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                          //           TextSpan(text: ' ${labResultsData["Tg"]}',style: TextStyle(fontSize: 17,)),
                                          //         ],
                                          //     ),
                                          //   ),                                      
                                          // Text("(การตรวจไขมันในเลือด)"),
                                         SizedBox(height: 10,),
                                         ListTile(
                                              leading: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Micro albumin :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                  Text("(โปรตีนในปัสสาวะ)"),
                                                ],
                                              ),
                                              trailing: Text("${labResultsData["Microalbumin"]}",style: TextStyle(fontSize: 17,)),
                                            ),                                           
                                          //   RichText(
                                          //     text: TextSpan(
                                          //       style: TextStyle(color: Colors.black),
                                          //           children: <TextSpan>[
                                          //           TextSpan(text: 'Micro albumin :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                          //           TextSpan(text: ' ${labResultsData["Microalbumin"]}',style: TextStyle(fontSize: 17,)),
                                          //         ],
                                          //     ),
                                          //   ),                                       
                                          // Text("(โปรตีนในปัสสาวะ)"),                                       
                                        //  SizedBox(height: 10,),
                                         ListTile(
                                              leading: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Uric acid :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                  Text("(กรดยูริกในเลือด)"),
                                                ],
                                              ),
                                              trailing: Text("${labResultsData["Uricacid"]}",style: TextStyle(fontSize: 17,)),
                                            ),                                          
                                          //   RichText(
                                          //     text: TextSpan(
                                          //       style: TextStyle(color: Colors.black),
                                          //           children: <TextSpan>[
                                          //           TextSpan(text: 'Uric acid :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                          //           TextSpan(text: ' ${labResultsData["Uricacid"]}',style: TextStyle(fontSize: 17,)),
                                          //         ],
                                          //     ),
                                          //   ),                                      
                                          // Text("(กรดยูริกในเลือด)"),
                                        //  SizedBox(height: 10,),
                                         ListTile(
                                              leading: Text('โปรตีนในปัสสาวะ :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                              trailing: Text("${labResultsData["Proteininurine"]}",style: TextStyle(fontSize: 17,)),
                                            ),                                          
                                            // RichText(
                                            //   text: TextSpan(
                                            //     style: TextStyle(color: Colors.black),
                                            //         children: <TextSpan>[
                                            //         TextSpan(text: 'โปรตีนในปัสสาวะ :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                            //         TextSpan(text: ' ${labResultsData["Proteininurine"]}',style: TextStyle(fontSize: 17,)),
                                            //       ],
                                            //   ),
                                            // ),                                      
                                        //  SizedBox(height: 10,),
                                         ListTile(
                                              leading: Text('การตรวจตา :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                              trailing: Text("${labResultsData["Eyetest"]}",style: TextStyle(fontSize: 17,)),
                                            ),                                           
                                            // RichText(
                                            //   text: TextSpan(
                                            //     style: TextStyle(color: Colors.black),
                                            //         children: <TextSpan>[
                                            //         TextSpan(text: 'การตรวจตา :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                            //         TextSpan(text: ' ${labResultsData["Eyetest"]}',style: TextStyle(fontSize: 17,)),
                                            //       ],
                                            //   ),
                                            // ), 
                                        //  SizedBox(height: 10,),
                                         ListTile(
                                              leading: Text('บันทึกเมื่อวันที่ :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                              trailing: Text("${convertDateTimeDisplay(
                                                              labResultsData["creatAt"].toDate().toString())}",style: TextStyle(fontSize: 17,)),
                                            ),
                                          SizedBox(height: 20,),                                            
                                            // RichText(
                                            //   text: TextSpan(
                                            //     style: TextStyle(color: Colors.black),
                                            //         children: <TextSpan>[
                                            //         TextSpan(text: 'บันทึกเมื่อวันที่ :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                                            //         TextSpan(text: ' ${convertDateTimeDisplay(
                                            //                   labResultsData["creatAt"].toDate().toString())}',style: TextStyle(fontSize: 17,)),
                                            //       ],
                                            //   ),
                                            // ),                                         
                      // Text("น้ำหนักของผู้ป่วย:  ${labResultsData["Weight"]} KG."),
                      // Text("ส่วนสูงของผู้ป่วย:  ${labResultsData["Height"]} CM."),
                      // Text("รอบเอวของผู้ป่วย:  ${labResultsData["Waistline"]} CM."),
                      // Text("ค่า BMI ของผู้ป่วย:  ${labResultsData["Bmi"]}"),
                      // Text(
                      //     "ตรวจชีพจรณ์(ครั่ง/ต่อนาที):  ${labResultsData["Pulse"]} KG."),
                      // Text(
                      //     "ตรวจการหายใจ(ครั่ง/ต่อนาที):  ${labResultsData["Breat"]} CM."),
                      // Text(
                      //     "ความดันโลหิต(mmHg/ต่อนาที):  ${labResultsData["BloodPressure"]}"),
                      // Text("DTX:  ${labResultsData["DTX"]}"),
                      // Text("FBSFPG:  ${labResultsData["FBSFPG"]}"),
                      // Text("Hb1c:  ${labResultsData["Hb1c"]}"),
                      // Text("BUN:  ${labResultsData["BUN"]}"),
                      // Text("Cr:  ${labResultsData["Cr"]}"),
                      // Text("LDL:  ${labResultsData["LDL"]}"),
                      // Text("HDL:  ${labResultsData["HDL"]}"),
                      // Text("Chol:  ${labResultsData["Chol"]}"),
                      // Text("Microalbumin:  ${labResultsData["Microalbumin"]}"),
                      // Text("Proteininurine:  ${labResultsData["Proteininurine"]}"),
                      // Text("Eyetest:  ${labResultsData["Eyetest"]}"),
                      // Text("Tg:  ${labResultsData["Tg"]}"),
                      // Text(
                      //   "บันทึกเมื่อวันที่: " +
                      //       convertDateTimeDisplay(
                      //           labResultsData["creatAt"].toDate().toString()),
                      // ),
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
