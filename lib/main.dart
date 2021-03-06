import 'dart:js';

import 'package:appilcation_for_ncds/TestWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:appilcation_for_ncds/AddPost.dart';
import 'package:appilcation_for_ncds/MainPage.dart';
import 'package:appilcation_for_ncds/PageStart.dart';
import 'package:appilcation_for_ncds/Register.dart';
import 'package:appilcation_for_ncds/PatientMain.dart';
import 'package:appilcation_for_ncds/LabResults.dart';
import 'package:appilcation_for_ncds/AdminMain.dart';
import 'package:appilcation_for_ncds/AddPatientForVolunteer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'MedicaMain.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // print(dotenv.get('API_KEY'));
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.get('API_KEY'),
      authDomain: dotenv.get('AUTH_DOMAIN'),
      projectId: dotenv.get('PROJECT_ID'),
      storageBucket: dotenv.get('STORAGE_BACKKET'),
      messagingSenderId: dotenv.get('MESSAGEING_SENDER_ID'),
      appId: dotenv.get('APP_ID'),
      measurementId: dotenv.get('MEASUREMENT_ID'),
    ),
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
              // print("Error");
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
  //             "??????????????????????????????????????? NCDs\n?????????????????????????????????????????????????????????????????????????????????",
  //             style: TextStyle(color: Colors.black),
  //           ),
  //           backgroundColor: Colors.white,
  //           actions: <Widget>[
  //             TextButton(onPressed: null, child: Text("?????????????????????")),
  //             TextButton(onPressed: null, child: Text("???????????????")),
  //             TextButton(onPressed: null, child: Text("??????????????????????????????")),
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
    // theme: ThemeData(
    //   primarySwatch: Colors.grey,
    //   hoverColor: Colors.grey[200],
    //   iconTheme: IconThemeData(color: Colors.black),
    // ),
    initialRoute: '/',
    routes: {
      '/': (context) => StartPage(),
      // '/addbook': (context) => AddBookPage(),
      '/mainpage': (context) => MainPage(),
      '/register': (context) => Register(),
      '/medicaMain': (context) => MedicaMain(),
      '/test': (context) => SidebarPage(),
      // '/addPatientForVol': (context) => AddPatienFoorVolunteer(),
      // '/addpost': (context) => AddPost(),
      // '/patientmain': (context) => PatientMain(),
      // '/labresults': (context) => LabResults(),
      '/adminmain': (context) => adminMain(),
    },
  );
}

const MaterialColor pink = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFF8BBD0),
    100: const Color(0xFFF8BBD0),
    200: const Color(0xFFF8BBD0),
    300: const Color(0xFFF8BBD0),
    400: const Color(0xFFF8BBD0),
    500: const Color(0xFFF8BBD0),
    600: const Color(0xFFF8BBD0),
    700: const Color(0xFFF8BBD0),
    800: const Color(0xFFF8BBD0),
    900: const Color(0xFFF8BBD0),
  },
);
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
//           "??????????????????????????????????????? NCDs\n?????????????????????????????????????????????????????????????????????????????????",
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         actions: <Widget>[
//           TextButton(onPressed: null, child: Text("?????????????????????")),
//           TextButton(onPressed: null, child: Text("???????????????")),
//           TextButton(onPressed: null, child: Text("??????????????????????????????")),
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
//                   child: Text('??????????????????????????????????????????'),
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
