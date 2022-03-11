import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget statusAlert(String id) {
  bool alert;
  int fatalert;
  int saltalert;
  int sweetalert;
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection("MobileUser")
        .doc(id)
        .collection("eatalert")
        .snapshots(),
    builder: ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData) {
        // snapshot.data.docs.map((e) {
        //   alert = e.get("alert");
        //   fatalert = e.get("fatalert");
        //   saltalert = e.get("saltalert");
        //   sweetalert = e.get("sweetalert");
        // });
        // print(
        //     "this is from map {$alert},{$fatalert},{$saltalert},{$sweetalert}");
        if (snapshot.data.docs.isEmpty) {
          return Text("");
        }
        print(snapshot.data.docs.first.data());
        return IconButton(
          onPressed: () => {
            showDialog(
                context: context,
                builder: (BuildContext conttext) => showStaus(
                    snapshot.data.docs.first.get("fatalert"),
                    snapshot.data.docs.first.get("saltalert"),
                    snapshot.data.docs.first.get("sweetalert")))
          },
          icon: Icon(
            Icons.bus_alert_sharp,
            color: isAlert(
              snapshot.data.docs.first.get("alert"),
            ),
          ),
        );
      }
      return Text("กำลังโหลด");
    }),
  );
}

Widget showStaus(int fatalert, int saltalert, int sweetalert) {
  return AlertDialog(
    // title: Text("สถานะ"),
    content: SizedBox(
      height: 300,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  "พฤติกรรมการบริโภค",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text("(ในเดือนนี้)",
                    style: TextStyle(fontSize: 14, color: Colors.black38)),
              ],
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.circle,
                color: statuseat(sweetalert)[1],
                size: 15,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "บริโภคหวาน",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  statuseat(sweetalert)[0],
                  style: TextStyle(fontSize: 14, color: Colors.black38),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.circle,
                color: statuseat(fatalert)[1],
                size: 15,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "บริโภคมัน",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  statuseat(fatalert)[0],
                  style: TextStyle(fontSize: 14, color: Colors.black38),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.circle,
                color: statuseat(saltalert)[1],
                size: 15,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "บริโภคเค็ม",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  statuseat(saltalert)[0],
                  style: TextStyle(fontSize: 14, color: Colors.black38),
                ),
              ),
            ],
          ),
          Center(
            child: Column(
              children: [
                Text(
                  "อารมณ์",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text("(ในวันนี้)",
                    style: TextStyle(fontSize: 14, color: Colors.black38)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

statuseat(num val) {
  if (val != 0) {
    if (val == 5) {
      return ["ปรกติ", Colors.green];
    } else if (val >= 6 && val <= 9) {
      return ["มีความเสี่ยงปานกลาง", Colors.yellow.shade600];
    } else if (val >= 10 && val <= 13) {
      return ["มีความเสี่ยงสูง", Colors.orange];
    } else if (val >= 14) {
      return ["มีความเสี่ยงสูงมาก", Colors.red];
    }
  } else {
    return ["ไม่มีข้อมูล", Colors.grey];
  }
}

isAlert(bool isalert) {
  if (isalert) {
    return Colors.red;
  } else {
    return Colors.green;
  }
}

moodstatus(var val) {
  if (val != "null") {
    if (num.parse(val) <= 4) {
      return ["เครียดน้อย", Colors.green];
    } else if (num.parse(val) >= 5 && num.parse(val) <= 7) {
      return ["เครียดปานกลาง", Colors.yellow.shade700];
    } else if (num.parse(val) >= 8 && num.parse(val) <= 9) {
      return ["เครียดมาก", Colors.orange];
    } else if (num.parse(val) >= 10) {
      return ["เครียดมากที่สุด", Colors.red];
    }
  } else {
    return ["ไม่มีข้อมูล", Colors.grey];
  }
}
