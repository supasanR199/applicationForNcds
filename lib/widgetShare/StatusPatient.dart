import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool alert;

Widget statusAlert(String id) {
  int fatalert;
  int saltalert;
  int sweetalert;
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection("MobileUser")
        .doc(id)
        .collection("eatalert")
        .snapshots(),
    builder:
        ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotFood) {
      if (snapshotFood.hasData) {
        if (snapshotFood.data.docs.isEmpty) {
          return Text("");
        }
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("MobileUser")
                .doc(id)
                .collection("moodalert")
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshotMood) {
              if (snapshotMood.hasData) {
                if (snapshotMood.data.docs.isEmpty) {
                  alert = snapshotFood.data.docs.last.get("alert");
                  return IconButton(
                    onPressed: () => {
                      showDialog(
                          context: context,
                          builder: (BuildContext conttext) => showStaus(
                              snapshotFood.data.docs.last.get("fatalert"),
                              snapshotFood.data.docs.last.get("saltalert"),
                              snapshotFood.data.docs.last.get("sweetalert"),
                              null,
                              snapshotFood.data.docs.last.id,
                              null))
                    },
                    icon: Icon(
                      Icons.bus_alert_sharp,
                      color: isAlert(
                        alert,
                      ),
                    ),
                  );
                }
                alert = snapshotFood.data.docs.last.get("alert") ||
                    snapshotMood.data.docs.last.get("alert");
                int mood;
                return IconButton(
                  onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext conttext) => showStaus(
                          snapshotFood.data.docs.last.get("fatalert"),
                          snapshotFood.data.docs.last.get("saltalert"),
                          snapshotFood.data.docs.last.get("sweetalert"),
                          snapshotMood.data.docs.last.get("moodtoday"),
                          snapshotFood.data.docs.last.id,
                          snapshotMood.data.docs.last.id),
                    ),
                  },
                  icon: Icon(
                    Icons.bus_alert_sharp,
                    color: isAlert(
                      alert,
                    ),
                  ),
                );
              } else {
                return Text("กำลังโหลด");
              }
            });
        // IconButton(
        //   onPressed: () => {
        //     showDialog(
        //         context: context,
        //         builder: (BuildContext conttext) => showStaus(
        //             snapshot.data.docs.last.get("fatalert"),
        //             snapshot.data.docs.last.get("saltalert"),
        //             snapshot.data.docs.last.get("sweetalert"),
        //             id))
        //   },
        //   icon: Icon(
        //     Icons.bus_alert_sharp,
        //     color: isAlert(
        //       alert,
        //     ),
        //   ),
        // );
      }
      return Text("กำลังโหลด");
    }),
  );
}

Widget showStaus(int fatalert, int saltalert, int sweetalert, int moodalert,
    String dayFood, String dayMood) {
  // print(getDate(dayFood));
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
                Text("(ในเดือน $dayFood)",
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
                Text("(ในวัน $dayMood)",
                    style: TextStyle(fontSize: 14, color: Colors.black38)),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: moodstatus(moodalert)[1],
                        size: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "แบบทดสอบอารมณ์",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 25),
                      child: Text(
                        moodstatus(moodalert)[0],
                        style: TextStyle(fontSize: 14, color: Colors.black38),
                      ),
                    ),
                  ],
                ),
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

moodstatus(int val) {
  if (val != null) {
    if (val <= 4) {
      return ["เครียดน้อย", Colors.green];
    } else if (val >= 5 && val <= 7) {
      return ["เครียดปานกลาง", Colors.yellow.shade700];
    } else if (val >= 8 && val <= 9) {
      return ["เครียดมาก", Colors.orange];
    } else if (val >= 10) {
      return ["เครียดมากที่สุด", Colors.red];
    }
  } else {
    return ["ไม่มีข้อมูล", Colors.grey];
  }
}

getDate(String mount) {
  DateTime dateTime = DateTime.parse(mount + "-1");
  print(dateTime);
}
