import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _AddPost();
  }
}

class _AddPost extends State<AddPost> {
  @override
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
                child: buildInputPostFrom(context),
              ),
            ),
          ),
        ),
        backgroundColor: Color.fromRGBO(255, 211, 251, 1),
      ),
    );
  }

  Widget buildInputPostFrom(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'หัวเรื่อง',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'ไฮไลต์',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: 5,
            top: 20,
            right: 20,
            left: 20,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'เนื้อหาโพสต์',
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: 20,
            top: 0,
            right: 20,
            left: 20,
          ),
          child: TextField(
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: 10,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'เนื้อหาโพสต์',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: RaisedButton(
            // color: Colors.accents,
            onPressed: () => Navigator.pushNamed(context, '/mainpage'),
            color: Colors.white,
            child: Text('ฮัพโหลดรูปภาพ'),
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: RaisedButton(
                onPressed: () => Navigator.pushNamed(context, '/mainpage'),
                color: Colors.green[100],
                child: Text('บันทึก'),
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: RaisedButton(
                onPressed: () => Navigator.pushNamed(context, '/mainpage'),
                color: Colors.red[100],
                child: Text('ยกเลิก'),
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
