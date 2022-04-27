import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAQBUNS_8:APA91bGZw38ZxkB-eLRp-rv5zcR4ibuSvq_e153_kJ83yuc4mLVyoKczf691HeYQp6f4XD-W2t5n97pVZulzsWCs2ohSiu-mkOkQ3wtMktd_pusglR8guT9U1THoFbQkBy2FWs4DSuLD',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      print("send to $token");
    } catch (e) {
      print("error push notification");
    }
  }