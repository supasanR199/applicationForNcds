import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String convertDateTimeDisplay(String date) {
  final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat serverFormater = DateFormat("dd-MM-yyyy");
  final DateTime displayDate = displayFormater.parse(date);
  final String formatted = serverFormater.format(displayDate);
  return formatted;
}

String convertDateTimeDisplayAndTime(Timestamp date) {
  var dt = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);
  var d12 =
      DateFormat('MM/dd/yyyy, hh:mm a').format(dt); // 12/31/2000, 10:00 PM
  var d24 = DateFormat('dd/MM/yyyy, HH:mm').format(dt); // 31/12/2000, 22:00
  // print(date);
  // final String formatted = "222";
  return d24;
}

String convertTimeDisplay(Timestamp date) {
  var dt = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);
  var d12 =
      DateFormat('MM/dd/yyyy, hh:mm a').format(dt); // 12/31/2000, 10:00 PM
  var d24 = DateFormat('HH:mm').format(dt); // 31/12/2000, 22:00
  // final String formatted = "222";
  return d24;
}

String calCreateDay(String _date) {
  String pattern = "dd-MM-yyyy";
  DateTime date = DateFormat(pattern).parse(_date);
  DateTime today = DateTime.now();
 
 
  var daydiff = today.day - date.day;
  var day = daydiff.toString().replaceAll("-", "");
  return day;
}

String convertDateToString(String date) {
  final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat serverFormater = DateFormat("yyyy-MM-dd");
  final DateTime displayDate = displayFormater.parse(date);
  final String formatted = serverFormater.format(displayDate);
  return formatted;
}

String calAge(String birthDayString) {
  String pattern = "dd-MM-yyyy";
  DateTime birthDay = DateFormat(pattern).parse(birthDayString);
  DateTime today = DateTime.now();
  var yeardiff = today.year - birthDay.year;
  // print(birthDay);
  // print(today.year);
  // print(birthDay.year);

  // var daydiff = today.day - birthDay.day;

  return yeardiff.toString();
}

int calTimeInUse(DateTime loginTime, DateTime logoutTime) {
  // var _loginTimeData =
  //     DateTime.fromMillisecondsSinceEpoch(loginTime.millisecondsSinceEpoch);
  // var _logoutTimeData =
  //     DateTime.fromMillisecondsSinceEpoch(logoutTime.millisecondsSinceEpoch);
  // var _loginTime = DateFormat('MM/dd/yyyy, hh:mm a').format(_loginTimeData);
  // var _logoutTime = DateFormat('MM/dd/yyyy, hh:mm a').format(_logoutTimeData);
 
  return (logoutTime.difference(loginTime).inHours / 24).round();
}

String chatTime(int date) {
  var d24 = DateFormat('dd/MM/yyyy, HH:mm')
      .format(DateTime.fromMillisecondsSinceEpoch(date));
  return d24;
}
 
String convertMouth(DateTime date) {
  // var dt = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);
  var d12 =DateFormat('MM/dd/yyyy, hh:mm a').format(date); // 12/31/2000, 10:00 PM
  var d24 = DateFormat('yyyy-M').format(date); // 31/12/2000, 22:00
  // final String formatted = "222";
  return d24;
}
String convertDay(DateTime date) {
  // var dt = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);
  var d12 =DateFormat('MM/dd/yyyy, hh:mm a').format(date); // 12/31/2000, 10:00 PM
  var d24 = DateFormat('yyyy-MM-dd').format(date); // 31/12/2000, 22:00
  // final String formatted = "222";
  return d24;
}