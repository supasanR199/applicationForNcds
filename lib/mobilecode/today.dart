import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time/date_time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../models/dairymodel.dart';
import 'function/datethai.dart';
import 'models/patiendata.dart';


class EmotionData extends StatefulWidget {
  var patienId;
  EmotionData({Key key, @required this.patienId}) : super(key: key);
  @override
  _EmotionDataState createState() => _EmotionDataState();
}

class _EmotionDataState extends State<EmotionData> {

  // DateTime date;
  final formkey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  PatienData data = PatienData();
  List<DairyModel> dairyModel = [];
  DateRangePickerController _datePickerController = DateRangePickerController();
  var choice = null;
  var date ;
  String getText() {
    if (date == null) {
      return 'เลือกวันเกิด';
    } 
    else {
      return DateFormat('dd/MM/yyyy').format(date);
    //   // return '${date.month}/${date.day}/${date.year}';
}
  }
   List<ValueData> _chartAllEmotionData;
   List<EmotionSleepData> _chartSleepData;
   List<EmotionMeditateData> _chartMeditateData;
   List<EmotionIrritableData> _chartIrritableData;
   List<EmotionBoringData> _chartBoringData;
   List<EmotionAloneData> _chartAloneData;
    showlegend(){
    if (data.Totalmood[0] == 0 && data.Totalmood[1] == 0 && data.Totalmood[2] == 0 && data.Totalmood[3] == 0) {
      return false;
    } else {
      return true;
    }
  }
  percent(var num1,num2){
    var percent;
    percent = (num1*100)/num2;
    return percent;
  }
  @override
  void initState() {
    showdata();
    super.initState();
  }
  Future<void> showdata()async{
    // await FirebaseAuth.instance.authStateChanges().listen((event) async{ 
    //   var uid = event.uid ;
      await FirebaseFirestore.instance.collection('MobileUser').doc(widget.patienId.id).collection("diary").get().then((value){
        for (var i in value.docs) {
          DairyModel model = DairyModel.fromMap(i.data());
          setState(() {
            dairyModel.add(model);
          });
        }
        // print("## ${data.EndDate}");
        // print("## ${sumfat}");

      });
    // });
  } 

