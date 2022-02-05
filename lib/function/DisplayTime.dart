import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat("dd-MM-yyyy");
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