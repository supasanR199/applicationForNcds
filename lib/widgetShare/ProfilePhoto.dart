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
              backgroundImage: Image.asset("assets/icon/man.png").image,
            );
          } else if (gender == "หญิง") {
            return CircleAvatar(
              radius: 48, // Image radius
              backgroundImage: Image.asset("assets/icon/woman.png").image,
            );
          } else {
            return CircleAvatar(
              radius: 48, // Image radius
              backgroundImage: Image.asset("assets/img/noimage.png").image,
            );
          }
          // return new CircularProgressIndicator();
        }
      });
}
Widget proFileShowChart(context, String path, String gender) {
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
            radius: 30, // Image radius
            backgroundImage: Image.network(snap.data).image,
          );
        } else {
          if (gender == "ชาย") {
            return CircleAvatar(
              radius: 30, // Image radius
              backgroundImage: Image.asset("assets/icon/man.png").image,
            );
          } else if (gender == "หญิง") {
            return CircleAvatar(
              radius: 30, // Image radius
              backgroundImage: Image.asset("assets/icon/woman.png").image,
            );
          } else {
            return CircleAvatar(
              radius: 30, // Image radius
              backgroundImage: Image.asset("assets/img/noimage.png").image,
            );
          }
          // return new CircularProgressIndicator();
        }
      });
}

Widget proFileShowDataPhoto(context, String path, String gender) {
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
            radius: 100, // Image radius
            backgroundImage: Image.network(snap.data).image,
          );
        } else {
          if (gender == "ชาย") {
            return CircleAvatar(
              radius: 100, // Image radius
              backgroundImage: Image.asset("assets/icon/man.png").image,
            );
          } else if (gender == "หญิง") {
            return CircleAvatar(
              radius: 100, // Image radius
              backgroundImage: Image.asset("assets/icon/woman.png").image,
            );
          } else {
            return CircleAvatar(
              radius: 100, // Image radius
              backgroundImage: Image.asset("assets/img/noimage.png").image,
            );
          }
          // return new CircularProgressIndicator();
        }
      });
}

Widget proFilePatient(context, String path, String gender) {
  // if (path == "lib/img/not-available.png") {
  //   return CircleAvatar(
  //     radius: 48,
  //     backgroundImage: Image.asset(path).image,
  //   );
  // }
  print(path);
  print(gender);
  return FutureBuilder<String>(
      future: FirebaseStorage.instance.ref(path).getDownloadURL(),
      builder: (context, snap) {
        // if (snap.connectionState == ConnectionState.done) {
        //   return new CircularProgressIndicator();
        // }
        if (snap.hasData) {
          return SizedBox(
              width: 100,
              height: 100,
              child: ClipOval(
                child: Image(
                image: Image.network(snap.data).image,
                fit: BoxFit.fitWidth,
                )
              ),
            );
          // CircleAvatar(
          //   radius: 48, // Image radius
          //   backgroundImage: Image.network(snap.data).image,
          // );
        } else {
          if (gender == "ชาย") {
            return  SizedBox(
              width: 100,
              height: 100,
              child: ClipOval(
                child: Image(
                image: AssetImage("assets/Img/man.png"),
                fit: BoxFit.fitWidth,
                )
              ),
            );
          } else if (gender == "หญิง") {
            return SizedBox(
              width: 100,
              height: 100,
              child: ClipOval(
                child: Image(
                image: AssetImage("assets/Img/woman.png"),
                fit: BoxFit.fitWidth,
                )
              ),
            );
          } else {
            return SizedBox(
              width: 100,
              height: 100,
              child: ClipOval(
                child: Image(
                image: AssetImage("assets/Img/noimage.png"),
                fit: BoxFit.fitWidth,
                )
              ),
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
            padding: const EdgeInsets.only(left: 15, right: 25),
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
            padding: const EdgeInsets.only(left: 15, right: 25),
            child: Image.asset(
              "assets/img/noimage.png",
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
