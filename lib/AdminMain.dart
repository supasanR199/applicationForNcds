import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class adminMain extends StatefulWidget {
  @override
  _adminMainState createState() => _adminMainState();
}

class _adminMainState extends State<adminMain> {
  @override
  Widget build(BuildContext context) {
    bool isSwitched = false;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('UserWeb')
          .where("Status", isEqualTo: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        return Container(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
            ),
            body: Container(
              child: Center(
                child: Card(
                  child: SizedBox(
                    height: 700,
                    width: 1000,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> snap =
                                  document.data() as Map<String, dynamic>;
                              return ListTile(
                                title: Text(snap['name']),
                                subtitle: Text(snap['surname']),
                                trailing: Switch(
                                  value: snapshot.data == null
                                      ? false
                                      : snap["Status"],
                                  onChanged: (value) {
                                    FirebaseFirestore.instance
                                        .runTransaction((transaction) async {
                                      // DocumentSnapshot freshSnap =
                                      //     await transaction
                                      //         .get(FirebaseFirestore
                                      //             .instance
                                      //             .collection('UserWeb')
                                      //             .where("Status",
                                      //                 isEqualTo: false)
                                      //             .snapshots().);
                                      // await transaction.update(
                                      //     freshSnap.reference,
                                      //     {"Status": value});
                                    });
                                  },
                                  activeTrackColor: Colors.lightGreenAccent,
                                  activeColor: Colors.green,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //  margin: EdgeInsets.only(top: 100,bottom: 400,),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget showAllRequest(context) {
    return Card(
      color: Colors.amber,
      child: SizedBox(
        height: 200,
        width: 90,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("data"),
            ),
          ],
        ),
      ),
    );
  }

  Widget testListView() {
    // return ListView(
    //   children: snapshot.data.docs.map((DocumentSnapshot document) {
    //     Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    //     return ListTile(
    //       title: Text(data['full_name']),
    //       subtitle: Text(data['company']),
    //     );
    //   }).toList(),
    // );
  }
}
