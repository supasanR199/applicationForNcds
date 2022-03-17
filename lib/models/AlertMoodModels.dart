import 'dart:convert';

import 'package:flutter/material.dart';

class AlertMoodModels {
  String date;
  bool isAlert;
  int moodtoday;

  AlertMoodModels(
      {@required this.isAlert, @required this.date, @required this.moodtoday});

  Map<String, dynamic> toMap() {
    return {
      'isAlert': isAlert,
      'date': date,
      'moodtoday': moodtoday,
    };
  }

  factory AlertMoodModels.fromMap(Map<String, dynamic> map) {
    return AlertMoodModels(
      date: map['Date'] ?? '',
      isAlert: map['alert'] ?? '',
      moodtoday: map['moodtoday'] ?? '',
    );
  }
  String toJson() => json.encode(toMap());

  factory AlertMoodModels.fromJson(String source) =>
      AlertMoodModels.fromMap(json.decode(source));

  dynamic getByName(String name) {
    if (name == "isAlert") {
      return this.isAlert;
    } else if (name == "date") {
      return this.date;
    } else if (name == "moodtoday") {
      return this.moodtoday;
    }
  }
}
