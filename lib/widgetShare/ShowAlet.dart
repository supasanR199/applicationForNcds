import 'package:appilcation_for_ncds/function/getRecordPatient.dart';
import 'package:appilcation_for_ncds/models/dairymodel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
            // print(value);
          },
          onSubmit: (Object val) {
            dateBetween = getDaysInBetween(startDate, endDate);
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
