import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

checkRoletoThai(String role) {
  if (role == "hospital") {
    return "บุลากร รพสต.";
  } else if (role == "medicalpersonnel") {
    return "บุคลากรทางการแพทย์";
  } else if (role == "Patient") {
    return "ผู้ป่วย";
  } else if (role == "Volunteer") {
    return "อสม.";
  }
}

String checkDisease(List disease) {
  List toString = List();
  String _returnString;
  disease.forEach((element) {
    if (element == "pressure") {
      toString.add("โรคความดัน");
    } else if (element == "diabetes") {
      toString.add("โรคเบาหวาน");
    } else if (element == "fat") {
      toString.add("โรคอ้วน");
    }
  });
  _returnString = toString
      .toString()
      .replaceAll("[", "")
      .replaceAll("]", "");
      // .replaceAll(",", "");
  return _returnString;
}

