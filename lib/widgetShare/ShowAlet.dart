import 'package:flutter/material.dart';

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
