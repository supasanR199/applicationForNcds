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
  var _docRef = FirebaseFirestore.instance
      .collection('UserWeb')
      .where('role', isNotEqualTo: 'admin');
  var docId;
  int index;
  Widget build(BuildContext context) {
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
                      child: StreamBuilder<QuerySnapshot>(
                          stream:
                              _docRef.where('email', isNull: null).snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            return ListView(
                              children: snapshot.data.docs
                                  .map((DocumentSnapshot document ) {
                                Map<String, dynamic> snap =
                                    document.data() as Map<String, dynamic>;
                                return ListTile(
                                  title: Text("${snap["name"]}"),
                                  subtitle: Text("${snap["surname"]}"),
                                  trailing: Switch(
                                    value: snap["status"],
                                    onChanged: (value) {
                                      docId = (snapshot.data.docs.map((e) => e.reference).toList());
                                      print("DocumentReference<Map<String, dynamic>>(UserWeb/"+document.id+")");
                                      // for find index in DocmentReference.
                                      for(int i=0; i < docId.length; i++){
                                        if(docId[i].toString() == "DocumentReference<Map<String, dynamic>>(UserWeb/"+document.id+")"){
                                          index = i;
                                        }
                                      }
                                      FirebaseFirestore.instance
                                          .runTransaction((transaction) async {
                                        DocumentSnapshot freshSnap =
                                            await transaction.get(docId[index]);
                                        await transaction.update(
                                            freshSnap.reference,
                                            {"status": value});
                                      });
                                    },
                                    activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: Colors.green,
                                  ),
                                );
                              }).toList(),
                            );
                          }),
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
