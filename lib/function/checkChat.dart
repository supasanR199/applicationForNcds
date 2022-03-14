import 'package:appilcation_for_ncds/function/DisplayTime.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget checkChat(String groupChatId) {
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Messages")
          .doc(groupChatId)
          .collection(groupChatId)
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.docs.isEmpty) {
            return Text("");
          }
          return Text(
            snapshot.data.docs.first.get("content"),
            style: TextStyle(fontSize: 14, color: Colors.black38),
          );
        }

        return Text("กำลังโหลด");
      });
}

Widget checkChatTime(String groupChatId) {
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Messages")
          .doc(groupChatId)
          .collection(groupChatId)
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.docs.isEmpty) {
            return Text("");
          }
          return Text(
            chatTime(int.parse(snapshot.data.docs.first.get("timestamp"))),
            style: TextStyle(fontSize: 14, color: Colors.black38),
          );
        }

        return Text("กำลังโหลด");
      });
}
