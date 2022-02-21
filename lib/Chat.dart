import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  var chatTo;
  ChatRoom({Key key, @required this.chatTo}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
          child: Card(
            child: SizedBox(
              height: 700,
              width: 1000,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        'แชทสนทนากับ ${widget.chatTo["Firstname"]}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