  @override
  Widget build(BuildContext context) {
         return Scaffold(
           body: SingleChildScrollView(
             child: Center(
               child: Container(
                 width: 800,
                 child: Column(
                   children: <Widget>[
                     SizedBox(height: 20,),
                     Container(
                       padding: EdgeInsets.symmetric(horizontal: 10),
                       child: Card(
                         child: Column(
                           children: [
                    SizedBox(height: 15,),
                     Text("สภาพอารมณ์",          
                     style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center
                      ),
                      Text("ประวัติบันทึกอารมณ์ประจำวัน"),
                      // SizedBox(height: 20,),
                      Container(
                        // height: 220,
                        child: SfCircularChart(
                                              // title: ChartTitle(text: "อารมณ์ทั้งหมด",textStyle: TextStyle(fontWeight: FontWeight.bold)),
                                                    legend:Legend(isVisible: true,title: LegendTitle(text:"ระดับอารมณ์",textStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),position: LegendPosition.right),
                                                    tooltipBehavior: TooltipBehavior(enable: false),
                                                    palette: <Color>[Colors.green.shade300, Colors.yellow.shade300, Colors.orange.shade300 ,Colors.red.shade400,],
                                                    series: <CircularSeries>[
                                                      DoughnutSeries<ValueData, String>(
                                                          dataSource: [
                                                          ValueData('เครียดน้อย', data.Totalmood[0],"${percent(data.Totalmood[0],data.totalday).toStringAsFixed(1)} %"),
                                                          ValueData('เครียดปานกลาง', data.Totalmood[1],"${percent(data.Totalmood[1],data.totalday).toStringAsFixed(1)} %"),
                                                          ValueData('เครียดมาก', data.Totalmood[2],"${percent(data.Totalmood[2],data.totalday).toStringAsFixed(1)} %"),
                                                          ValueData('เครียดมากที่สุด', data.Totalmood[3],"${percent(data.Totalmood[3],data.totalday).toStringAsFixed(1)} %"),
                                                        ],
                                                          xValueMapper: (ValueData data, _) => data.continentAllFood,
                                                          yValueMapper: (ValueData data, _) => data.value,
                                                          dataLabelMapper: (ValueData data, _) => data.label,
                                                          dataLabelSettings: DataLabelSettings(isVisible: showlegend(),
                                                          // labelPosition: ChartDataLabelPosition.outside
                                                          ),
                                                          enableTooltip: true,
                                                        )
                                                    ],
                                                  ),
                      ),                  
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 50,
                            onPressed: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                    AlertDialog(
                                    actions: <Widget>[
                                      StreamBuilder<QuerySnapshot>(
                                                                                  stream: FirebaseFirestore.instance.collection("MobileUser").doc(widget.patienId.id).collection("diary").limit(1).snapshots(),
                                                                                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                                             if (snapshot.hasError) {
                                                                                              print(snapshot.error);
                                                                                              return Center(child: CircularProgressIndicator());
                                                                                            }
                                                                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                                  return Center(child: CircularProgressIndicator());
                                                                                                }
                                                                                            if(snapshot.data.docs.isEmpty){
                                                                                              return Container(
                                                                                                    height: 150,
                                                                                                    width: 250,
                                                                                                    child: Column(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [
                                                                                                      Text('ไม่มีข้อมูล',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,)),
                                                                                                      SizedBox(height: 5,),
                                                                                                      Text('ยังไม่เคยมีการบันทึกข้อมูล',style: TextStyle(fontSize: 18,)),
                                                                                                      SizedBox(height: 15,),
                                                                                                          MaterialButton(
                                                                                                            minWidth: 140,
                                                                                                            height: 40,
                                                                                                            onPressed: (){
                                                                                                               Navigator.pop(context);
                                                                                                            },
                                                                                                            color: Colors.blueAccent,
                                                                                                            shape: RoundedRectangleBorder(
                                                                                                                borderRadius: BorderRadius.circular(20)),
                                                                                                            child: Text(
                                                                                                              "ตกลง",
                                                                                                              style: TextStyle(
                                                                                                                  color: Colors.white,
                                                                                                                  fontWeight: FontWeight.w600,
                                                                                                                  fontSize: 18),
                                                                                                            ),
                                                                                                          ),
                                                                                                      ],
                                                                                                    ),
                                                                                              );
                                                                                            }
                                                                                    return
                                        Container(
                                          child: Column(children: <Widget>[
                                          Column(
                                                children: <Widget>[
                                                  Center(child: Column(children: [
                                                  SizedBox(height: 20,),                  
                                                  Text(
                                                    "เลือกช่วงเวลา",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
                                                  SizedBox(height: 20,),
                                                                 Column(
                                                                                      children:
                                                                                          snapshot.data.docs.map((DocumentSnapshot document) {
                                                                                        Map<String, dynamic> snap = document.data() as Map<String, dynamic>;
                                                                                        return SizedBox(
                                                                                                height: 300,
                                                                                                width: 450,
                                                                                                child:   SafeArea(
                                                                                                        child: Scaffold(
                                                                                                      body: SingleChildScrollView(
                                                                                                        child: SfDateRangePicker(                                                                                                                                                             selectionColor: Colors.pink.shade300,
                                                                                                          endRangeSelectionColor: Colors.blueAccent,
                                                                                                          startRangeSelectionColor: Colors.blueAccent,
                                                                                                          rangeSelectionColor: Colors.blueAccent.shade100,
                                                                                                          todayHighlightColor: Colors.blueAccent,
                                                                                                          view: DateRangePickerView.month,
                                                                                                          minDate: DateTime.parse(document.id),
                                                                                                          maxDate: DateTime.now(),
                                                                                                          monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: DateTime.sunday),
                                                                                                          selectionMode: DateRangePickerSelectionMode.range,
                                                                                                          onSelectionChanged: _onSelectionChanged,
                                                                                                          showActionButtons: true,
                                                                                                          controller: _datePickerController,
                                                                                                          onSubmit: (var val) {
                                                                                                          var dateter = val ;
                                                                                                          List<num> MoodChoice1 = [0,0,0,0];
                                                                                                          List<num> MoodChoice2 = [0,0,0,0];
                                                                                                          List<num> MoodChoice3 = [0,0,0,0];
                                                                                                          List<num> MoodChoice4 = [0,0,0,0];
                                                                                                          List<num> MoodChoice5 = [0,0,0,0];
                                                                                                          List<num> MoodTotal = [0,0,0,0];
                                                                                                          var countDate = 0;
                                                                                                          var EndDate;
                                                                                                          setState(() {
                                                                                                            var StartDate = DateTime.parse(_datePickerController.selectedRange.startDate.toString());
                                                                                                                  if (_datePickerController.selectedRange?.endDate == null) {
                                                                                                                        EndDate = DateTime.parse(_datePickerController.selectedRange.startDate.toString());
                                                                                                                    }else{
                                                                                                                        EndDate = DateTime.parse(_datePickerController.selectedRange.endDate.toString());
                                                                                                                    }  
                                                                                                            // if (_datePickerController.selectedRanges!.last.endDate != null) {
                                                                                                            //    EndDate = DateTime.parse(_datePickerController.selectedRanges!.last.endDate.toString());
                                                                                                            // }
                                                                                                            data.Difference = num.parse(StartDate.difference(EndDate).inDays.toString()).abs(); 
                                                                                                            data.StartDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(StartDate.toString()));
                                                                                                            data.EndDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(EndDate.toString())); 
                                                                                                            });
                                                                                                            print(data.Difference);
                                                                                                            print(data.StartDate);
                                                                                                            print(data.EndDate);
                                                                                                                    for (var i = 0; i < dairyModel.length; i++) {
                                                                                                                           for (var c = 0; c <= data.Difference ; c++) { //นำส่วนต่างมากำหนดลูป
                                                                                                                                var NowDate = DateFormat('yyyy-MM-dd').format(DateTime.parse("${data.EndDate}").subtract(Duration(days:c))).toString(); //เริ่มนับถอยหลัง
                                                                                                                                print("## ${NowDate}");
                                                                                                                                     if (dairyModel[i].date == NowDate && dairyModel[i].Totalmood != "null") { //ถ้าถอยหลังแล้วเจอ
                                                                                                                                       if (dairyModel[i].mood1 == "0") {
                                                                                                                                          MoodChoice1[0] += 1;
                                                                                                                                        }else if (dairyModel[i].mood1 == "1"){
                                                                                                                                          MoodChoice1[1] += 1;
                                                                                                                                        }else if (dairyModel[i].mood1 == "2"){
                                                                                                                                          MoodChoice1[2] += 1;
                                                                                                                                        }else if (dairyModel[i].mood1 == "3"){
                                                                                                                                          MoodChoice1[3] += 1;
                                                                                                                                        }

                                                                                                                                       if (dairyModel[i].mood2 == "0") {
                                                                                                                                          MoodChoice2[0] += 1;
                                                                                                                                        }else if (dairyModel[i].mood2 == "1"){
                                                                                                                                          MoodChoice2[1] += 1;
                                                                                                                                        }else if (dairyModel[i].mood2 == "2"){
                                                                                                                                          MoodChoice2[2] += 1;
                                                                                                                                        }else if (dairyModel[i].mood2 == "3"){
                                                                                                                                          MoodChoice2[3] += 1;
                                                                                                                                        }

                                                                                                                                       if (dairyModel[i].mood3 == "0") {
                                                                                                                                          MoodChoice3[0] += 1;
                                                                                                                                        }else if (dairyModel[i].mood3 == "1"){
                                                                                                                                          MoodChoice3[1] += 1;
                                                                                                                                        }else if (dairyModel[i].mood3 == "2"){
                                                                                                                                          MoodChoice3[2] += 1;
                                                                                                                                        }else if (dairyModel[i].mood3 == "3"){
                                                                                                                                          MoodChoice3[3] += 1;
                                                                                                                                        }

                                                                                                                                       if (dairyModel[i].mood4 == "0") {
                                                                                                                                          MoodChoice4[0] += 1;
                                                                                                                                        }else if (dairyModel[i].mood4 == "1"){
                                                                                                                                          MoodChoice4[1] += 1;
                                                                                                                                        }else if (dairyModel[i].mood4 == "2"){
                                                                                                                                          MoodChoice4[2] += 1;
                                                                                                                                        }else if (dairyModel[i].mood4 == "3"){
                                                                                                                                          MoodChoice4[3] += 1;
                                                                                                                                        }

                                                                                                                                       if (dairyModel[i].mood5 == "0") {
                                                                                                                                          MoodChoice5[0] += 1;
                                                                                                                                        }else if (dairyModel[i].mood5 == "1"){
                                                                                                                                          MoodChoice5[1] += 1;
                                                                                                                                        }else if (dairyModel[i].mood5 == "2"){
                                                                                                                                          MoodChoice5[2] += 1;
                                                                                                                                        }else if (dairyModel[i].mood5 == "3"){
                                                                                                                                          MoodChoice5[3] += 1;
                                                                                                                                        }

                                                                                                                                        if (dairyModel[i].Totalmood != "null") {
                                                                                                                                          if (num.parse(dairyModel[i].Totalmood) <= 4) {
                                                                                                                                            MoodTotal[0] += 1;
                                                                                                                                          } else if (num.parse(dairyModel[i].Totalmood) <= 7 && num.parse(dairyModel[i].Totalmood) >= 5) {
                                                                                                                                            MoodTotal[1] += 1;
                                                                                                                                          } else if (num.parse(dairyModel[i].Totalmood) <= 9 && num.parse(dairyModel[i].Totalmood) >= 8) {
                                                                                                                                            MoodTotal[2] += 1;
                                                                                                                                          } else if (num.parse(dairyModel[i].Totalmood) >= 10 ){
                                                                                                                                            MoodTotal[3] += 1;
                                                                                                                                          }
                                                                                                                                        }
                                                                                                                                        countDate ++ ;
                                                                                                                                       }
                                                                                                                                                  setState(() {
                                                                                                                                                  data.mood1 = MoodChoice1;
                                                                                                                                                  data.mood2 = MoodChoice2;
                                                                                                                                                  data.mood3 = MoodChoice3;
                                                                                                                                                  data.mood4 = MoodChoice4;
                                                                                                                                                  data.mood5 = MoodChoice5;
                                                                                                                                                  data.Totalmood = MoodTotal ;
                                                                                                                                                  data.totalday = countDate;
                                                                                                                                                                  });                           
                                                                                                                                                                  }
                                                                                                                                                  }
                                           
                                                                                                          print("## ${data.fatchoice1}");
                                                                                                          print("##1 ${data.mood1}");
                                                                                                          print("##2 ${data.mood2}");
                                                                                                          print("##3 ${data.mood3}");
                                                                                                          print("##4 ${data.mood4}");
                                                                                                          print("##5 ${data.mood5}");
                                                                                                          print("##5 ${data.Totalmood}");
                                                                                                          print("ช่วงวันที่ ${data.StartDate} ถึง ${data.EndDate}");
                                                                                                          print("วันที่มีข้อมูล ${data.totalday}");             
                                                                                                          Navigator.pop(context);
                                                                                                          },
                                                                                                          onCancel: () {
                                                                                                            _datePickerController.selectedRanges = null;
                                                                                                          },
                                                                                                        ),
                                                                                                      ),
                                                                                                    )),
                                                                                              );
                                                                                                              
                                                                                      }).toList(),
                                                                                    )
                                                                                  //
                                                                                ],)),
                                                                                    ],
                                                                                  ),
                                                                            ],),);
                                                                            },),     
                                                                        ],
                                                                        shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(20)),
                                                                        )
                                                                      );
                                                                      },
                                                                      // defining the shape
                                                                      hoverColor: Colors.grey.shade200,
                                                                      color: Colors.blueAccent,
                                                                      shape: RoundedRectangleBorder(
                                                                          // side: BorderSide(color: Colors.blue.shade200),
                                                                          borderRadius: BorderRadius.circular(20)),
                                                                      child: Text(
                                                                        "เลือกช่วงเวลา",
                                                                        style:
                                                                            TextStyle(fontWeight: FontWeight.w600, fontSize: 20,color: Colors.white,),
                                                                      ),
                                                                    ),
                        ),
                        SizedBox(height: 10,)
                           ],
                         ),
                                                  shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20)),
                       ),
                     ),       

                                  // Column(
                                  //                 children: [ if ("${data.StartDate}" != "null" && "${data.EndDate}" != "null") ...[
                                  //                   Card(child: Container(
                                  //                   padding: EdgeInsets.symmetric(horizontal: 70,vertical: 15),
                                  //                   child:
                                  //                         Column(
                                  //                           children: [
                                  //                                   Text("ช่วงวันที่ ${data.StartDate} ถึง ${data.EndDate}",style:TextStyle(fontWeight: FontWeight.bold)),
                                  //                                   Text("มีการบันทึกข้อมูล ${data.totalday} วัน",style:TextStyle(fontWeight: FontWeight.bold)),   
                                  //                           ],
                                  //                         ),),
                                  //                   shape: RoundedRectangleBorder(
                                  //                   borderRadius: BorderRadius.circular(20)),
                                                        
                                  //                     ),
                                  //                 ] 
                                  //                 ],
                                  //               ),
           
           
                                        
                                        Container(
                                         padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          child: Card(
                                            child: Column(
                                              children: [
                                                  const SizedBox(height: 10,),
                                                  const Text("ปัญหาการนอน",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                                  const SizedBox(height: 5,),
                                                  Column(
                                                    children: [
                                                      if(data.totalday > 0)...[
                                                            const SizedBox(height: 10,),
                                                            Text("จากการเลือกวันที่ ${DateThai(data.StartDate)} ถึงวันที่ ${DateThai(data.EndDate)}"),
                                                            Text("จำนวนวันที่มีการบันทึก ${data.totalday} วัน"),
                                                            const SizedBox(height: 10,),
                                                      ]
                                                    ]),                                           
                                                SfCartesianChart(
                                                    // title: ChartTitle(text: 'ปัญหาการนอน'),
                                                    legend: Legend(isVisible: false),
                                                    tooltipBehavior: TooltipBehavior(enable: true),
                                                    series: <ChartSeries>[
                                                      ColumnSeries<EmotionSleepData, String>(
                                                          dataSource: [
                                                                        EmotionSleepData('น้อย', data.mood1[0] ,Colors.blue.shade200,"${data.mood1[0]} วัน"),
                                                                        EmotionSleepData('ปานกลาง', data.mood1[1],Colors.blue.shade400,"${data.mood1[1]} วัน"),
                                                                        EmotionSleepData('มาก', data.mood1[2],Colors.blue.shade600,"${data.mood1[2]} วัน"),
                                                                        EmotionSleepData('มากที่สุด', data.mood1[3],Colors.blue.shade800,"${data.mood1[3]} วัน"),
                                                                      ],
                                                          xValueMapper: (EmotionSleepData val, _) => val.continent,
                                                          yValueMapper: (EmotionSleepData val, _) => val.val,
                                                          dataLabelMapper: (EmotionSleepData data, _) => data.label,
                                                          dataLabelSettings: DataLabelSettings(isVisible: true),
                                                          pointColorMapper: (EmotionSleepData data, _) => data.color
                                                          // enableTooltip: true
                                                          )
                                                    ],
                                                    primaryXAxis: CategoryAxis(),
                                                    primaryYAxis: NumericAxis(
                                                        // edgeLabelPlacement: EdgeLabelPlacement.shift,
                                                        decimalPlaces: 0,
                                                        // rangePadding: ChartRangePadding.none,
                                                        title: AxisTitle(text: 'จำนวนวัน')
                                                        ),
                                                  ),
                                                      Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                                        child: Column(
                                                              children: [
                                                                if(data.totalday > 0)...[
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  const SizedBox(height: 10,),
                                                                  Center(child: const Text("สรุป ปัญหาการนอน",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                                                                  const SizedBox(height: 15,),
                                                                  ListTile(
                                                                    leading: Text('ระดับ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("วัน",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),
                                                                        ),
                                                                  Divider(thickness: 2, color: Colors.grey,), 
                                                                  ListTile(
                                                                    leading: Text('น้อย :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood1[0]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  ListTile(
                                                                    leading: Text('ปานกลาง :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood1[1]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  ListTile(
                                                                    leading: Text('มาก :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood1[2]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  ListTile(
                                                                    leading: Text('มากที่สุด :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood1[3]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  SizedBox(height: 20,)
                                                                  // Divider(thickness: 2, color: Colors.grey.shade300,)
                                                                ],
                                                              ), 
                                                                ]
                                                              ],
                                                            ),
                                                      ),                                                  
                                              ],
                                            ),
                                                  shape: RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.circular(20)),
                                          ),
                                        ),


                                        Container(
                                         padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          child: Card(
                                            child: Column(
                                              children: [
                                                  const SizedBox(height: 10,),
                                                  const Text("สมาธิน้อยลง",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                                  const SizedBox(height: 5,),
                                                  Column(
                                                    children: [
                                                      if(data.totalday > 0)...[
                                                            const SizedBox(height: 10,),
                                                            Text("จากการเลือกวันที่ ${DateThai(data.StartDate)} ถึงวันที่ ${DateThai(data.EndDate)}"),
                                                            Text("จำนวนวันที่มีการบันทึก ${data.totalday} วัน"),
                                                            const SizedBox(height: 10,),
                                                      ]
                                                    ]),                                              
                                                SfCartesianChart(
                                                    // title: ChartTitle(text: 'สมาธิน้อยลง'),
                                                    legend: Legend(isVisible: false),
                                                    tooltipBehavior: TooltipBehavior(enable: true),
                                                    series: <ChartSeries>[
                                                      ColumnSeries<EmotionMeditateData, String>(
                                                          dataSource: [
                                                                      EmotionMeditateData('น้อย', data.mood2[0] ,Colors.yellow.shade200,"${data.mood2[0]} วัน"),
                                                                      EmotionMeditateData('ปานกลาง', data.mood2[1],Colors.yellow.shade400,"${data.mood2[1]} วัน"),
                                                                      EmotionMeditateData('มาก', data.mood2[2],Colors.yellow.shade600,"${data.mood2[2]} วัน"),
                                                                      EmotionMeditateData('มากที่สุด', data.mood2[3],Colors.yellow.shade800,"${data.mood2[3]} วัน"),
                                                                      ],
                                                          xValueMapper: (EmotionMeditateData val, _) => val.continent,
                                                          yValueMapper: (EmotionMeditateData val, _) => val.val,
                                                          dataLabelMapper: (EmotionMeditateData data, _) => data.label,
                                                          dataLabelSettings: DataLabelSettings(isVisible: true),
                                                          pointColorMapper: (EmotionMeditateData data, _) => data.color
                                                          // enableTooltip: true
                                                          )
                                                    ],
                                                    primaryXAxis: CategoryAxis(),
                                                    primaryYAxis: NumericAxis(
                                                        // edgeLabelPlacement: EdgeLabelPlacement.shift,
                                                        decimalPlaces: 0,
                                                        // rangePadding: ChartRangePadding.none,
                                                        title: AxisTitle(text: 'จำนวนวัน')
                                                        ),
                                                  ),
                                                      Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                                        child: Column(
                                                              children: [
                                                                if(data.totalday > 0)...[
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  const SizedBox(height: 10,),
                                                                  Center(child: const Text("สรุป สมาธิน้อยลง",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                                                                  const SizedBox(height: 15,),
                                                                  ListTile(
                                                                    leading: Text('ระดับ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("วัน",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),
                                                                        ),
                                                                  Divider(thickness: 2, color: Colors.grey,), 
                                                                  ListTile(
                                                                    leading: Text('น้อย :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood2[0]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  ListTile(
                                                                    leading: Text('ปานกลาง :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood2[1]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  ListTile(
                                                                    leading: Text('มาก :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood2[2]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  ListTile(
                                                                    leading: Text('มากที่สุด :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood2[3]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  SizedBox(height: 20,)
                                                                  // Divider(thickness: 2, color: Colors.grey.shade300,)
                                                                ],
                                                              ), 
                                                                ]
                                                              ],
                                                            ),
                                                      ),                                                     
                                              ],
                                            ),
                                                  shape: RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.circular(20)),
                                          ),
                                        ),


                                        Container(
                                         padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          child: Card(
                                            child: Column(
                                              children: [
                                                  const SizedBox(height: 10,),
                                                  const Text("หงุดหงิดง่าย",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                                  const SizedBox(height: 5,),
                                                  Column(
                                                    children: [
                                                      if(data.totalday > 0)...[
                                                            const SizedBox(height: 10,),
                                                            Text("จากการเลือกวันที่ ${DateThai(data.StartDate)} ถึงวันที่ ${DateThai(data.EndDate)}"),
                                                            Text("จำนวนวันที่มีการบันทึก ${data.totalday} วัน"),
                                                            const SizedBox(height: 10,),
                                                      ]
                                                    ]),                                             
                                                SfCartesianChart(
                                                    // title: ChartTitle(text: 'หงุดหงิดง่าย'),
                                                    legend: Legend(isVisible: false),
                                                    tooltipBehavior: TooltipBehavior(enable: true),
                                                    series: <ChartSeries>[
                                                      ColumnSeries<EmotionIrritableData, String>(
                                                          dataSource: [
                                                                      EmotionIrritableData('น้อย', data.mood3[0] ,Colors.red.shade200,"${data.mood3[0]} วัน"),
                                                                      EmotionIrritableData('ปานกลาง', data.mood3[1],Colors.red.shade400,"${data.mood3[1]} วัน"),
                                                                      EmotionIrritableData('มาก', data.mood3[2],Colors.red.shade600,"${data.mood3[2]} วัน"),
                                                                      EmotionIrritableData('มากที่สุด', data.mood3[3],Colors.red.shade800,"${data.mood3[3]} วัน"),
                                                                      ],
                                                          xValueMapper: (EmotionIrritableData val, _) => val.continent,
                                                          yValueMapper: (EmotionIrritableData val, _) => val.val,
                                                          dataLabelMapper: (EmotionIrritableData data, _) => data.label,
                                                          dataLabelSettings: DataLabelSettings(isVisible: true),
                                                          pointColorMapper: (EmotionIrritableData data, _) => data.color
                                                          // enableTooltip: true
                                                          )
                                                    ],
                                                    primaryXAxis: CategoryAxis(),
                                                    primaryYAxis: NumericAxis(
                                                        // edgeLabelPlacement: EdgeLabelPlacement.shift,
                                                        decimalPlaces: 0,
                                                        // rangePadding: ChartRangePadding.none,
                                                        title: AxisTitle(text: 'จำนวนวัน')
                                                        ),
                                                  ),
                                                      Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                                        child: Column(
                                                              children: [
                                                                if(data.totalday > 0)...[
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  const SizedBox(height: 10,),
                                                                  Center(child: const Text("สรุป หงุดหงิดง่าย",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                                                                  const SizedBox(height: 15,),
                                                                  ListTile(
                                                                    leading: Text('ระดับ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("วัน",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),
                                                                        ),
                                                                  Divider(thickness: 2, color: Colors.grey,), 
                                                                  ListTile(
                                                                    leading: Text('น้อย :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood3[0]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  ListTile(
                                                                    leading: Text('ปานกลาง :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood3[1]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  ListTile(
                                                                    leading: Text('มาก :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood3[2]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  ListTile(
                                                                    leading: Text('มากที่สุด :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood3[3]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  SizedBox(height: 20,)
                                                                  // Divider(thickness: 2, color: Colors.grey.shade300,)
                                                                ],
                                                              ), 
                                                                ]
                                                              ],
                                                            ),
                                                      ),                                                     
                                              ],
                                            ),
                                                  shape: RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.circular(20)),
                                          ),
                                        ),

                                        Container(
                                         padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          child: Card(
                                            child: Column(
                                              children: [
                                                  const SizedBox(height: 10,),
                                                  const Text("เบื่อเซ็ง",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                                  const SizedBox(height: 5,),
                                                  Column(
                                                    children: [
                                                      if(data.totalday > 0)...[
                                                            const SizedBox(height: 10,),
                                                            Text("จากการเลือกวันที่ ${DateThai(data.StartDate)} ถึงวันที่ ${DateThai(data.EndDate)}"),
                                                            Text("จำนวนวันที่มีการบันทึก ${data.totalday} วัน"),
                                                            const SizedBox(height: 10,),
                                                      ]
                                                    ]),                                              
                                                SfCartesianChart(
                                                    // title: ChartTitle(text: 'เบื่อเซ็ง'),
                                                    legend: Legend(isVisible: false),
                                                    tooltipBehavior: TooltipBehavior(enable: true),
                                                    series: <ChartSeries>[
                                                      ColumnSeries<EmotionBoringData, String>(
                                                          dataSource: [
                                                                      EmotionBoringData('น้อย', data.mood4[0] ,Colors.grey.shade200,"${data.mood4[0]} วัน"),
                                                                      EmotionBoringData('ปานกลาง', data.mood4[1],Colors.grey.shade400,"${data.mood4[1]} วัน"),
                                                                      EmotionBoringData('มาก', data.mood4[2],Colors.grey.shade600,"${data.mood4[2]} วัน"),
                                                                      EmotionBoringData('มากที่สุด', data.mood4[3],Colors.grey.shade800,"${data.mood4[3]} วัน"),
                                                                      ],
                                                          xValueMapper: (EmotionBoringData val, _) => val.continent,
                                                          yValueMapper: (EmotionBoringData val, _) => val.val,
                                                          dataLabelMapper: (EmotionBoringData data, _) => data.label,
                                                          dataLabelSettings: DataLabelSettings(isVisible: true),
                                                          pointColorMapper: (EmotionBoringData data, _) => data.color
                                                          // enableTooltip: true
                                                          )
                                                    ],
                                                    primaryXAxis: CategoryAxis(),
                                                    primaryYAxis: NumericAxis(
                                                        // edgeLabelPlacement: EdgeLabelPlacement.shift,
                                                        decimalPlaces: 0,
                                                        // rangePadding: ChartRangePadding.none,
                                                        title: AxisTitle(text: 'จำนวนวัน')
                                                        ),
                                                  ),
                                                      Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                                        child: Column(
                                                              children: [
                                                                if(data.totalday > 0)...[
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  const SizedBox(height: 10,),
                                                                  Center(child: const Text("สรุป เบื่อเซ็ง",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                                                                  const SizedBox(height: 15,),
                                                                  ListTile(
                                                                    leading: Text('ระดับ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("วัน",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),
                                                                        ),
                                                                  Divider(thickness: 2, color: Colors.grey,), 
                                                                  ListTile(
                                                                    leading: Text('น้อย :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood4[0]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  ListTile(
                                                                    leading: Text('ปานกลาง :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood4[1]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  ListTile(
                                                                    leading: Text('มาก :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood4[2]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  ListTile(
                                                                    leading: Text('มากที่สุด :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood4[3]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  SizedBox(height: 20,)
                                                                  // Divider(thickness: 2, color: Colors.grey.shade300,)
                                                                ],
                                                              ), 
                                                                ]
                                                              ],
                                                            ),
                                                      ),                                                     
                                              ],
                                            ),
                                                  shape: RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.circular(20)),
                                          ),
                                        ),

                                        Container(
                                         padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          child: Card(
                                            child: Column(
                                              children: [
                                                  const SizedBox(height: 10,),
                                                  const Text("ไม่อยากพบผู้คน",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                                  const SizedBox(height: 5,),
                                                  Column(
                                                    children: [
                                                      if(data.totalday > 0)...[
                                                            const SizedBox(height: 10,),
                                                            Text("จากการเลือกวันที่ ${DateThai(data.StartDate)} ถึงวันที่ ${DateThai(data.EndDate)}"),
                                                            Text("จำนวนวันที่มีการบันทีก ${data.totalday} วัน"),
                                                            const SizedBox(height: 10,),
                                                      ]
                                                    ]),                                            
                                                SfCartesianChart(
                                                    // title: ChartTitle(text: 'ไม่อยากพบผู้คน'),
                                                    legend: Legend(isVisible: false),
                                                    tooltipBehavior: TooltipBehavior(enable: true),
                                                    series: <ChartSeries>[
                                                      ColumnSeries<EmotionAloneData, String>(
                                                          dataSource: [
                                                                      EmotionAloneData('น้อย', data.mood5[0] ,Colors.purple.shade200,"${data.mood5[0]} วัน"),
                                                                      EmotionAloneData('ปานกลาง', data.mood5[1],Colors.purple.shade400,"${data.mood5[1]} วัน"),
                                                                      EmotionAloneData('มาก', data.mood5[2],Colors.purple.shade600,"${data.mood5[2]} วัน"),
                                                                      EmotionAloneData('มากที่สุด', data.mood5[3],Colors.purple.shade800,"${data.mood5[3]} วัน"),
                                                                      ],
                                                          xValueMapper: (EmotionAloneData val, _) => val.continent,
                                                          yValueMapper: (EmotionAloneData val, _) => val.val,
                                                          dataLabelMapper: (EmotionAloneData data, _) => data.label,
                                                          dataLabelSettings: DataLabelSettings(isVisible: true),
                                                          pointColorMapper: (EmotionAloneData data, _) => data.color
                                                          // enableTooltip: true
                                                          )
                                                    ],
                                                    primaryXAxis: CategoryAxis(),
                                                primaryYAxis: NumericAxis(
                                                    // edgeLabelPlacement: EdgeLabelPlacement.shift,
                                                    decimalPlaces: 0,
                                                    // rangePadding: ChartRangePadding.none,
                                                    title: AxisTitle(text: 'จำนวนวัน')
                                                    ),
                                                  ),
                                                      Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                                        child: Column(
                                                              children: [
                                                                if(data.totalday > 0)...[
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  const SizedBox(height: 10,),
                                                                  Center(child: const Text("สรุป ไม่อยากพบผู้คน",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                                                                  const SizedBox(height: 15,),
                                                                  ListTile(
                                                                    leading: Text('ระดับ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("วัน",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),
                                                                        ),
                                                                  Divider(thickness: 2, color: Colors.grey,), 
                                                                  ListTile(
                                                                    leading: Text('น้อย :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood5[0]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  ListTile(
                                                                    leading: Text('ปานกลาง :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood5[1]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  ListTile(
                                                                    leading: Text('มาก :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood5[2]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  ListTile(
                                                                    leading: Text('มากที่สุด :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                                                    trailing: Text("${data.mood5[3]}",style: TextStyle(fontSize: 17,)),
                                                                  ),
                                                                  // Divider(thickness: 2, color: Colors.grey.shade300,)
                                                                  SizedBox(height: 20,)
                                                                ],
                                                              ), 
                                                                ]
                                                              ],
                                                            ),
                                                      ),                                                     
                                              ],
                                            ),
                                                  shape: RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.circular(20)),
                                          ),
                                        ),
          



                   ],),
               ),
             ),
           ));
  }
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) 
  {
        // if (dateRangePickerSelectionChangedArgs.value["endDate"] == null) {
        // dateRangePickerSelectionChangedArgs.value["endDate"] = dateRangePickerSelectionChangedArgs.value["startDate"] ;
        // } 
    print(dateRangePickerSelectionChangedArgs.value);
  }
}


class ValueData {
  ValueData(this.continentAllFood, this.value, this.label);
   String continentAllFood;
   String label;
   num value;
}
class EmotionSleepData {
  EmotionSleepData(this.continent, this.val, this.color,this.label);
   String continent;
   num val;
   final String label;
   Color color;
}
class EmotionMeditateData {
  EmotionMeditateData(this.continent, this.val, this.color,this.label);
   String continent;
   num val;
   final String label;
   Color color;
}
class EmotionIrritableData {
  EmotionIrritableData(this.continent, this.val, this.color,this.label);
   String continent;
   num val;
   final String label;
   Color color;
}
class EmotionBoringData {
  EmotionBoringData(this.continent, this.val, this.color,this.label);
   String continent;
   num val;
   final String label;
   Color color;
}
class EmotionAloneData {
  EmotionAloneData(this.continent, this.val, this.color,this.label);
   String continent;
   num val;
   final String label;
   Color color;
}
