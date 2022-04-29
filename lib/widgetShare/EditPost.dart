import 'package:appilcation_for_ncds/widgetShare/ShowAlet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditPost extends StatefulWidget {
  var postUid;
  var whoEdit;
  EditPost({Key key, @required this.postUid, @required this.whoEdit})
      : super(key: key);

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  @override
  void initState() {
    super.initState();
    getPostEdit();
  }

  getPostEdit() async {
    await FirebaseFirestore.instance
        .collection("RecommendPost")
        .doc(widget.postUid)
        .get()
        .then((value) {
      // setState() {
      topic.text = value.get("topic");
      content.text = value.get("content");
      // }
    });
  }

  TextEditingController topic = TextEditingController();
  TextEditingController content = TextEditingController();
  final _formEditPost = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "แก้ไขบทความ",
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      content: SizedBox(
        width: 700,
        height: 500,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formEditPost,
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // Text("หัวข้อ:"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: topic,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "กรุณาตั้งหัวข้อ";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            topic.text = value;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'หัวเรื่อง',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: content,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "กรุณาเพิ่มบทความ";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            content.text = value;
                          },
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          maxLines: 10,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'บทความ',
                          ),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buttonCorrect(context),
                            ),
                            buttonCancel(),
                          ]),
                    ],
                  ),
                ),
              ),
              // Expanded(
              //   child: Column(children: <Widget>[]),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonCorrect(context) {
    return RaisedButton(
      onPressed: () async {
        if (_formEditPost.currentState.validate()) {
          showDialog(
                  context: context,
                  builder: (BuildContext content) =>
                      alertMessage(content, "คุณแน่ใจที่จะแก้ไขบทความหรือไม่"))
              .then(
            (value) async {
              if (value == "CONFIRM") {
                await FirebaseFirestore.instance
                    .collection("RecommendPost")
                    .doc(widget.postUid)
                    .update({
                  "topic": topic.text,
                  "content": content.text,
                  "editBy": widget.whoEdit,
                }).whenComplete(() {
                  showDialog(
                          context: context,
                          builder: (BuildContext content) =>
                              alertMessageOnlyOk(content, "แก้ไขบทความสำเร็จ"))
                      .then(
                    (value) => Navigator.pop(context),
                  );
                });
              } else if (value == 'CANCEL') {
                Navigator.pop(context);
              }
            },
          );
        }
      },
      child: Row(children: [
        Icon(IconData(0xe159, fontFamily: 'MaterialIcons'),
            color: Colors.white),
        Text(
          "ตกลง",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ]),
      color: Colors.green,
      hoverColor: Colors.grey,
      padding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }

  Widget buttonCancel() {
    return RaisedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Row(children: [
        Icon(IconData(0xef58, fontFamily: 'MaterialIcons'),
            color: Colors.white),
        Text(
          "ยกเลิก",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ]),
      color: Colors.red,
      hoverColor: Colors.grey,
      padding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }
}
