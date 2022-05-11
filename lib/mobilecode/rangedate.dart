import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time/date_time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:collection/collection.dart';
import '../models/dairymodel.dart';
import 'function/datethai.dart';
import 'models/patiendata.dart';


class GraphData extends StatefulWidget {
  var patienId;
  GraphData({Key key, @required this.patienId}) : super(key: key);
  @override
  _GraphDataState createState() => _GraphDataState();
}

class _GraphDataState extends State<GraphData> {
  // DateTime date;
  final formkey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  PatienData data = PatienData();
  List<DairyModel> dairyModel = [];
  // String uid ;
  DateRangePickerController _datePickerController = DateRangePickerController();
  var date ;
  double sumfat = 0;
  String getText() {
    if (date == null) {
      return 'เลือกวันเกิด';
    } 
    else {
      return DateFormat('dd/MM/yyyy').format(date);
    //   // return '${date.month}/${date.day}/${date.year}';
}
  }
   List<ValueData> _chartAllFoodData;
   List<SweetData> _chartSweetData;
   List<FatData> _chartFatData;
   List<SaltData> _chartSaltData;
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('MobileUser');
    showlegend(){
    if (data.Allfood[0] == 0 && data.Allfood[1] == 0 && data.Allfood[2] == 0) {
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
        for (var i = 0; i < dairyModel.length; i++) {
          // DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.userdata))
          DateTime countDate = DateTime.parse("${dairyModel[i].date}");
          if (
            dairyModel[i].fatchoice1 != "0" ||
            dairyModel[i].fatchoice2 != "0" ||
            dairyModel[i].fatchoice3 != "0" ||
            dairyModel[i].fatchoice4 != "0" ||
            dairyModel[i].fatchoice5 != "0" ||

            dairyModel[i].saltchoice1 != "0" ||
            dairyModel[i].saltchoice2 != "0" ||
            dairyModel[i].saltchoice3 != "0" ||
            dairyModel[i].saltchoice4 != "0" ||
            dairyModel[i].saltchoice5 != "0" ||

            dairyModel[i].sweetchoice1 != "0" ||
            dairyModel[i].sweetchoice2 != "0" ||
            dairyModel[i].sweetchoice3 != "0" ||
            dairyModel[i].sweetchoice4 != "0" ||
            dairyModel[i].sweetchoice5 != "0" 
            ) {
          setState(() {
            data.haveData.add(countDate);
          });            
          }

          // print(DateTime.parse("${dairyModel[i].date}"));
          }
        // print("## ${sumfat}");

      });
    // });
    // await FirebaseFirestore.instance.collection('MobileUser').doc(auth.currentUser!.uid).collection("diary").limit(1).get().then((DateLimit){
    //   var check = DateLimit.data();
    //     for (var i in DateLimit.docs) {
    //       DairyModel model = DairyModel.fromMap(i.data());
    //       setState(() {
    //         dairyModel.add(model);
    //       });
    //     }
    //     // print("## ${data.EndDate}");
    //     // print("## ${sumfat}");

