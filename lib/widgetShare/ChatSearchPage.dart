import 'dart:developer';

import 'package:appilcation_for_ncds/Chat.dart';
import 'package:appilcation_for_ncds/function/checkChat.dart';
import 'package:appilcation_for_ncds/function/checkRole.dart';
import 'package:appilcation_for_ncds/widgetShare/ProfilePhoto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatSearchPage extends StatefulWidget {
  const ChatSearchPage({Key key}) : super(key: key);

  @override
  State<ChatSearchPage> createState() => _ChatSearchPageState();
}

class _ChatSearchPageState extends State<ChatSearchPage> {
  @override
  final auth = FirebaseAuth.instance;
  String groupChatId;
  String groupChatIds;
  TextEditingController _searchController = TextEditingController();
  String searchText = '';
  List<DocumentSnapshot> documents = [];

  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 700,
        width: 800,
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                child: Text(
                  'รายชื่อแชทสนทนา',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'ค้นหา',
                  enabledBorder: OutlineInputBorder(
                    // borderSide: const BorderSide(width: 3, color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderSide: const BorderSide(width: 3, color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("MobileUser")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    documents = snapshot.data.docs;
                    documents.forEach((e) {});
                    if (searchText.length > 0) {
                      documents = documents.where((element) {
                        return element
                            .get('Firstname')
                            .toString()
                            .toLowerCase()
                            .contains(searchText.toLowerCase());
                      }).toList();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            var currentHas = auth.currentUser.uid.hashCode;
                            var peerHas = documents[index].id.hashCode;
                            var currentId = auth.currentUser.uid;
                            var peerId = documents[index].id;
                            if (currentHas <= peerHas) {
                              groupChatIds = '$currentId-$peerId';
                            } else {
                              groupChatIds = '$peerId-$currentId';
                            }
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 60),
                              child: Column(
                                children: [
                                  ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    leading: proFileShow(
                                        context,
                                        documents[index]["Img"],
                                        "${documents[index]["Gender"]}"),
                                    title: Text(
                                        "${documents[index]["Firstname"]}  ${documents[index]["Lastname"]} (${checkRoletoThai(documents[index]["Role"])})"),
                                    subtitle: checkChat(groupChatIds),
                                    trailing: checkChatTime(groupChatIds),
                                    hoverColor: Colors.grey.shade200,
                                    onTap: () async {
                                      var currentHas =
                                          auth.currentUser.uid.hashCode;
                                      var peerHas =
                                          documents[index].id.hashCode;
                                      var currentId = auth.currentUser.uid;
                                      var peerId = documents[index].id;
                                      if (currentHas <= peerHas) {
                                        groupChatId = '$currentId-$peerId';
                                      } else {
                                        groupChatId = '$peerId-$currentId';
                                      }

                                      print(
                                          "show gruop chat ${groupChatId} currentHas ${currentHas}  peerHas ${peerHas}");
                                      await FirebaseFirestore.instance
                                          .collection("Messages")
                                          .doc(groupChatId);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatRoom(
                                            chatTo: documents[index],
                                            groupChatId: groupChatId,
                                            currentId: currentId,
                                            peerHas: peerHas,
                                            peerId: peerId,
                                            currentHas: currentHas,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  } else {
                    return Center(
                      child: Text("กำลังโหลดข้อมูล"),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
    );
  }
}
