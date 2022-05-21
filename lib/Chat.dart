import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appilcation_for_ncds/widgetShare/ChatBubble.dart';

import 'noti.dart';

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
  var fromename;
  var token;
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    //documentId is passed from previous widget
    FirebaseFirestore.instance
        .collection('UserWeb')
        .doc(auth.currentUser.uid)
        .get()
        .then((value) {
      var check = value.data();
      //'value' is the instance of 'DocumentSnapshot'
      //'value.data()' contains all the data inside a document in the form of 'dictionary'
      setState(() {
        //name, image, quantity are the fields of document
        fromename = "${check['Firstname']} ${check['Lastname']}";
      });
    });

    FirebaseFirestore.instance
        .collection('MobileUser')
        .doc(widget.peerId)
        .get()
        .then((value) {
      var data = value.data();
      setState(() {
        token = data["Token"];
        // image = data?["Img"];
        // checkrole = data?["Role"];
        // gen = data?["Gender"];
      });
    });
    super.initState();
  }
  @override
  final _formChat = GlobalKey<FormState>();
  String chatContent;
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          foregroundColor: Colors.blueAccent,
          centerTitle: false,
          backgroundColor: Colors.white,
          title: Text(
            "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
          child: Card(
            child: SizedBox(
              height: 900,
              width: 700,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,bottom: 30
                      ),
                      child: Text(
                        'คุณ ${widget.chatTo['Firstname']} ${widget.chatTo['Lastname']}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Messages")
                            .doc(widget.groupChatId)
                            .collection(widget.groupChatId)
                            .orderBy('timestamp', descending: false)
                            .snapshots(),
                        // ignore: missing_return
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Center(
                              child: ListView(
                                children: snapshot.data.docs
                                    .map((DocumentSnapshot document) {
                                  Map<String, dynamic> snap =
                                      document.data() as Map<String, dynamic>;
                                  var isCurrentUser;
                                  if (snap["idFrom"] == widget.currentId) {
                                    isCurrentUser = true;
                                  } else {
                                    isCurrentUser = false;
                                  }

                                  // print(widget.chatTo['Firstname']);
                                  return ChatBubble(
                                    peerName: widget.chatTo,
                                    text: snap["content"],
                                    isCurrentUser: isCurrentUser,
                                    time: int.parse(snap["timestamp"]),
                                    genderChart: widget.chatTo["Gender"],
                                    // peername: widget.chatTo['Firstname'],
                                  );
                                }).toList(),
                              ),
                            );
                          } else {
                            return Center(
                              child: Text("กำลังโหลดข้อความ"),
                            );
                          }
                        }),
                  ),
                  Row(
                    children: [
                      Form(
                        key: _formChat,
                        child: Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              onChanged: (value) {
                                chatContent = value;
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(width: 5),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          
                          hoverColor: Colors.grey.shade200,
                          backgroundColor: Colors.white,
                          onPressed: () async {
                            if (chatContent != null) {
                              var documentReference = await FirebaseFirestore
                                  .instance
                                  .collection('Messages')
                                  .doc(widget.groupChatId)
                                  .collection(widget.groupChatId)
                                  .doc(DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString());

                              FirebaseFirestore.instance
                                  .runTransaction((transaction) async {
                                await transaction.set(
                                  documentReference,
                                  {
                                    'idFrom': widget.currentId,
                                    'idTo': widget.peerId,
                                    'timestamp': DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    'content': chatContent,
                                  },
                                );
                              });
                          if (token != null) {
                          sendPushMessage("$token", "$chatContent",
                          "คุณ $fromename ส่งข้อความถึงคุณ");
                            }
                              _formChat.currentState.reset();
                            }
                          },
                          // tooltip: 'Create',
                          
                          child: Icon(Icons.send,color: Colors.blueAccent,),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),              
          ),
        ),
      ),
    );
  }
}
