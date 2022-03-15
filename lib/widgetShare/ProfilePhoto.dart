import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget proFileShow(context, String path) {
  return FutureBuilder<String>(
      future: FirebaseStorage.instance.ref(path).getDownloadURL(),
      builder: (context, snap) {
        if (snap.hasData) {
          return CircleAvatar(
            radius: 48, // Image radius
            backgroundImage: Image.network(snap.data).image,
          );
        } else {
          return CircleAvatar(
            radius: 48, // Image radius
            // backgroundImage: Image.network(snap.data).image,
          );
        }
      });
}

Widget proFilePostShow(context, String path) {
  return FutureBuilder<String>(
      future: FirebaseStorage.instance.ref(path).getDownloadURL(),
      builder: (context, snap) {
        if (snap.hasData) {
          return Image.network(
            snap.data,
            width: 160,
            height: 160,
          );
          // return CircleAvatar(
          //   radius: 48, // Image radius
          //   backgroundImage: Image.network(snap.data).image,
          // );
        } else {
          return CircleAvatar(
            radius: 48, // Image radius
            // backgroundImage: Image.network(snap.data).image,
          );
        }
      });
}
