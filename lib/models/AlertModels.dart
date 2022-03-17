import 'dart:convert';

import 'package:flutter/material.dart';

class AlertModels {
  String date;
  bool isAlert;
  int fatalert;
  int saltalert;
  int sweetalert;
  AlertModels(
      {@required this.isAlert,
      @required this.fatalert,
      @required this.saltalert,
      @required this.sweetalert,
      @required this.date});

  Map<String, dynamic> toMap() {
    return {
      'isAlert': isAlert,
      'fatalert': fatalert,
      'saltalert': saltalert,
      'sweetalert': sweetalert,
      "date": date,
    };
  }

  factory AlertModels.fromMap(Map<String, dynamic> map) {
    return AlertModels(
      date: map['Date'] ?? '',
      isAlert: map['alert'] ?? '',
      fatalert: map['fatalert'] ?? '',
      saltalert: map['saltalert'] ?? '',
      sweetalert: map['sweetalert'] ?? '',
    );
  }
  String toJson() => json.encode(toMap());

  factory AlertModels.fromJson(String source) =>
      AlertModels.fromMap(json.decode(source));

  dynamic getByName(String name) {
    if (name == "isAlert") {
      return this.isAlert;
    } else if (name == "fatalert") {
      return this.fatalert;
    } else if (name == "saltalert") {
      return this.saltalert;
    } else if (name == "sweetalert") {
      return this.sweetalert;
    } else if (name == "date") {
      return this.date;
    }
  }
}
