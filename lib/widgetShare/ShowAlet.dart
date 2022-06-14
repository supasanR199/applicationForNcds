import 'package:appilcation_for_ncds/function/getRecordPatient.dart';
import 'package:appilcation_for_ncds/models/AlertModels.dart';
import 'package:appilcation_for_ncds/models/AlertMoodModels.dart';
import 'package:appilcation_for_ncds/models/KeepRecord.dart';
import 'package:appilcation_for_ncds/models/dairymodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Widget alertMessage(context, String e) {
  return AlertDialog(
    title: const Text('แจ้งเตือน'),
    content: Text(e),
    actions: <Widget>[
      TextButton(
        onPressed: () => Navigator.pop(context, 'CONFIRM'),
        child: const Text('ยืนยัน'),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, 'CANCEL'),
        child: const Text('ยกเลิก'),
      ),
    ],
  );
}

Widget alertMessageOnlyOk(context, String e) {
  return AlertDialog(
    title: const Text('แจ้งเตือน'),
    content: Text(e),
    actions: <Widget>[
      TextButton(
        onPressed: () => Navigator.pop(context, 'CONFIRM'),
        child: const Text('ยืนยัน'),
      ),
    ],
  );
}

Widget showDateRangWalkCount(
    context, DateTime minDate, DateTime maxDate, List<KeepChoieAndSocre> snap
    // List<DairyModel> snap
    ) {
  DateRangePickerController _datePickerController = DateRangePickerController();
  List<DateTime> dateBetween = List();
  DateTime startDate;
  DateTime endDate;
  List<DateTime> specialDates = List();
  snap.forEach((e) {
    specialDates.add(DateTime.parse(e.choice));
  });
  if (minDate == maxDate) {
    maxDate = DateTime.now();
  }
  return AlertDialog(
    title: const Text('เลือกช่วงวัน'),
    content: SizedBox(
      width: 300,
      height: 300,
      child: SfDateRangePicker(
          monthViewSettings: DateRangePickerMonthViewSettings(
              firstDayOfWeek: DateTime.sunday, specialDates: specialDates),
          monthCellStyle: DateRangePickerMonthCellStyle(
            specialDatesDecoration: BoxDecoration(
                // color: Colors.blueAccent,
                border: Border.all(color: Colors.blueAccent, width: 2),
                shape: BoxShape.circle),
          ),
          selectionMode: DateRangePickerSelectionMode.range,
          maxDate: maxDate,
          minDate: minDate,
          showActionButtons: true,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            final dynamic value = args.value;
            startDate = args.value.startDate;
            endDate = args.value.endDate;
          },
          onSubmit: (Object val) {
            if (endDate == null) {
              dateBetween = getDaysInBetween(startDate, startDate);
            } else {
              dateBetween = getDaysInBetween(startDate, endDate);
            }
            print(getStepListSelectDate(snap, dateBetween));
            Navigator.pop(context, getStepListSelectDate(snap, dateBetween));

            _datePickerController.selectedRange = null;
          },
          onCancel: () {
            _datePickerController.selectedRange = null;
            Navigator.pop(context);
          }),
    ),
  );
}
Widget showDateSingleWalkCount(
    context, DateTime minDate, DateTime maxDate, List<KeepChoieAndSocre> snap
    // List<DairyModel> snap
    ) {
  DateRangePickerController _datePickerController = DateRangePickerController();
  List<DateTime> dateBetween = List();
  DateTime startDate;
  DateTime endDate;
  List<DateTime> specialDates = List();
  snap.forEach((e) {
    specialDates.add(DateTime.parse(e.choice));
  });
  if (minDate == maxDate) {
    maxDate = DateTime.now();
  }
  return AlertDialog(
    title: const Text('เลือกช่วงวัน'),
    content: SizedBox(
      width: 300,
      height: 300,
      child: SfDateRangePicker(
          monthViewSettings: DateRangePickerMonthViewSettings(
              firstDayOfWeek: DateTime.sunday, specialDates: specialDates),
          monthCellStyle: DateRangePickerMonthCellStyle(
            specialDatesDecoration: BoxDecoration(
                // color: Colors.blueAccent,
                border: Border.all(color: Colors.blueAccent, width: 2),
                shape: BoxShape.circle),
          ),
          selectionMode: DateRangePickerSelectionMode.single,
          maxDate: maxDate,
          minDate: minDate,
          showActionButtons: true,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            final dynamic value = args.value;
            startDate = args.value;
            endDate = args.value;
          },
          onSubmit: (Object val) {
            if (endDate == null) {
              dateBetween = getDaysInBetween(startDate, startDate);
            } else {
              dateBetween = getDaysInBetween(startDate, endDate);
            }
            print(getStepListSelectDate(snap, dateBetween));
            Navigator.pop(context, getStepListSelectDate(snap, dateBetween));

            _datePickerController.selectedRange = null;
          },
          onCancel: () {
            _datePickerController.selectedRange = null;
            Navigator.pop(context);
          }),
    ),
  );
}

