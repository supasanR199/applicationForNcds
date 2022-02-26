import 'package:flutter/material.dart';
import 'package:radio_button_form_field/radio_button_form_field.dart';

class EvaluateChoiceLess extends StatelessWidget {
  String subject;
  final ValueChanged<dynamic> onChoiceChang;
  EvaluateChoiceLess({
    Key key,
    @required this.subject,
    this.onChoiceChang,
  }) : super(key: key);

  @override
  final List<Map> data = [
    {'value': 4, 'display': 'ดีมาก'},
    {'value': 3, 'display': 'ดี'},
    // {'value': 3, 'display': 'ปานกลาง'},
    {'value': 2, 'display': 'พอใช้'},
    {'value': 1, 'display': 'ปรับปรุง'},
  ];
  @override
  Widget build(BuildContext context) {
    // var _selectForm = GlobalKey<FormState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            subject,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.left,
          ),
        ),
        RadioButtonFormField(
          // toggleable: true,
          padding: EdgeInsets.all(8),
          context: context,
          value: 'value',
          display: 'display',
          data: data,
          onSaved: (newValue) {
            onChoiceChang(newValue);
          },
          validator: (value) {
            if (value == null) {
              return "โปรดให้คะแนนการประเมิน";
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }
}

class EvaluateChoice extends StatefulWidget {
  String subject;
  final ValueChanged<dynamic> onChoiceChang;
  EvaluateChoice({
    Key key,
    @required this.subject,
    this.onChoiceChang,
  }) : super(key: key);

  @override
  _EvaluateChoiceState createState() => _EvaluateChoiceState();
}

class _EvaluateChoiceState extends State<EvaluateChoice> {
  final List<Map> data = [
    {'value': 4, 'display': 'ดีมาก'},
    {'value': 3, 'display': 'ดี'},
    // {'value': 3, 'display': 'ปานกลาง'},
    {'value': 2, 'display': 'พอใช้'},
    {'value': 1, 'display': 'ปรับปรุง'},
  ];
  @override
  Widget build(BuildContext context) {
    var _selectForm = GlobalKey<FormState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            widget.subject,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.left,
          ),
        ),
        RadioButtonFormField(
          // toggleable: true,
          padding: EdgeInsets.all(8),
          context: context,
          value: 'value',
          display: 'display',
          data: data,
          onSaved: (newValue) {
            print(newValue);
            widget.onChoiceChang(newValue);
          },
          validator: (value) {
            if (value == null) {
              return "โปรดให้คะแนนการประเมิน";
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }
}
