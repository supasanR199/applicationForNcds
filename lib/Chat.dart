import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom extends StatefulWidget {
  var chatTo;
  var groupChatId;
  var currentHas;
  var peerHas;
  var currentId;
  var peerId;
  ChatRoom(
      {Key key,
      @required this.chatTo,
      @required this.groupChatId,
      @required this.currentHas,
      @required this.peerHas,
      @required this.peerId,
      @required this.currentId})
      : super(key: key);

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        'แชทสนทนากับ ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  Center(),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3, color: Colors.blue),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3, color: Colors.blue),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: FloatingActionButton(
                          onPressed: () {},
                          tooltip: 'Create',
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