Widget showDateRang(
    context, DateTime minDate, DateTime maxDate, List<DairyModel> snap) {
  DateRangePickerController _datePickerController = DateRangePickerController();
  List<DateTime> dateBetween = List();
  DateTime startDate;
  DateTime endDate;
  if (minDate == maxDate) {
    maxDate = DateTime.now();
  }
  return AlertDialog(
    title: const Text('เลือกช่วงวัน'),
    content: SizedBox(
      width: 300,
      height: 300,
      child: SfDateRangePicker(
          monthViewSettings:
              DateRangePickerMonthViewSettings(firstDayOfWeek: DateTime.sunday),
          selectionMode: DateRangePickerSelectionMode.range,
          maxDate: maxDate,
          minDate: minDate,
          showActionButtons: true,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            final dynamic value = args.value;
            startDate = args.value.startDate;
            endDate = args.value.endDate;
          },
          onSubmit: (Object val) {
            if (endDate == null) {
              dateBetween = getDaysInBetween(startDate, startDate);
            } else {
              dateBetween = getDaysInBetween(startDate, endDate);
            }
            // print(getValueFromDateRang(snap, dateBetween));
            Navigator.pop(context, getValueFromDateRang(snap, dateBetween));

            _datePickerController.selectedRange = null;
          },
          onCancel: () {
            _datePickerController.selectedRange = null;
            Navigator.pop(context);
          }),
    ),
  );
}

Widget showDateRangMood(
    context, DateTime minDate, DateTime maxDate, List<AlertMoodModels> snap) {
  DateRangePickerController _datePickerController = DateRangePickerController();
  List<DateTime> dateBetween = List();
  DateTime startDate;
  DateTime endDate;
  if (minDate == maxDate) {
    maxDate = DateTime.now();
  }
  return AlertDialog(
    title: const Text('เลือกช่วงวัน'),
    content: SizedBox(
      width: 300,
      height: 300,
      child: SfDateRangePicker(
          monthViewSettings:
              DateRangePickerMonthViewSettings(firstDayOfWeek: DateTime.sunday),
          selectionMode: DateRangePickerSelectionMode.single,
          maxDate: maxDate,
          minDate: minDate,
          showActionButtons: true,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            final dynamic value = args.value;
            startDate = args.value;
            // endDate = args.value.endDate;
            // print(args.value);
          },
          onSubmit: (Object val) {
            if (endDate == null) {
              // print(1);
              dateBetween = getDaysInBetween(startDate, startDate);
            } else {
              dateBetween = getDaysInBetween(startDate, endDate);
            }
            // print(getValueFromDateRang(snap, dateBetween));
            Navigator.pop(context, dateBetween);

            _datePickerController.selectedRange = null;
          },
          onCancel: () {
            _datePickerController.selectedRange = null;
            Navigator.pop(context);
          }),
    ),
  );
}

Widget selectIsMoodHaveData(context, List<DateTime> initDateHaveData,
    AsyncSnapshot<QuerySnapshot<Object>> snapshotMood) {
  DateRangePickerController _datePickerController = DateRangePickerController();
  List<DateTime> dateBetween = List();
  var snapMood;

  // if (minDate == maxDate) {
  //   maxDate = DateTime.now();
  // }
  print(initDateHaveData.toList());
  return AlertDialog(
    title: const Text('เลือกช่วงวัน'),
    content: SizedBox(
      width: 300,
      height: 300,
      child: SfDateRangePicker(
          confirmText: "ตกลง",
          cancelText: "ยกเลิก",
          // initialSelectedDates: initDateHaveData,
          selectionMode: DateRangePickerSelectionMode.single,
          // maxDate: initDateHaveData.last,
          // minDate: initDateHaveData.first,
          monthViewSettings:
              DateRangePickerMonthViewSettings(specialDates: initDateHaveData),
          monthCellStyle: DateRangePickerMonthCellStyle(
            specialDatesDecoration: BoxDecoration(
                // color: Colors.green,
                border: Border.all(color: Colors.blueAccent, width: 2),
                shape: BoxShape.circle),
          ),
          showActionButtons: true,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            // final dynamic value = args.value;
          },
          onSubmit: (Object val) {
            if (val != null) {
              snapMood = getMoodAlert(val, snapshotMood);
              // print(snapMood);
              Navigator.pop(context, snapMood);
            }
          },
          onCancel: () {
            Navigator.pop(context);
          }),
    ),
  );
}

Widget showProcess(context, UploadTask value) {
  bool isShowProgress = true;
  return AlertDialog(
      title: Text("อัปโหลด"),
      content: SizedBox(
        width: 300,
        height: 150,
        child: StreamBuilder<TaskSnapshot>(
          stream: value.snapshotEvents,
          builder: (context, snapshot) {
            var gerPerset =
                (snapshot.data.bytesTransferred / snapshot.data.totalBytes) *
                    100;
            if (gerPerset == 100) {
              isShowProgress = false;
            } else {
              isShowProgress = true;
            }
            return Column(
              children: [
                Text("$gerPerset%"),
                Visibility(
                  visible: isShowProgress,
                  child: LinearProgressIndicator(
                    value: ((snapshot.data.bytesTransferred /
                                snapshot.data.totalBytes) *
                            100) /
                        100,
                    // valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
                Visibility(
                  visible: !isShowProgress,
                  child: Column(children: [
                    Icon(Icons.cloud_upload),
                    Text("อัปโหบดเสร็จแล้ว")
                  ]),
                ),
              ],
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'CONFIRM'),
          child: const Text('ยืนยัน'),
        ),
      ]);
}