    //   });
  }  


  @override
  Widget build(BuildContext context) {
         return Scaffold(
           body: SingleChildScrollView(
             child: Center(
               child: Container(
                //  padding: EdgeInsets.symmetric(horizontal: 10),
                 width: 800,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                    SizedBox(height: 20,),
                     Card(
                       child: Column(
                         children: [
                    SizedBox(height: 15,),
                     Text("การรับประทานอาหาร",          
                     style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center
                      ),
                      Text("ประวัติบันทึกการรับประทานอาหารแต่ละวัน",
                      style: TextStyle(
                      // fontSize: 25,
                      // fontWeight: FontWeight.bold,
                      ),),
                      // SizedBox(height: 20,),
                      Container(
                      // height: 220,
                      child: SfCircularChart(
                                                                // title: ChartTitle(text: "อาหารทั้งหมด",textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                                                      legend:Legend(isVisible: true,title: LegendTitle(text: "ชนิดอาหาร",textStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),position: LegendPosition.right),
                                                                      tooltipBehavior: TooltipBehavior(enable: false),
                                                                      palette: <Color>[Colors.pink.shade200, Colors.yellow.shade600, Colors.blue.shade400,],
                                                                      series: <CircularSeries>[
                                                                        DoughnutSeries<ValueData, String>(
                                                                            dataSource: [
                                                                                        ValueData('อาหารหวาน', data.Allfood[0],"${percent(data.Allfood[0],data.Allfood.sum).toStringAsFixed(1)} %"),
                                                                                        ValueData('อาหารมัน', data.Allfood[1],"${percent(data.Allfood[1],data.Allfood.sum).toStringAsFixed(1)} %"),
                                                                                        ValueData('อาหารเค็ม', data.Allfood[2],"${percent(data.Allfood[2],data.Allfood.sum).toStringAsFixed(1)} %"),
                                                                                      ],
                                                                            xValueMapper: (ValueData data, _) => data.continentAllFood,
                                                                            yValueMapper: (ValueData data, _) => data.value,
                                                                            dataLabelMapper: (ValueData data, _) => data.label,
                                                                            dataLabelSettings: DataLabelSettings(isVisible: showlegend(),
                                                                            labelPosition: ChartDataLabelPosition.inside),
                                                                              
                                                                            enableTooltip: true,
                                                                          )
                                                                      ],
                                                                    ),
                      ),                  
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40 ,vertical: 10),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 50,
                          onPressed: () {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                  AlertDialog(
                                  actions: <Widget>[StreamBuilder<QuerySnapshot>(
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
                                                                                        // print(snapshot.data);
                                                                                        return  SingleChildScrollView(
                                                                                                  child: Container(
                                                                                                    child: Column(children: <Widget>[
                                                                                                    Column(
                                                                                                          children: <Widget>[
                                                                                                            Center(child: Column(children: [
                                                                                                            SizedBox(height: 20,),                  
                                                                                                            Text(
                                                                                                              "เลือกช่วงเวลา",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
                                                                                                            SizedBox(height: 20,),
                                                                                                            Container(
                                                                                                                  height: 300,
                                                                                                                  width: 450,
                                                                                                                  child: ListView(
                                                                                                                                                children:
                                                                                                                                                    snapshot.data.docs.map((DocumentSnapshot document) {
                                                                                                                                                    if (snapshot.hasError) {
                                                                                                                                                      print(snapshot.error);
                                                                                                                                                      return Center(child: CircularProgressIndicator());
                                                                                                                                                    }
                                                                                                                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                                                                                          return Center(child: CircularProgressIndicator());
                                                                                                                                                        }
                                                                                                                                                  Map<String, dynamic> snap = document.data() as Map<String, dynamic>;
                                                                                                                                                  print("###$snap");
                                                                                                                                                  // if (snap == null) {
                                                                                                                                                  //         return Center(child: CircularProgressIndicator());
                                                                                                                                                  //       }
                                                                                                                                                  return    Column(
                                                                                                                                                            children: [
                                                                                                                                                              SfDateRangePicker(
                                                                                                                                                                selectionColor: Colors.blueAccent,
                                                                                                                                                                endRangeSelectionColor: Colors.blueAccent,
                                                                                                                                                                startRangeSelectionColor: Colors.blueAccent,
                                                                                                                                                                rangeSelectionColor: Colors.blueAccent.shade100,
                                                                                                                                                                todayHighlightColor: Colors.blueAccent,
                                                                                                                                                                view: DateRangePickerView.month,
                                                                                                                                                                minDate: DateTime.parse(document.id),
                                                                                                                                                                maxDate: DateTime.now(),
                                                                                                                                                                monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: DateTime.sunday,
                                                                                                                                                                specialDates:
                                                                                                                                                                data.haveData
                                                                                                                                                                  ),
                                                                                                                                                                monthCellStyle: DateRangePickerMonthCellStyle(
                                                                                                                                                                  specialDatesDecoration: BoxDecoration(
                                                                                                                                                                      // color: Colors.blueAccent,
                                                                                                                                                                      border: Border.all(color: Colors.blueAccent, width: 2),
                                                                                                                                                                      shape: BoxShape.circle),
                                                                                                                                                                ),
                                                                                                                                                                selectionMode: DateRangePickerSelectionMode.range,
                                                                                                                                                                onSelectionChanged: _onSelectionChanged,
                                                                                                                                                                showActionButtons: true,
                                                                                                                                                                controller: _datePickerController,
                                                                                                                                                                // is have var validate
                                                                                                                                                                onSubmit: (ture) {
                                                                                                                                                                  print("show test");
                                                                                                                                                                  // var dateter = valdate ;
                                                                                                                                                                  num sumfat1 = 0 ;
                                                                                                                                                                  num sumfat2 = 0 ;
                                                                                                                                                                  num sumfat3 = 0 ;
                                                                                                                                                                  num sumfat4 = 0 ;
                                                                                                                                                                  num sumfat5 = 0 ;
                                                                                                                                                                  num sumsweet1 = 0 ;
                                                                                                                                                                  num sumsweet2 = 0 ;
                                                                                                                                                                  num sumsweet3 = 0 ;
                                                                                                                                                                  num sumsweet4 = 0 ;
                                                                                                                                                                  num sumsweet5 = 0 ;
                                                                                                                                                                  num sumsalt1 = 0 ;
                                                                                                                                                                  num sumsalt2 = 0 ;
                                                                                                                                                                  num sumsalt3 = 0 ;
                                                                                                                                                                  num sumsalt4 = 0 ;
                                                                                                                                                                  num sumsalt5 = 0 ;
                                                                                                                                                                  List <num>  tatolEat= [0,0,0];
                                                                                                                                                                  var countDate = 0;
                                                                                                                                                                  var EndDate;

                                                                                                                                                                setState(() {
                                                                                                                                                                  var StartDate = DateTime.parse(_datePickerController.selectedRange.startDate.toString());
                                                                                                                                                                  if (_datePickerController.selectedRange?.endDate == null) {
                                                                                                                                                                     EndDate = DateTime.parse(_datePickerController.selectedRange.startDate.toString());
                                                                                                                                                                  }else{
                                                                                                                                                                     EndDate = DateTime.parse(_datePickerController.selectedRange.endDate.toString());
                                                                                                                                                                  }                                                                                                                                                                
                                                                                                                                                                  // var EndDate = DateTime.parse(_datePickerController.selectedRange!.endDate.toString());
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
                                                                                                                                                                                        // print("## ${NowDate}");
                                                                                                                                                                                            if (dairyModel[i].date == NowDate) { //ถ้าถอยหลังแล้วเจอ
                                                                                                                                                                                                          countDate ++;
                                                                                                                                                                                                          print(NowDate);
                                                                                                                                                                                                          setState(() {
                                                                                                                                                                                                            sumsweet1 += int.parse(dairyModel[i].sweetchoice1);
                                                                                                                                                                                                            sumsweet2 += int.parse(dairyModel[i].sweetchoice2);
                                                                                                                                                                                                            sumsweet3 += int.parse(dairyModel[i].sweetchoice3);
                                                                                                                                                                                                            sumsweet4 += int.parse(dairyModel[i].sweetchoice4);
                                                                                                                                                                                                            sumsweet5 += int.parse(dairyModel[i].sweetchoice5);
                                                                                                                                                                                                            List <num> sweetcount = [sumsweet1,sumsweet2,sumsweet3,sumsweet4,sumsweet5];
                                                                                                                                                                                                            if ( sweetcount.sum > 0) {tatolEat[0] += 1 ;}
                                                                                                                                                                                                            data.sweetchoice1 = sumsweet1;
                                                                                                                                                                                                            data.sweetchoice2 = sumsweet2;
                                                                                                                                                                                                            data.sweetchoice3 = sumsweet3;
                                                                                                                                                                                                            data.sweetchoice4 = sumsweet4;
                                                                                                                                                                                                            data.sweetchoice5 = sumsweet5;

                                                                                                                                                                                                            sumfat1 += int.parse(dairyModel[i].fatchoice1);
                                                                                                                                                                                                            sumfat2 += int.parse(dairyModel[i].fatchoice2);
                                                                                                                                                                                                            sumfat3 += int.parse(dairyModel[i].fatchoice3);
                                                                                                                                                                                                            sumfat4 += int.parse(dairyModel[i].fatchoice4);
                                                                                                                                                                                                            sumfat5 += int.parse(dairyModel[i].fatchoice5);
                                                                                                                                                                                                            List <num> fatcount = [sumfat1,sumfat2,sumfat3,sumfat4,sumfat5];
                                                                                                                                                                                                            if ( fatcount.sum > 0) {tatolEat[1] += 1 ;} 
                                                                                                                                                                                                            data.fatchoice1 = sumfat1;
                                                                                                                                                                                                            data.fatchoice2 = sumfat2;
                                                                                                                                                                                                            data.fatchoice3 = sumfat3;
                                                                                                                                                                                                            data.fatchoice4 = sumfat4;
                                                                                                                                                                                                            data.fatchoice5 = sumfat5;

                                                                                                                                                                                                            sumsalt1 += int.parse(dairyModel[i].saltchoice1);
                                                                                                                                                                                                            sumsalt2 += int.parse(dairyModel[i].saltchoice2);
                                                                                                                                                                                                            sumsalt3 += int.parse(dairyModel[i].saltchoice3);
                                                                                                                                                                                                            sumsalt4 += int.parse(dairyModel[i].saltchoice4);
                                                                                                                                                                                                            sumsalt5 += int.parse(dairyModel[i].saltchoice5);
                                                                                                                                                                                                            List <num> saltcount = [sumsalt1,sumsalt2,sumsalt3,sumsalt4,sumsalt5];
                                                                                                                                                                                                            if ( saltcount.sum > 0) {tatolEat[2] += 1 ;}
                                                                                                                                                                                                            data.saltchoice1 = sumsalt1;
                                                                                                                                                                                                            data.saltchoice2 = sumsalt2;
                                                                                                                                                                                                            data.saltchoice3 = sumsalt3;
                                                                                                                                                                                                            data.saltchoice4 = sumsalt4;
                                                                                                                                                                                                            data.saltchoice5 = sumsalt5;
                                                                                                                                                                                                            data.Allfood =  tatolEat;
                                                                                                                                                                                                            data.totalday = countDate ;                                                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                          });                           
                                                                                                                                                                                                                          }
                                                                                                                                                                                                          }

                                                                                                                                                                                  }
                                                                                                                                                                  // print("## ${data.fatchoice1}");
                                                                                                                                                                  // print("## ${data.fatchoice2}");
                                                                                                                                                                  // print("## ${data.fatchoice3}");
                                                                                                                                                                  // print("## ${data.fatchoice4}");
                                                                                                                                                                  // print("## ${data.fatchoice5}");
                                                                                                                                                                  // // GetRange();
                                                                                                                                                                  // Navigator.pop(context);
                                                                                                                                                                  print("ช่วงวันที่ ${data.StartDate} ถึง ${data.EndDate}");
                                                                                                                                                                  print("มีการบันทึกข้อมูล ${data.totalday}");
                                                                                                                                                                  Navigator.pop(context);  
                                                                                                                                                                },
                                                                                                                                                                onCancel: () {
                                                                                                                                                                  _datePickerController.selectedRanges = null;
                                                                                                                                                                  // Navigator.pop(context);
                                                                                                                                                                },
                                                                                                                                                              )],
                                                                                                                                                          );                     
                                                                                                                                                }).toList(),
                                                                                                                                              )
                                                                                                                                            //
                                                                                                                                          ),
                                                                                                                                          ],)),
                                                                                                                                              ],
                                                                                                                                            ),
                                                                                                                                      ],),),
                                                                                                );     },),
                                                                                                                                ],
                                                                      shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(20)),
                                                                      )
                                                                    );
                                                                    },
                                                                    // defining the shape
                                                                    hoverColor:Colors.grey.shade200,
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
                         ],
                       ),
                                                shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20)),
                     ),
                    
                      Card(
                        child: 
                          Container(
                            // width: 400,
                            child: Column(
                              children: <Widget>[
                                const SizedBox(height: 10,),
                                const Text("อาหารรสหวาน",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                const SizedBox(height: 5,),
                                Column(
                                  children: [
                                    if(data.totalday > 0)...[
                                      Column(
                                        children: [
                                          const SizedBox(height: 10,),
                                          Text("จากการเลือกวันที่ ${DateThai(data.StartDate)} ถึงวันที่ ${DateThai(data.EndDate)}"),
                                          Text("จำนวนวันที่มีการบันทีก ${data.totalday} วัน"),
                                          const SizedBox(height: 10,),
                                        ],
                                      )
                                    ]
                                  ],
                                ),
                        SfCartesianChart(
                              // title: ChartTitle(text:'อาหารรสหวาน'),
                              legend: Legend(isVisible: false),
                              tooltipBehavior: TooltipBehavior(
                                        enable: false,
                                        // format: "Test",
                                        // Templating the tooltip
                                        // builder: (dynamic data, dynamic point, dynamic series,
                                        // int pointIndex, int seriesIndex) {
                                        //   return Container(
                                        //     child: Text(
                                        //       'PointIndex : ${pointIndex.toString()}'
                                        //     )
                                        //   );
                                        // }
                                ),
                              series: <ChartSeries>[
                                ColumnSeries<SweetData, String>(
                                    dataSource: [
                                      SweetData('ข้อ1', data.sweetchoice1,Colors.pink.shade300,"${data.sweetchoice1} วัน"),
                                      SweetData('ข้อ2', data.sweetchoice2,Colors.pink.shade400,"${data.sweetchoice2} วัน"),
                                      SweetData('ข้อ3', data.sweetchoice3,Colors.pink.shade500,"${data.sweetchoice3} วัน"),
                                      SweetData('ข้อ4', data.sweetchoice4,Colors.pink.shade600,"${data.sweetchoice4} วัน"),
                                      SweetData('ข้อ5', data.sweetchoice5,Colors.pink.shade700,"${data.sweetchoice5} วัน"),
                                    ],
                                    xValueMapper: (SweetData val, _) => val.continent,
                                    yValueMapper: (SweetData val, _) => val.val,
                                    dataLabelMapper: (SweetData data, _) => data.label,
                                    dataLabelSettings: DataLabelSettings(isVisible: true),
                                    pointColorMapper: (SweetData data, _) => data.color,
                                    enableTooltip: false
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
                                        Center(child: const Text("สรุป อาหารรสหวาน",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                                        const SizedBox(height: 15,),
                                        ListTile(
                                          leading: Text('หัวข้ออาหาร',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                                          trailing: Text("วัน",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),
                                              ),
                                        Divider(thickness: 2, color: Colors.grey,), 
                                        ListTile(
                                          leading: Text('ข้อ1  รับประทาน น้ำเปล่า เครื่องดื่มไม่ผสมน้ำตาล :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                          trailing: Text("${data.sweetchoice1}",style: TextStyle(fontSize: 17,)),
                                        ),
                                        ListTile(
                                          leading: Text('ข้อ2  รับประทาน น้ำอัดลม เครื่องดื่มชง น้ำหวาน นมเปรี้ยว :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                          trailing: Text("${data.sweetchoice2}",style: TextStyle(fontSize: 17,)),
                                        ),
                                        ListTile(
                                          leading: Text('ข้อ3  รับประทาน น้ำผักผลไม้สำเร็จรูป :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                          trailing: Text("${data.sweetchoice3}",style: TextStyle(fontSize: 17,)),
                                        ),
                                        ListTile(
                                          leading: Text('ข้อ4  รับประทาน ไอศกรีม เบเกอรี่ หรือขนมไทย :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                          trailing: Text("${data.sweetchoice4}",style: TextStyle(fontSize: 17,)),
                                        ),
                                        ListTile(
                                          leading: Text('ข้อ5  รับประทาน เติมน้ำตาล น้ำผึ้ง น้ำเชือมเพิ่มในอาหาร :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                                          trailing: Text("${data.sweetchoice5}",style: TextStyle(fontSize: 17,)),
                                        ),
                                        // Divider(thickness: 2, color: Colors.grey.shade300,)
                                      ],
                                    ), 
                                      ]
                                    ],
                                  ),
                             ),
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children:const [
                            //     Text('ข้อ1  น้ำเปล่า เครื่องดื่มไม่ผสมน้ำตาล'),
                            //     Text("ข้อ2  น้ำอัดลม เครื่องดื่มชง น้ำหวาน นมเปรี้ยว"),
                            //     Text("ข้อ3  น้ำผักผลไม้สำเร็จรูป"),
                            //     Text("ข้อ4  ไอศกรีม เบเกอรี่ หรือขนมไทย"),
                            //     Text("ข้อ5  เติมน้ำตาล น้ำผึ้ง น้ำเชือมเพิ่มในอาหาร"),
                            //   ],
                            // ),
                            SizedBox(height: 20,)
                            ]
                            ),
                          ),
                              shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(20)),
                      ),
                      Card(
                        child: 
                          Column(
                            children: <Widget>[
                              const SizedBox(height: 10,),
                              const Text("อาหารรสมัน",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              const SizedBox(height: 5,),
                              Column(
                                children: [
                                  if(data.totalday > 0)...[
                                        const SizedBox(height: 10,),
                                        Text("จากการเลือกวันที่ ${DateThai(data.StartDate)} ถึงวันที่ ${DateThai(data.EndDate)}"),
                                        Text("จำนวนวันที่มีการบันทีก ${data.totalday} วัน"),
                                        const SizedBox(height: 10,),
                                  ]
                                ],
                              ),                                              
                        SfCartesianChart(
                            // title: ChartTitle(text: 'อาหารรสมัน'),
                            legend: Legend(isVisible: false),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <ChartSeries>[
                              ColumnSeries<FatData, String>(
                                  dataSource: [
                                    FatData('ข้อ1', data.fatchoice1,Colors.yellow.shade300,"${data.fatchoice1} วัน"),
                                    FatData('ข้อ2', data.fatchoice2,Colors.yellow.shade400,"${data.fatchoice2} วัน"),
                                    FatData('ข้อ3', data.fatchoice3,Colors.yellow.shade500,"${data.fatchoice3} วัน"),
                                    FatData('ข้อ4', data.fatchoice4,Colors.yellow.shade600,"${data.fatchoice4} วัน"),
                                    FatData('ข้อ5', data.fatchoice5,Colors.yellow.shade700,"${data.fatchoice5} วัน"),
                                  ],
                                  xValueMapper: (FatData val, _) => val.continent,
                                  yValueMapper: (FatData val, _) => val.val,
                                  dataLabelMapper: (FatData data, _) => data.label,
                                  dataLabelSettings: DataLabelSettings(isVisible: true),
                                  pointColorMapper: (FatData data, _) => data.color,
                                  enableTooltip: false
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
                      Center(child: const Text("สรุป อาหารรสหวาน",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                      const SizedBox(height: 15,),
                      ListTile(
                        leading: Text('หัวข้ออาหาร',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                        trailing: Text("วัน",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),
                            ),
                      Divider(thickness: 2, color: Colors.grey,), 
                      ListTile(
                        leading: Text('ข้อ1  เนื้อติดมัน ติดหนัง :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                        trailing: Text("${data.fatchoice1}",style: TextStyle(fontSize: 17,)),
                      ),
                      ListTile(
                        leading: Text('ข้อ2  อาหารทอด ฟาสฟู๊ด ผัดน้ำมัน :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                        trailing: Text("${data.fatchoice2}",style: TextStyle(fontSize: 17,)),
                      ),
                      ListTile(
                        leading: Text('ข้อ3  อาหารจานเดียวไขมันสูง หรือแกงกะทิ :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                        trailing: Text("${data.fatchoice3}",style: TextStyle(fontSize: 17,)),
                      ),
                      ListTile(
                        leading: Text('ข้อ4  เครื่องดื่มผสม นมข้นหวาน ครีมเทียม วิปปิ้งครีม :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                        trailing: Text("${data.fatchoice4}",style: TextStyle(fontSize: 17,)),
                      ),
                      ListTile(
                        leading: Text('ข้อ5  ซดน้ำผัด น้ำแกง หรือราดลงในข้าว :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                        trailing: Text("${data.fatchoice5}",style: TextStyle(fontSize: 17,)),
                      ),
                      // Divider(thickness: 2, color: Colors.grey.shade300,)
                      ],
                                    ), 
                      ]
                                    ],
                                  ),
                             ),                                          
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children:const [
                          //     Text('ข้อที่1  เนื้อติดมัน ติดหนัง'),
                          //     Text("ข้อที่2  อาหารทอด ฟาสฟู๊ด ผัดน้ำมัน"),
                          //     Text("ข้อที่3  อาหารจานเดียวไขมันสูง หรือแกงกะทิ"),
                          //     Text("ข้อที่4  เครื่องดื่มผสม นมข้นหวาน ครีมเทียม วิปปิ้งครีม"),
                          //     Text("ข้อที่5  ซดน้ำผัด น้ำแกง หรือราดลงในข้าว"),
                          //   ],
                          // ),
                          SizedBox(height: 20,)                                          
                          ]
                          ),
                              shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(20)),
                      ),
                      Container(
                        width: 800,
                      //  padding: EdgeInsets.symmetric(horizontal: 400,vertical: 5),
                        child: Card(
                          child: 
                            Column(
                              children: <Widget>[
                                const SizedBox(height: 10,),
                                const Text("อาหารรสเค็ม",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                const SizedBox(height: 5,),
                                Column(
                                  children: [
                                    if(data.totalday > 0)...[
                                          const SizedBox(height: 10,),
                                          Text("จากการเลือกวันที่ ${DateThai(data.StartDate)} ถึงวันที่ ${DateThai(data.EndDate)}"),
                                          Text("จำนวนวันที่มีการบันทีก ${data.totalday} วัน"),
                                          const SizedBox(height: 10,),
                                    ]
                                  ],
                                ),                                                                                       
                          SfCartesianChart(
                              // title: ChartTitle(text: 'อาหารรสเค็ม'),
                              legend: Legend(isVisible: false),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <ChartSeries>[
                                ColumnSeries<SaltData, String>(
                                    dataSource: [
                                      SaltData('ข้อ1', data.saltchoice1,Colors.blue.shade300,"${data.saltchoice1} วัน"),
                                      SaltData('ข้อ2', data.saltchoice2,Colors.blue.shade400,"${data.saltchoice2} วัน"),
                                      SaltData('ข้อ3', data.saltchoice3,Colors.blue.shade500,"${data.saltchoice3} วัน"),
                                      SaltData('ข้อ4', data.saltchoice4,Colors.blue.shade600,"${data.saltchoice4} วัน"),
                                      SaltData('ข้อ5', data.saltchoice5,Colors.blue.shade700,"${data.saltchoice5} วัน"),
                                    ],
                                    xValueMapper: (SaltData val, _) => val.continent,
                                    yValueMapper: (SaltData val, _) => val.val,
                                    dataLabelMapper: (SaltData data, _) => data.label,
                                    dataLabelSettings: DataLabelSettings(isVisible: true),
                                    pointColorMapper: (SaltData data, _) => data.color,
                                    enableTooltip: false
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
                        Center(child: const Text("สรุป อาหารรสหวาน",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                        const SizedBox(height: 15,),
                        ListTile(
                          leading: Text('หัวข้ออาหาร',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                          trailing: Text("วัน",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),
                              ),
                        Divider(thickness: 2, color: Colors.grey,), 
                        ListTile(
                          leading: Text('ข้อ1  ชิมอาหารก่อนปรุง ปรุงน้อยหรือไม่ปรุงเพิ่ม :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                          trailing: Text("${data.saltchoice1}",style: TextStyle(fontSize: 17,)),
                        ),
                        ListTile(
                          leading: Text('ข้อ2  ใช้สมุนไพรหรือเครื่องเทศแทนเครื่องปรุง :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                          trailing: Text("${data.saltchoice2}",style: TextStyle(fontSize: 17,)),
                        ),
                        ListTile(
                          leading: Text('ข้อ3  เนื้อสัตว์แปรรูป :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                          trailing: Text("${data.saltchoice3}",style: TextStyle(fontSize: 17,)),
                        ),
                        ListTile(
                          leading: Text('ข้อ4  อาหารสำเร็จรูป :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                          trailing: Text("${data.saltchoice4}",style: TextStyle(fontSize: 17,)),
                        ),
                        ListTile(
                          leading: Text('ข้อ5  ผักผลไม้ของดอง หรือ ผลไม้จิ้มพริกเกลือ น้ำปลาหวาน :',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),),
                          trailing: Text("${data.saltchoice5}",style: TextStyle(fontSize: 17,)),
                        ),
                        // Divider(thickness: 2, color: Colors.grey.shade300,)
                      ],
                                      ), 
                      ]
                                      ],
                                    ),
                               ),                                              
                            // Column (
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children:const [
                            //     Text('ข้อที่1  ชิมอาหารก่อนปรุง ปรุงน้อยหรือไม่ปรุงเพิ่ม'),
                            //     Text("ข้อที่2  ใช้สมุนไพรหรือเครื่องเทศแทนเครื่องปรุง"),
                            //     Text("ข้อที่3  เนื้อสัตว์แปรรูป"),
                            //     Text("ข้อที่4  อาหารสำเร็จรูป"),
                            //     Text("ข้อที่5  ผักผลไม้ของดอง หรือ ผลไม้จิ้มพริกเกลือ น้ำปลาหวาน"),
                            //   ],
                            // ),
                            SizedBox(height: 20,)
                            ]
                            ),
                                shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(20)),
                        ),
                      ),

                    //  Container(
                    //    width: 500,
                    //    padding: EdgeInsets.symmetric(horizontal: 10),
                    //    child: Card(
                    //      child: Column(
                    //        children: [
                    // SizedBox(height: 15,),
                    //  Text("การรับประทานอาหาร",          
                    //  style: TextStyle(
                    //   fontSize: 30,
                    //   fontWeight: FontWeight.bold,
                    //   ),
                    //   textAlign: TextAlign.center
                    //   ),
                    //   Text("ประวัติบันทึกการรับประทานอาหารแต่ละวัน",
                    //   style: TextStyle(
                    //   fontSize: 25,
                    //   // fontWeight: FontWeight.bold,
                    //   ),),
                    //   // SizedBox(height: 20,),
                    //   Container(
                    //     height: 220,
                    //     child: SfCircularChart(
                    //                                               // title: ChartTitle(text: "อาหารทั้งหมด",textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                    //                                                     legend:Legend(isVisible: true,title: LegendTitle(text: "ชนิดอาหาร",textStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),position: LegendPosition.right),
                    //                                                     tooltipBehavior: TooltipBehavior(enable: false),
                    //                                                     palette: <Color>[Colors.pink.shade200, Colors.yellow.shade600, Colors.blue.shade400,],
                    //                                                     series: <CircularSeries>[
                    //                                                       DoughnutSeries<ValueData, String>(
                    //                                                           dataSource: [
                    //                                                                       ValueData('อาหารหวาน', data.Allfood[0],"${percent(data.Allfood[0],data.Allfood.sum).toStringAsFixed(1)} %"),
                    //                                                                       ValueData('อาหารมัน', data.Allfood[1],"${percent(data.Allfood[1],data.Allfood.sum).toStringAsFixed(1)} %"),
                    //                                                                       ValueData('อาหารเค็ม', data.Allfood[2],"${percent(data.Allfood[2],data.Allfood.sum).toStringAsFixed(1)} %"),
                    //                                                                     ],
                    //                                                           xValueMapper: (ValueData data, _) => data.continentAllFood,
                    //                                                           yValueMapper: (ValueData data, _) => data.value,
                    //                                                           dataLabelMapper: (ValueData data, _) => data.label,
                    //                                                           dataLabelSettings: DataLabelSettings(isVisible: showlegend(),
                    //                                                           labelPosition: ChartDataLabelPosition.inside),
                                                                                
                    //                                                           enableTooltip: true,
                    //                                                         )
                    //                                                     ],
                    //                                                   ),
                    //   ),                  
                    //     Container(
                    //       padding: EdgeInsets.symmetric(horizontal: 20 ,vertical: 10),
                    //       child: MaterialButton(
                    //         minWidth: double.infinity,
                    //         height: 50,
                    //         onPressed: () {
                    //           showDialog<String>(
                    //               context: context,
                    //               builder: (BuildContext context) =>
                    //                 AlertDialog(
                    //                 actions: <Widget>[StreamBuilder<QuerySnapshot>(
                    //                                                                 stream: FirebaseFirestore.instance.collection("MobileUser").doc(widget.patienId.id).collection("diary").limit(1).snapshots(),
                    //                                                                 builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
                    //                                                                         if (snapshot.hasError) {
                    //                                                                           print(snapshot.error);
                    //                                                                           return Center(child: CircularProgressIndicator());
                    //                                                                         }
                    //                                                                         if (snapshot.connectionState == ConnectionState.waiting) {
                    //                                                                               return Center(child: CircularProgressIndicator());
                    //                                                                             }
                    //                                                                         if(snapshot.data.docs.isEmpty){
                    //                                                                           return Container(
                    //                                                                                 height: 150,
                    //                                                                                 width: 250,
                    //                                                                                 child: Column(
                    //                                                                                   crossAxisAlignment: CrossAxisAlignment.center,
                    //                                                                                   mainAxisAlignment: MainAxisAlignment.center,
                    //                                                                                   children: [
                    //                                                                                   Text('ไม่มีข้อมูล',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,)),
                    //                                                                                   SizedBox(height: 5,),
                    //                                                                                   Text('ยังไม่เคยมีการบันทึกข้อมูล',style: TextStyle(fontSize: 18,)),
                    //                                                                                   SizedBox(height: 15,),
                    //                                                                                       MaterialButton(
                    //                                                                                         minWidth: 140,
                    //                                                                                         height: 40,
                    //                                                                                         onPressed: (){
                    //                                                                                            Navigator.pop(context);
                    //                                                                                         },
                    //                                                                                         color: Colors.blueAccent,
                    //                                                                                         shape: RoundedRectangleBorder(
                    //                                                                                             borderRadius: BorderRadius.circular(20)),
                    //                                                                                         child: Text(
                    //                                                                                           "ตกลง",
                    //                                                                                           style: TextStyle(
                    //                                                                                               color: Colors.white,
                    //                                                                                               fontWeight: FontWeight.w600,
                    //                                                                                               fontSize: 18),
                    //                                                                                         ),
                    //                                                                                       ),
                    //                                                                                   ],
                    //                                                                                 ),
                    //                                                                           );
                    //                                                                         }
                    //                                                                       print(snapshot.data);
                    //                                                                       return  SingleChildScrollView(
                    //                                                                                 child: Container(
                    //                                                                                   child: Column(children: <Widget>[
                    //                                                                                   Column(
                    //                                                                                         children: <Widget>[
                    //                                                                                           Center(child: Column(children: [
                    //                                                                                           SizedBox(height: 20,),                  
                    //                                                                                           Text(
                    //                                                                                             "เลือกช่วงเวลา",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
                    //                                                                                           SizedBox(height: 20,),
                    //                                                                                           Container(
                    //                                                                                                 height: 300,
                    //                                                                                                 width: 450,
                    //                                                                                                 child: ListView(
                    //                                                                                                                               children:
                    //                                                                                                                                   snapshot.data.docs.map((DocumentSnapshot document) {
                    //                                                                                                                                   if (snapshot.hasError) {
                    //                                                                                                                                     print(snapshot.error);
                    //                                                                                                                                     return Center(child: CircularProgressIndicator());
                    //                                                                                                                                   }
                    //                                                                                                                                   if (snapshot.connectionState == ConnectionState.waiting) {
                    //                                                                                                                                         return Center(child: CircularProgressIndicator());
                    //                                                                                                                                       }
                    //                                                                                                                                 Map<String, dynamic> snap = document.data() as Map<String, dynamic>;
                    //                                                                                                                                 print("###$snap");
                    //                                                                                                                                 // if (snap == null) {
                    //                                                                                                                                 //         return Center(child: CircularProgressIndicator());
                    //                                                                                                                                 //       }
                    //                                                                                                                                 return    Column(
                    //                                                                                                                                           children: [
                    //                                                                                                                                             SfDateRangePicker(
                    //                                                                                                                                               selectionColor: Colors.blueAccent,
                    //                                                                                                                                               endRangeSelectionColor: Colors.blueAccent,
                    //                                                                                                                                               startRangeSelectionColor: Colors.blueAccent,
                    //                                                                                                                                               rangeSelectionColor: Colors.blueAccent.shade100,
                    //                                                                                                                                               todayHighlightColor: Colors.blueAccent,
                    //                                                                                                                                               view: DateRangePickerView.month,
                    //                                                                                                                                               minDate: DateTime.parse(document.id),
                    //                                                                                                                                               maxDate: DateTime.now(),
                    //                                                                                                                                               monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: DateTime.sunday),
                    //                                                                                                                                               selectionMode: DateRangePickerSelectionMode.range,
                    //                                                                                                                                               onSelectionChanged: _onSelectionChanged,
                    //                                                                                                                                               showActionButtons: true,
                    //                                                                                                                                               controller: _datePickerController,
                    //                                                                                                                                               // is have var validate
                    //                                                                                                                                               onSubmit: (ture) {
                    //                                                                                                                                                 print("show test");
                    //                                                                                                                                                 // var dateter = valdate ;
                    //                                                                                                                                                 num sumfat1 = 0 ;
                    //                                                                                                                                                 num sumfat2 = 0 ;
                    //                                                                                                                                                 num sumfat3 = 0 ;
                    //                                                                                                                                                 num sumfat4 = 0 ;
                    //                                                                                                                                                 num sumfat5 = 0 ;
                    //                                                                                                                                                 num sumsweet1 = 0 ;
                    //                                                                                                                                                 num sumsweet2 = 0 ;
                    //                                                                                                                                                 num sumsweet3 = 0 ;
                    //                                                                                                                                                 num sumsweet4 = 0 ;
                    //                                                                                                                                                 num sumsweet5 = 0 ;
                    //                                                                                                                                                 num sumsalt1 = 0 ;
                    //                                                                                                                                                 num sumsalt2 = 0 ;
                    //                                                                                                                                                 num sumsalt3 = 0 ;
                    //                                                                                                                                                 num sumsalt4 = 0 ;
                    //                                                                                                                                                 num sumsalt5 = 0 ;
                    //                                                                                                                                                 List <num>  tatolEat= [0,0,0];
                    //                                                                                                                                                 var countDate = 0;
                    //                                                                                                                                                 var EndDate;

                    //                                                                                                                                               setState(() {
                    //                                                                                                                                                 var StartDate = DateTime.parse(_datePickerController.selectedRange.startDate.toString());
                    //                                                                                                                                                 if (_datePickerController.selectedRange?.endDate == null) {
                    //                                                                                                                                                    EndDate = DateTime.parse(_datePickerController.selectedRange.startDate.toString());
                    //                                                                                                                                                 }else{
                    //                                                                                                                                                    EndDate = DateTime.parse(_datePickerController.selectedRange.endDate.toString());
                    //                                                                                                                                                 }                                                                                                                                                                
                    //                                                                                                                                                 // var EndDate = DateTime.parse(_datePickerController.selectedRange!.endDate.toString());
                    //                                                                                                                                                 data.Difference = num.parse(StartDate.difference(EndDate).inDays.toString()).abs(); 
                    //                                                                                                                                                 data.StartDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(StartDate.toString()));
                    //                                                                                                                                                 data.EndDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(EndDate.toString())); 

                    //                                                                                                                                                 });
                    //                                                                                                                                                 print(data.Difference);
                    //                                                                                                                                                 print(data.StartDate);
                    //                                                                                                                                                 print(data.EndDate);
                                                                                                                                                                    
                    //                                                                                                                                                         for (var i = 0; i < dairyModel.length; i++) {
                    //                                                                                                                                                                 for (var c = 0; c <= data.Difference ; c++) { //นำส่วนต่างมากำหนดลูป
                    //                                                                                                                                                                       var NowDate = DateFormat('yyyy-MM-dd').format(DateTime.parse("${data.EndDate}").subtract(Duration(days:c))).toString(); //เริ่มนับถอยหลัง
                    //                                                                                                                                                                       // print("## ${NowDate}");
                    //                                                                                                                                                                           if (dairyModel[i].date == NowDate) { //ถ้าถอยหลังแล้วเจอ
                    //                                                                                                                                                                                         countDate ++;
                    //                                                                                                                                                                                         print(NowDate);
                    //                                                                                                                                                                                         setState(() {
                    //                                                                                                                                                                                           sumsweet1 += int.parse(dairyModel[i].sweetchoice1);
                    //                                                                                                                                                                                           sumsweet2 += int.parse(dairyModel[i].sweetchoice2);
                    //                                                                                                                                                                                           sumsweet3 += int.parse(dairyModel[i].sweetchoice3);
                    //                                                                                                                                                                                           sumsweet4 += int.parse(dairyModel[i].sweetchoice4);
                    //                                                                                                                                                                                           sumsweet5 += int.parse(dairyModel[i].sweetchoice5);
                    //                                                                                                                                                                                           List <num> sweetcount = [sumsweet1,sumsweet2,sumsweet3,sumsweet4,sumsweet5];
                    //                                                                                                                                                                                           if ( sweetcount.sum > 0) {tatolEat[0] += 1 ;}
                    //                                                                                                                                                                                           data.sweetchoice1 = sumsweet1;
                    //                                                                                                                                                                                           data.sweetchoice2 = sumsweet2;
                    //                                                                                                                                                                                           data.sweetchoice3 = sumsweet3;
                    //                                                                                                                                                                                           data.sweetchoice4 = sumsweet4;
                    //                                                                                                                                                                                           data.sweetchoice5 = sumsweet5;

                    //                                                                                                                                                                                           sumfat1 += int.parse(dairyModel[i].fatchoice1);
                    //                                                                                                                                                                                           sumfat2 += int.parse(dairyModel[i].fatchoice2);
                    //                                                                                                                                                                                           sumfat3 += int.parse(dairyModel[i].fatchoice3);
                    //                                                                                                                                                                                           sumfat4 += int.parse(dairyModel[i].fatchoice4);
                    //                                                                                                                                                                                           sumfat5 += int.parse(dairyModel[i].fatchoice5);
                    //                                                                                                                                                                                           List <num> fatcount = [sumfat1,sumfat2,sumfat3,sumfat4,sumfat5];
                    //                                                                                                                                                                                           if ( fatcount.sum > 0) {tatolEat[1] += 1 ;} 
                    //                                                                                                                                                                                           data.fatchoice1 = sumfat1;
                    //                                                                                                                                                                                           data.fatchoice2 = sumfat2;
                    //                                                                                                                                                                                           data.fatchoice3 = sumfat3;
                    //                                                                                                                                                                                           data.fatchoice4 = sumfat4;
                    //                                                                                                                                                                                           data.fatchoice5 = sumfat5;

                    //                                                                                                                                                                                           sumsalt1 += int.parse(dairyModel[i].saltchoice1);
                    //                                                                                                                                                                                           sumsalt2 += int.parse(dairyModel[i].saltchoice2);
                    //                                                                                                                                                                                           sumsalt3 += int.parse(dairyModel[i].saltchoice3);
                    //                                                                                                                                                                                           sumsalt4 += int.parse(dairyModel[i].saltchoice4);
                    //                                                                                                                                                                                           sumsalt5 += int.parse(dairyModel[i].saltchoice5);
                    //                                                                                                                                                                                           List <num> saltcount = [sumsalt1,sumsalt2,sumsalt3,sumsalt4,sumsalt5];
                    //                                                                                                                                                                                           if ( saltcount.sum > 0) {tatolEat[2] += 1 ;}
                    //                                                                                                                                                                                           data.saltchoice1 = sumsalt1;
                    //                                                                                                                                                                                           data.saltchoice2 = sumsalt2;
                    //                                                                                                                                                                                           data.saltchoice3 = sumsalt3;
                    //                                                                                                                                                                                           data.saltchoice4 = sumsalt4;
                    //                                                                                                                                                                                           data.saltchoice5 = sumsalt5;
                    //                                                                                                                                                                                           data.Allfood =  tatolEat;
                    //                                                                                                                                                                                           data.totalday = countDate ;                                                                                                                                                                                                                                                                                              
                    //                                                                                                                                                                                                         });                           
                    //                                                                                                                                                                                                         }
                    //                                                                                                                                                                                         }

                    //                                                                                                                                                                 }
                    //                                                                                                                                                 // print("## ${data.fatchoice1}");
                    //                                                                                                                                                 // print("## ${data.fatchoice2}");
                    //                                                                                                                                                 // print("## ${data.fatchoice3}");
                    //                                                                                                                                                 // print("## ${data.fatchoice4}");
                    //                                                                                                                                                 // print("## ${data.fatchoice5}");
                    //                                                                                                                                                 // // GetRange();
                    //                                                                                                                                                 // Navigator.pop(context);
                    //                                                                                                                                                 print("ช่วงวันที่ ${data.StartDate} ถึง ${data.EndDate}");
                    //                                                                                                                                                 print("มีการบันทึกข้อมูล ${data.totalday}");
                    //                                                                                                                                                 Navigator.pop(context);  
                    //                                                                                                                                               },
                    //                                                                                                                                               onCancel: () {
                    //                                                                                                                                                 _datePickerController.selectedRanges = null;
                    //                                                                                                                                                 Navigator.pop(context);
                    //                                                                                                                                               },
                    //                                                                                                                                             )],
                    //                                                                                                                                         );                     
                    //                                                                                                                               }).toList(),
                    //                                                                                                                             )
                    //                                                                                                                           //
                    //                                                                                                                         ),
                    //                                                                                                                         ],)),
                    //                                                                                                                             ],
                    //                                                                                                                           ),
                    //                                                                                                                     ],),),
                    //                                                                               );     },),
                    //                                                                                                               ],
                    //                                                     shape: RoundedRectangleBorder(
                    //                                                     borderRadius: BorderRadius.circular(20)),
                    //                                                     )
                    //                                                   );
                    //                                                   },
                    //                                                   // defining the shape
                    //                                                   hoverColor:Colors.grey.shade200,
                    //                                                   color: Colors.blueAccent,
                    //                                                   shape: RoundedRectangleBorder(
                    //                                                       // side: BorderSide(color: Colors.blue.shade200),
                    //                                                       borderRadius: BorderRadius.circular(20)),
                    //                                                   child: Text(
                    //                                                     "เลือกช่วงเวลา",
                    //                                                     style:
                    //                                                         TextStyle(fontWeight: FontWeight.w600, fontSize: 20,color: Colors.white,),
                    //                                                   ),
                    //                                                 ),
                    //     ),
                    //        ],
                    //      ),
                    //                               shape: RoundedRectangleBorder(
                    //                               borderRadius: BorderRadius.circular(20)),
                    //    ),
                    //  ),





                                  // Column(
                                  //                 children: [ if ("${data.StartDate}" != "null" && "${data.EndDate}" != "null") ...[
                                  //                   Card(child: Container(
                                  //                   padding: EdgeInsets.symmetric(horizontal: 35,vertical: 10),
                                  //                   child:
                                  //                         Column(
                                  //                           children: [
                                  //                                   Text("ช่วงวันที่ ${data.StartDate} ถึง ${data.EndDate}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                  //                                   Text("มีการบันทึกข้อมูล ${data.totalday} วัน",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),   
                                  //                           ],
                                  //                         ),),
                                  //                   shape: RoundedRectangleBorder(
                                  //                   borderRadius: BorderRadius.circular(20)),
                                  //                     ),
                                  //                   ] 
                                  //                 ],
                                  //               ),           
                                        // Container(
                                        //  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                        //   child: Card(
                                        //     child: SfCircularChart(
                                        //       title: ChartTitle(text: "อาหารทั้งหมด",textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                        //             legend:Legend(isVisible: true,title: LegendTitle(text: "ชนิดอาหาร",textStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),position: LegendPosition.right),
                                        //             tooltipBehavior: TooltipBehavior(enable: false),
                                        //             palette: <Color>[Colors.pink.shade300, Colors.yellow.shade600, Colors.blue.shade400,],
                                        //             series: <CircularSeries>[
                                        //               DoughnutSeries<ValueData, String>(
                                        //                   dataSource: [
                                        //                               ValueData('อาหารหวาน', data.Allfood[0] ,),
                                        //                               ValueData('อาหารมัน', data.Allfood[1],),
                                        //                               ValueData('อาหารเค็ม', data.Allfood[2],),
                                        //                             ],
                                        //                   xValueMapper: (ValueData data, _) => data.continentAllFood,
                                        //                   yValueMapper: (ValueData data, _) => data.value,
                                        //                   dataLabelSettings: DataLabelSettings(isVisible: showlegend(),
                                        //                   labelPosition: ChartDataLabelPosition.outside),
                                                            
                                        //                   enableTooltip: true,
                                        //                 )
                                        //             ],
                                        //           ),
                                        //           shape: RoundedRectangleBorder(
                                        //            borderRadius: BorderRadius.circular(20)),
                                        //   ),
                                        // ),
           
           
                                        
                                        // Container(
                                        //  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                        //   child: Card(
                                        //     child: 
                                        //       Column(
                                        //         children: <Widget>[
                                        //           const SizedBox(height: 10,),
                                        //           const Text("อาหารรสหวาน",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                        //           const SizedBox(height: 5,),
                                        //           Column(
                                        //             children: [
                                        //               if(data.totalday > 0)...[
                                        //                 Column(
                                        //                   children: [
                                        //                     const SizedBox(height: 10,),
                                        //                     Text("จากการเลือกวันที่ ${DateThai(data.StartDate)} ถึงวันที่ ${DateThai(data.EndDate)}"),
                                        //                     Text("จำนวนวันที่มีการบันทีก ${data.totalday} วัน"),
                                        //                     const SizedBox(height: 10,),
                                        //                   ],
                                        //                 )
                                        //               ]
                                        //             ],
                                        //           ),
                                        //     SfCartesianChart(
                                        //         // title: ChartTitle(text:'อาหารรสหวาน'),
                                        //         legend: Legend(isVisible: false),
                                        //         tooltipBehavior: TooltipBehavior(
                                        //                   enable: false,
                                        //                   // format: "Test",
                                        //                   // Templating the tooltip
                                        //                   // builder: (dynamic data, dynamic point, dynamic series,
                                        //                   // int pointIndex, int seriesIndex) {
                                        //                   //   return Container(
                                        //                   //     child: Text(
                                        //                   //       'PointIndex : ${pointIndex.toString()}'
                                        //                   //     )
                                        //                   //   );
                                        //                   // }
                                        //           ),
                                        //         series: <ChartSeries>[
                                        //           ColumnSeries<SweetData, String>(
                                        //               dataSource: [
                                        //                 SweetData('ข้อ1', data.sweetchoice1,Colors.pink.shade300,"${data.sweetchoice1} วัน"),
                                        //                 SweetData('ข้อ2', data.sweetchoice2,Colors.pink.shade400,"${data.sweetchoice2} วัน"),
                                        //                 SweetData('ข้อ3', data.sweetchoice3,Colors.pink.shade500,"${data.sweetchoice3} วัน"),
                                        //                 SweetData('ข้อ4', data.sweetchoice4,Colors.pink.shade600,"${data.sweetchoice4} วัน"),
                                        //                 SweetData('ข้อ5', data.sweetchoice5,Colors.pink.shade700,"${data.sweetchoice5} วัน"),
                                        //               ],
                                        //               xValueMapper: (SweetData val, _) => val.continent,
                                        //               yValueMapper: (SweetData val, _) => val.val,
                                        //               dataLabelMapper: (SweetData data, _) => data.label,
                                        //               dataLabelSettings: DataLabelSettings(isVisible: true),
                                        //               pointColorMapper: (SweetData data, _) => data.color
                                        //               // enableTooltip: true
                                        //               )
                                        //         ],
                                        //         primaryXAxis: CategoryAxis(),
                                        //         primaryYAxis: NumericAxis(
                                        //             // edgeLabelPlacement: EdgeLabelPlacement.shift,
                                        //             decimalPlaces: 0,
                                        //             // rangePadding: ChartRangePadding.none,
                                        //             title: AxisTitle(text: 'จำนวนวัน')
                                        //             ),
                                        //       ),
                                        //       Column(
                                        //         crossAxisAlignment: CrossAxisAlignment.start,
                                        //         children:const [
                                        //           Text('ข้อ1  น้ำเปล่า เครื่องดื่มไม่ผสมน้ำตาล'),
                                        //           Text("ข้อ2  น้ำอัดลม เครื่องดื่มชง น้ำหวาน นมเปรี้ยว"),
                                        //           Text("ข้อ3  น้ำผักผลไม้สำเร็จรูป"),
                                        //           Text("ข้อ4  ไอศกรีม เบเกอรี่ หรือขนมไทย"),
                                        //           Text("ข้อ5  เติมน้ำตาล น้ำผึ้ง น้ำเชือมเพิ่มในอาหาร"),
                                        //         ],
                                        //       ),
                                        //       SizedBox(height: 20,)
                                        //       ]
                                        //       ),
                                        //           shape: RoundedRectangleBorder(
                                        //            borderRadius: BorderRadius.circular(20)),
                                        //   ),
                                        // ),


                                        // Container(
                                        //  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                        //   child: Card(
                                        //     child: 
                                        //       Column(
                                        //         children: <Widget>[
                                        //           const SizedBox(height: 10,),
                                        //           const Text("อาหารรสมัน",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                        //           const SizedBox(height: 5,),
                                        //           Column(
                                        //             children: [
                                        //               if(data.totalday > 0)...[
                                        //                     const SizedBox(height: 10,),
                                        //                     Text("จากการเลือกวันที่ ${DateThai(data.StartDate)} ถึงวันที่ ${DateThai(data.EndDate)}"),
                                        //                     Text("จำนวนวันที่มีการบันทีก ${data.totalday} วัน"),
                                        //                     const SizedBox(height: 10,),
                                        //               ]
                                        //             ],
                                        //           ),                                              
                                        //     SfCartesianChart(
                                        //         // title: ChartTitle(text: 'อาหารรสมัน'),
                                        //         legend: Legend(isVisible: false),
                                        //         tooltipBehavior: TooltipBehavior(enable: true),
                                        //         series: <ChartSeries>[
                                        //           ColumnSeries<FatData, String>(
                                        //               dataSource: [
                                        //                 FatData('ข้อ1', data.fatchoice1,Colors.yellow.shade300,"${data.fatchoice1} วัน"),
                                        //                 FatData('ข้อ2', data.fatchoice2,Colors.yellow.shade400,"${data.fatchoice2} วัน"),
                                        //                 FatData('ข้อ3', data.fatchoice3,Colors.yellow.shade500,"${data.fatchoice3} วัน"),
                                        //                 FatData('ข้อ4', data.fatchoice4,Colors.yellow.shade600,"${data.fatchoice4} วัน"),
                                        //                 FatData('ข้อ5', data.fatchoice5,Colors.yellow.shade700,"${data.fatchoice5} วัน"),
                                        //               ],
                                        //               xValueMapper: (FatData val, _) => val.continent,
                                        //               yValueMapper: (FatData val, _) => val.val,
                                        //               dataLabelMapper: (FatData data, _) => data.label,
                                        //               dataLabelSettings: DataLabelSettings(isVisible: true),
                                        //                pointColorMapper: (FatData data, _) => data.color
                                        //               // enableTooltip: true
                                        //               )
                                        //         ],
                                        //         primaryXAxis: CategoryAxis(),
                                        //         primaryYAxis: NumericAxis(
                                        //             // edgeLabelPlacement: EdgeLabelPlacement.shift,
                                        //             decimalPlaces: 0,
                                        //             // rangePadding: ChartRangePadding.none,
                                        //             title: AxisTitle(text: 'จำนวนวัน')
                                        //             ),
                                        //     ),
                                        //       Column(
                                        //         crossAxisAlignment: CrossAxisAlignment.start,
                                        //         children:const [
                                        //           Text('ข้อที่1  เนื้อติดมัน ติดหนัง'),
                                        //           Text("ข้อที่2  อาหารทอด ฟาสฟู๊ด ผัดน้ำมัน"),
                                        //           Text("ข้อที่3  อาหารจานเดียวไขมันสูง หรือแกงกะทิ"),
                                        //           Text("ข้อที่4  เครื่องดื่มผสม นมข้นหวาน ครีมเทียม วิปปิ้งครีม"),
                                        //           Text("ข้อที่5  ซดน้ำผัด น้ำแกง หรือราดลงในข้าว"),
                                        //         ],
                                        //       ),
                                        //       SizedBox(height: 20,)                                          
                                        //       ]
                                        //       ),
                                        //           shape: RoundedRectangleBorder(
                                        //            borderRadius: BorderRadius.circular(20)),
                                        //   ),
                                        // ),

                                        // Container(
                                        //  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                        //   child: Card(
                                        //     child: 
                                        //       Column(
                                        //         children: <Widget>[
                                        //           const SizedBox(height: 10,),
                                        //           const Text("อาหารรสเค็ม",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                        //           const SizedBox(height: 5,),
                                        //           Column(
                                        //             children: [
                                        //               if(data.totalday > 0)...[
                                        //                     const SizedBox(height: 10,),
                                        //                     Text("จากการเลือกวันที่ ${DateThai(data.StartDate)} ถึงวันที่ ${DateThai(data.EndDate)}"),
                                        //                     Text("จำนวนวันที่มีการบันทีก ${data.totalday} วัน"),
                                        //                     const SizedBox(height: 10,),
                                        //               ]
                                        //             ],
                                        //           ),                                                                                       
                                        //     SfCartesianChart(
                                        //         // title: ChartTitle(text: 'อาหารรสเค็ม'),
                                        //         legend: Legend(isVisible: false),
                                        //         tooltipBehavior: TooltipBehavior(enable: true),
                                        //         series: <ChartSeries>[
                                        //           ColumnSeries<SaltData, String>(
                                        //               dataSource: [
                                        //                 SaltData('ข้อ1', data.saltchoice1,Colors.blue.shade300,"${data.saltchoice1} วัน"),
                                        //                 SaltData('ข้อ2', data.saltchoice2,Colors.blue.shade400,"${data.saltchoice2} วัน"),
                                        //                 SaltData('ข้อ3', data.saltchoice3,Colors.blue.shade500,"${data.saltchoice3} วัน"),
                                        //                 SaltData('ข้อ4', data.saltchoice4,Colors.blue.shade600,"${data.saltchoice4} วัน"),
                                        //                 SaltData('ข้อ5', data.saltchoice5,Colors.blue.shade700,"${data.saltchoice5} วัน"),
                                        //               ],
                                        //               xValueMapper: (SaltData val, _) => val.continent,
                                        //               yValueMapper: (SaltData val, _) => val.val,
                                        //               dataLabelMapper: (SaltData data, _) => data.label,
                                        //               dataLabelSettings: DataLabelSettings(isVisible: true),
                                        //               pointColorMapper: (SaltData data, _) => data.color
                                        //               // enableTooltip: true
                                        //               )
                                        //         ],
                                        //         primaryXAxis: CategoryAxis(),
                                        //         primaryYAxis: NumericAxis(
                                        //             // edgeLabelPlacement: EdgeLabelPlacement.shift,
                                        //             decimalPlaces: 0,
                                        //             // rangePadding: ChartRangePadding.none,
                                        //             title: AxisTitle(text: 'จำนวนวัน')
                                        //             ),
                                        //     ),
                                        //       Column (
                                        //         crossAxisAlignment: CrossAxisAlignment.start,
                                        //         children:const [
                                        //           Text('ข้อที่1  ชิมอาหารก่อนปรุง ปรุงน้อยหรือไม่ปรุงเพิ่ม'),
                                        //           Text("ข้อที่2  ใช้สมุนไพรหรือเครื่องเทศแทนเครื่องปรุง"),
                                        //           Text("ข้อที่3  เนื้อสัตว์แปรรูป"),
                                        //           Text("ข้อที่4  อาหารสำเร็จรูป"),
                                        //           Text("ข้อที่5  ผักผลไม้ของดอง หรือ ผลไม้จิ้มพริกเกลือ น้ำปลาหวาน"),
                                        //         ],
                                        //       ),
                                        //       SizedBox(height: 20,)
                                        //       ]
                                        //       ),
                                        //           shape: RoundedRectangleBorder(
                                        //            borderRadius: BorderRadius.circular(20)),
                                        //   ),
                                        // )
           
           
                   ],),
               ),
             ),
           ));
  }
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) 
  {
    // if(dateRangePickerSelectionChangedArgs)
    print(dateRangePickerSelectionChangedArgs.value);
    // fig this
  }
}

class ValueData {
  ValueData(this.continentAllFood, this.value, this.label);
  final String continentAllFood;
  final String label;
  final num value;
}
class SweetData {
  SweetData(this.continent, this.val, this.color ,this.label);
  final String continent;
  final num val;
  final String label;
  final Color color;
}
class FatData {
  FatData(this.continent, this.val, this.color,this.label);
  final String continent;
  final num val;
  final String label;
  final Color color;
}
class SaltData {
  SaltData(this.continent, this.val, this.color,this.label);
  final String continent;
  final num val;
  final String label;
  final Color color;
}








