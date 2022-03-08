import 'package:appilcation_for_ncds/function/getRecordPatient.dart';
import 'package:appilcation_for_ncds/models/dairymodel.dart';
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
    title: const Text('เลือกช่วงเวลา'),
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
              dateBetween = getDaysInBetween(startDate, DateTime.now());
            } else {
              dateBetween = getDaysInBetween(startDate, endDate);
            }
            print(getValueFromDateRang(snap, dateBetween));
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
