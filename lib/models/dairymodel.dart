import 'dart:convert';

import 'package:flutter/material.dart';

class DairyModel {
  String date;
  String fatchoice1;
  String fatchoice2;
  String fatchoice3;
  String fatchoice4;
  String fatchoice5;
  String saltchoice1;
  String saltchoice2;
  String saltchoice3;
  String saltchoice4;
  String saltchoice5;
  String sweetchoice1;
  String sweetchoice2;
  String sweetchoice3;
  String sweetchoice4;
  String sweetchoice5;
  String mood1;
  String mood2;
  String mood3;
  String mood4;
  String mood5;
  String Totalmood;
  DairyModel({
    this.date,
    this.fatchoice1,
    this.fatchoice2,
    this.fatchoice3,
    this.fatchoice4,
    this.fatchoice5,
    this.saltchoice1,
    this.saltchoice2,
    this.saltchoice3,
    this.saltchoice4,
    this.saltchoice5,
    this.sweetchoice1,
    this.sweetchoice2,
    this.sweetchoice3,
    this.sweetchoice4,
    this.sweetchoice5,
    this.mood1,
    this.mood2,
    this.mood3,
    this.mood4,
    this.mood5,
    this.Totalmood,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'fatchoice1': fatchoice1,
      'fatchoice2': fatchoice2,
      'fatchoice3': fatchoice3,
      'fatchoice4': fatchoice4,
      'fatchoice5': fatchoice5,
      'saltchoice1': saltchoice1,
      'saltchoice2': saltchoice2,
      'saltchoice3': saltchoice3,
      'saltchoice4': saltchoice4,
      'saltchoice5': saltchoice5,
      'sweetchoice1': sweetchoice1,
      'sweetchoice2': sweetchoice2,
      'sweetchoice3': sweetchoice3,
      'sweetchoice4': sweetchoice4,
      'sweetchoice5': sweetchoice5,
      'mood1': mood1,
      'mood2': mood2,
      'mood3': mood3,
      'mood4': mood4,
      'mood5': mood5,
      'Totalmood': Totalmood,
    };
  }

  factory DairyModel.fromMap(Map<String, dynamic> map) {
    return DairyModel(
      date: map['date'] ?? '',
      fatchoice1: map['fatchoice1'] ?? '',
      fatchoice2: map['fatchoice2'] ?? '',
      fatchoice3: map['fatchoice3'] ?? '',
      fatchoice4: map['fatchoice4'] ?? '',
      fatchoice5: map['fatchoice5'] ?? '',
      saltchoice1: map['saltchoice1'] ?? '',
      saltchoice2: map['saltchoice2'] ?? '',
      saltchoice3: map['saltchoice3'] ?? '',
      saltchoice4: map['saltchoice4'] ?? '',
      saltchoice5: map['saltchoice5'] ?? '',
      sweetchoice1: map['sweetchoice1'] ?? '',
      sweetchoice2: map['sweetchoice2'] ?? '',
      sweetchoice3: map['sweetchoice3'] ?? '',
      sweetchoice4: map['sweetchoice4'] ?? '',
      sweetchoice5: map['sweetchoice5'] ?? '',
      mood1: map['mood1'] ?? '',
      mood2: map['mood2'] ?? '',
      mood3: map['mood3'] ?? '',
      mood4: map['mood4'] ?? '',
      mood5: map['mood5'] ?? '',
      Totalmood: map['Totalmood'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DairyModel.fromJson(String source) =>
      DairyModel.fromMap(json.decode(source));
  String getByName(String name) {
    if (name == "date") {
      return this.date;
    } else if (name == "fatchoice1") {
      return this.fatchoice1;
    } else if (name == "fatchoice2") {
      return this.fatchoice2;
    } else if (name == "fatchoice3") {
      return this.fatchoice3;
    } else if (name == "fatchoice4") {
      return this.fatchoice4;
    } else if (name == "fatchoice5") {
      return this.fatchoice5;
    } else if (name == "saltchoice1") {
      return this.saltchoice1;
    } else if (name == "saltchoice2") {
      return this.saltchoice2;
    } else if (name == "saltchoice3") {
      return this.saltchoice3;
    } else if (name == "saltchoice4") {
      return this.saltchoice4;
    } else if (name == "saltchoice5") {
      return this.saltchoice5;
    } else if (name == "sweetchoice1") {
      return this.sweetchoice1;
    } else if (name == "sweetchoice2") {
      return this.sweetchoice2;
    } else if (name == "sweetchoice3") {
      return this.sweetchoice3;
    } else if (name == "sweetchoice4") {
      return this.sweetchoice4;
    } else if (name == "sweetchoice5") {
      return this.sweetchoice5;
    }
  }
}
