import 'package:flutter/material.dart';
import 'package:prio_project/data/design.dart';

class InfoText extends StatefulWidget {
  const InfoText({
    Key key,
    this.text,
  }) : super(key: key);
  final String text;

  @override
  _InfoTextState createState() => _InfoTextState();
}

class _InfoTextState extends State<InfoText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        fontSize: 12,
        fontStyle: FontStyle.italic,
        color: subtleGrey,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
