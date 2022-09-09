import 'package:appilcation_for_ncds/function/DisplayTime.dart';
import 'package:appilcation_for_ncds/function/KeepLog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserLog extends StatefulWidget {
  UserLog({Key key}) : super(key: key);

  @override
  State<UserLog> createState() => _UserLogState();
}

class _UserLogState extends State<UserLog> {
  List<QueryDocumentSnapshot> getLog = List();
  List<QueryDocumentSnapshot> getLogDe = List();
  List<String> selectName = List();
  List<String> selectEmail = List();
  List<String> selectRole = List();
  var _value;
  String _valueEmail;
  List<QueryDocumentSnapshot> usersFiltered = List();
  TextEditingController controller = TextEditingController();
  String _searchResult = '';
  @override
  void initState() {
    getUserLog().then((value) {
      // print(value.docs);
      setState(() {
        getLogDe = value.docs;
        getLog = value.docs;
        getLog.forEach((e) {
          String name = ("${e.get("Firstname")}");
          String email = ("${e.get("email")}");
          String role = ("${e.get("role")}");
          selectName.add(name);
          selectEmail.add(email);
          selectRole.add(role);
          selectName = selectName.toSet().toList();
          selectEmail = selectEmail.toSet().toList();
          selectRole = selectRole.toSet().toList();
          usersFiltered = getLog;
        });
      });
    });
    // getLog.forEach((element) {
    //   element.get(field)
    // });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: controller,
                onChanged: (value) {
                  setState(() {
                    _searchResult = value;
                    usersFiltered = getFilterSerach(getLogDe, _searchResult);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Expanded(
                //   child: DropdownButtonFormField<String>(
                //     value: _value,
                //     decoration: InputDecoration(
                //       labelText: 'ชื่อ',
                //       icon: Icon(Icons.people),
                //     ),
                //     items: selectName.map((String values) {
                //       // print(values);
                //       return DropdownMenuItem<String>(
                //         value: values,
                //         child: Text(values),
                //       );
                //     }).toList(),
                //     onChanged: (newValue) {
                //       setState(() {
                //         getLog = getFilter(getLogDe, newValue, "Firstname");
                //       });
                //     },
                //   ),
                // ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _valueEmail,
                    decoration: InputDecoration(
                      labelText: 'email',
                      icon: Icon(Icons.people),
                    ),
                    items: selectEmail.map((String values) {
                      // print(values);
                      return DropdownMenuItem<String>(
                        value: values,
                        child: Text(values),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        getLog = getFilter(getLogDe, newValue, "email");
                      });
                    },
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _value,
                    decoration: InputDecoration(
                      labelText: 'ตำแหน่ง',
                      icon: Icon(Icons.people),
                    ),
                    items: selectRole.map((String values) {
                      // print(values);
                      return DropdownMenuItem<String>(
                        value: values,
                        child: Text(values),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      // print(newValue);
                      setState(() {
                        getLog = getFilter(getLogDe, newValue, "role");
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'ชื่อ',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'อีเมล',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ตำแหน่ง',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'เวลาเข้าใช้งาน',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  // DataColumn(
                  //   label: Text(
                  //     'สถานะ',
                  //     style: TextStyle(
                  //         fontStyle: FontStyle.italic),
                  //   ),
                  // ),
                ],
                rows: _buildList(context, usersFiltered),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataRow> _buildList(
      BuildContext context, List<QueryDocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, QueryDocumentSnapshot data) {
    // Map<String, dynamic> snap = data as Map<String, dynamic>;
    // print(data.data());
    // print(data.get("email"));
    return DataRow(
      cells: [
        DataCell(Text(data.get("Firstname"))),
        DataCell(Text(data.get("email"))),
        DataCell(Text(data.get("role"))),
        DataCell(Text(convertDateTimeDisplayAndTime(data.get("timeLogin")))),
        // DataCell(buildButtonDelectRemainder(context, snap["logoutTime"])),
      ],
    );
  }

  Future<QuerySnapshot> getUserLog() async {
    var _getLog = await FirebaseFirestore.instance
        .collection("UserLog")
        .orderBy("timeLogin", descending: true | false)
        .limit(100)
        .get();
    return _getLog;
  }
}
