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

Widget showDateRang(context,DateTime minDate) {
  return AlertDialog(
    title: const Text('เลือกช่วงเวลา'),
    content: SizedBox(
      width: 300,
      height: 300,
      child: SfDateRangePicker(
        monthViewSettings:
            DateRangePickerMonthViewSettings(firstDayOfWeek: DateTime.sunday),
        selectionMode: DateRangePickerSelectionMode.range,
        maxDate: DateTime.now(),
        minDate: minDate,
      ),
    ),
  );
}
