import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget showWhoIs(
  context,
  String volunteerId,
) {
  return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("MobileUser")
          .doc(volunteerId)
          .get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
        if (snap.hasData) {
          var _user = snap.data.data() as Map<String, dynamic>;
          return Text(
              "ผู้ลงพื้นที่คือ ${_user["Firstname"] + " " + _user["Lastname"]}");
        } else {
          return Text("กำลังโหลด");
        }
      });
}
