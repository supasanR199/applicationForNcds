import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget proFileShow(context, String path, String gender) {
  // if (path == "lib/img/not-available.png") {
  //   return CircleAvatar(
  //     radius: 48,
  //     backgroundImage: Image.asset(path).image,
  //   );
  // }
  return FutureBuilder<String>(
      future: FirebaseStorage.instance.ref(path).getDownloadURL(),
      builder: (context, snap) {
        // if (snap.connectionState == ConnectionState.done) {
        //   return new CircularProgressIndicator();
        // }
        if (snap.hasData) {
          return CircleAvatar(
            radius: 48, // Image radius
            backgroundImage: Image.network(snap.data).image,
          );
        } else {
              if (gender == "ชาย") {
              return CircleAvatar(
                radius: 48, // Image radius
                backgroundImage: Image.asset("icon/man.png").image,
              );            
              } else if (gender == "หญิง") {
              return CircleAvatar(
                radius: 48, // Image radius
                backgroundImage: Image.asset("icon/woman.png").image,
              );            
              }else{
              return CircleAvatar(
                radius: 48, // Image radius
                backgroundImage: Image.asset("img/noimage.png").image,
              );
              }
          // return new CircularProgressIndicator();
        }
      });
}

Widget proFilePostShow(context, String path) {
  // if (path == "lib/img/not-available.png") {
  //   return Padding(
  //     padding: EdgeInsets.all(15),
  //     child: Image.asset(
  //       path,
  //       width: 160,
  //       height: 160,
  //     ),
  //   );
  // }
  return FutureBuilder<String>(
      future: FirebaseStorage.instance.ref(path).getDownloadURL(),
      builder: (context, snap) {
        if (snap.hasData) {
          return Container(
               padding:const EdgeInsets.only(left: 15,right: 25),
              child: Image.network(
              snap.data,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
                                      );
          // Padding(
          //   padding: EdgeInsets.all(15),
          //   child: Image.network(
          //     snap.data,
          //     width: 160,
          //     height: 160,
          //   ),
          // );
          // return CircleAvatar(
          //   radius: 48, // Image radius
          //   backgroundImage: Image.network(snap.data).image,
          // );
        } else {
          return Container(
               padding:const EdgeInsets.only(left: 15,right: 25),
              child: Image.asset(
              "img/noimage.png",
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
                                      );
        }
      });
}
Widget chatProFileShow(context, String path) {
  // if (path == "lib/img/not-available.png") {
  //   return CircleAvatar(
  //     radius: 48,
  //     backgroundImage: Image.asset(path).image,
  //   );
  // }
  return FutureBuilder<String>(
      future: FirebaseStorage.instance.ref(path).getDownloadURL(),
      builder: (context, snap) {
        // if (snap.connectionState == ConnectionState.done) {
        //   return new CircularProgressIndicator();
        // }
        if (snap.hasData) {
          return CircleAvatar(
            radius: 15, // Image radius
            backgroundImage: Image.network(snap.data).image,
          );
        } else {
          return new CircularProgressIndicator();
        }
      });
}