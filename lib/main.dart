import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:appilcation_for_ncds/AddPost.dart';
import 'package:appilcation_for_ncds/MainPage.dart';
import 'package:appilcation_for_ncds/PageStart.dart';
import 'package:appilcation_for_ncds/Register.dart';
import 'package:appilcation_for_ncds/PatientMain.dart';
import 'package:appilcation_for_ncds/LabResults.dart';
import 'package:appilcation_for_ncds/AdminMain.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyB6TWU5KRbGhd0I5z_uX0P-4GEAAAtV-4U",
        authDomain: "applicationforncds.firebaseapp.com",
        projectId: "applicationforncds",
        storageBucket: "applicationforncds.appspot.com",
        messagingSenderId: "275231099903",
        appId: "1:275231099903:web:dacf48738af9cb2e41b5ca",
        measurementId: "G-YQV5KT112F"),
  );
  // runApp(MyApp());
  // runApp(MaterialApp(
  //   home: ShowInfomation(),
  //   theme: ThemeData(
  //     textTheme: const TextTheme(
  //       bodyText1: TextStyle(color: Colors.black),
  //     ),
  //   ),
  //   debugShowCheckedModeBanner: false,
  // ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firestore Demo',
      home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("Error");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return buildMaterialApp();
            }
            return CircularProgressIndicator();
          }),
      // debugShowCheckedModeBanner: false,
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     theme: ThemeData(
  //         textTheme: const TextTheme(
  //       bodyText1: TextStyle(color: Colors.black),
  //     )),
  //     debugShowCheckedModeBanner: false,
  //     home: Scaffold(
  //         appBar: AppBar(
  //           title: Text(
  //             "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
  //             style: TextStyle(color: Colors.black),
  //           ),
  //           backgroundColor: Colors.white,
  //           actions: <Widget>[
  //             TextButton(onPressed: null, child: Text("ผู้ป่วย")),
  //             TextButton(onPressed: null, child: Text("โพสต์")),
  //             TextButton(onPressed: null, child: Text("ออกจากระบบ")),
  //           ],
  //         ),
  //         backgroundColor: Color.fromRGBO(255, 211, 251, 1),
  //         body: Row(
  //           children: <Widget>[
  //             Text(
  //               'test',
  //               textAlign: TextAlign.center,
  //             ),
  //           ],
  //         )),
  //   );
  // }
}

Widget buildMaterialApp() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    // title: 'FireStore Demo',
    theme: ThemeData(
      primarySwatch: Colors.amber,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => StartPage(),
      // '/addbook': (context) => AddBookPage(),
      '/mainpage': (context) => MainPage(),
      '/register': (context) => Register(),
      '/addpost': (context) => AddPost(),
      '/patientmain': (context) => PatientMain(),
      '/labresults': (context) => LabResults(),
      '/adminmain': (context) => adminMain(),
    },
  );
}

// class ShowInfomation extends StatefulWidget {
//   State<StatefulWidget> createState() {
//     return _ShowInfomationState();
//   }
// }

// class _ShowInfomationState extends State<ShowInfomation> {
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         actions: <Widget>[
//           TextButton(onPressed: null, child: Text("ผู้ป่วย")),
//           TextButton(onPressed: null, child: Text("โพสต์")),
//           TextButton(onPressed: null, child: Text("ออกจากระบบ")),
//         ],
//       ),
//       backgroundColor: Color.fromRGBO(255, 211, 251, 1),
//       body: Container(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Column(
//               children: <Widget>[
//                 Padding(
//                   child: Text('รายชื่อผู้ป่วย'),
//                   padding: EdgeInsets.all(50.0),
//                 ),
//                 Card(
//                   elevation: 4.0,
//                   child: Column(
//                     children: <Widget>[
//                      Text('heading'),
//                      Text('subtitel'),
//                     ],
//                   ),
//                   color: Colors.pink,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
