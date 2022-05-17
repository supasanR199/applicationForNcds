import 'package:appilcation_for_ncds/widgetShare/AllStatus.dart';
import 'package:appilcation_for_ncds/widgetShare/BuildPatientSearch.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math show pi;

class SidebarPage extends StatefulWidget {
  @override
  _SidebarPageState createState() => _SidebarPageState();
}

class _SidebarPageState extends State<SidebarPage> {
  List<CollapsibleItem> _items;
  String _headline;
  AssetImage _avatarImg = AssetImage('assets/man.png');

  @override
  void initState() {
    super.initState();
    _items = _generateItems;
    _headline = _items.firstWhere((item) => item.isSelected).text;
  }

  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
        text: 'ระบบด้วยรวม',
        icon: Icons.assessment,
        onPressed: () => setState(() => _headline = 'all'),
        isSelected: true,
      ),
      CollapsibleItem(
        text: 'ผู้ป่วย',
        icon: Icons.icecream,
        onPressed: () => setState(() => _headline = 'patient'),
      ),
      CollapsibleItem(
        text: 'โพสต์',
        icon: Icons.search,
        onPressed: () => setState(() => _headline = 'post'),
      ),
      CollapsibleItem(
        text: 'อสม.',
        icon: Icons.notifications,
        onPressed: () => setState(() => _headline = 'volenter'),
      ),
      CollapsibleItem(
        text: 'แชทพูดคุย',
        icon: Icons.settings,
        onPressed: () => setState(() => _headline = 'chat'),
      ),
      CollapsibleItem(
        text: 'ยืนยันสมัครเข้าใช้งาน',
        icon: Icons.home,
        onPressed: () => setState(() => _headline = 'accept'),
      ),
      // CollapsibleItem(
      //   text: 'Alarm',
      //   icon: Icons.access_alarm,
      //   onPressed: () => setState(() => _headline = 'Alarm'),
      // ),
      // CollapsibleItem(
      //   text: 'Eco',
      //   icon: Icons.eco,
      //   onPressed: () => setState(() => _headline = 'Eco'),
      // ),
      // CollapsibleItem(
      //   text: 'Event',
      //   icon: Icons.event,
      //   onPressed: () => setState(() => _headline = 'Event'),
      // ),
      // CollapsibleItem(
      //   text: 'Email',
      //   icon: Icons.email,
      //   onPressed: () => setState(() => _headline = 'Email'),
      // ),
      // CollapsibleItem(
      //   text: 'Face',
      //   icon: Icons.face,
      //   onPressed: () => setState(() => _headline = 'Face'),
      // ),
    ];
  }
  String selected = "patient";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("assets/icon/logo.png"),
        centerTitle: false,
        title: Text(
          "ติดตามผู้ป่วย NCDs\nโรงพยาบาลส่งเสริมสุขภาพตำบล",
          style: TextStyle(color: Colors.black),
          // textAlign: TextAlign.left,
        ),
      ),
      body: CollapsibleSidebar(
        isCollapsed: true,
        items: _items,
        // avatarImg: _avatarImg,
        // title: 'John Smith',
        onTitleTap: () {
          // ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('Yay! Flutter Collapsible Sidebar!')));
        },
        body: _body(size, context, _headline),
        backgroundColor: Colors.white,
        selectedTextColor: Colors.limeAccent,
        textStyle: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
        titleStyle: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
        toggleTitleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        sidebarBoxShadow: [
          BoxShadow(
            color: Colors.indigo,
            blurRadius: 20,
            spreadRadius: 0.01,
            offset: Offset(3, 3),
          ),
          BoxShadow(
            color: Colors.green,
            blurRadius: 50,
            spreadRadius: 0.01,
            offset: Offset(3, 3),
          ),
        ],
      ),
    );
  }

  Widget _body(Size size, BuildContext context, String selected) {
    if (selected == "all") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blueGrey[50],
        child: Center(child: AllStarus()),
      );
    } else if (selected == "patient") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blueGrey[50],
        child: Center(child: BuildPatientSearch(role: true)),
      );
    }else if (selected == "post") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blueGrey[50],
        child: Center(child: BuildPatientSearch(role: true)),
      );
    }else if (selected == "volenter") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blueGrey[50],
        child: Center(child: BuildPatientSearch(role: true)),
      );
    }else if (selected == "chat") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blueGrey[50],
        child: Center(child: BuildPatientSearch(role: true)),
      );
    }
    else if (selected == "accept") {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blueGrey[50],
        child: Center(child: BuildPatientSearch(role: true)),
      );
    }
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.blueGrey[50],
      child: Center(child: AllStarus()),
    );
  }
}
