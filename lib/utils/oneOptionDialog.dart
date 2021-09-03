import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OneOptionDialog extends StatefulWidget {
  const OneOptionDialog({
    Key key,
    this.title,
    this.text,
    this.context,
  }) : super(key: key);
  final String title;
  final String text;
  final BuildContext context;

  @override
  _OneOptionDialogState createState() => _OneOptionDialogState();
}

class _OneOptionDialogState extends State<OneOptionDialog> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(widget.title),
        content: SingleChildScrollView(
          child: Text(widget.text),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: Text(widget.title),
        content: Text(widget.text),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Text('Ok'),
            ),
          ),
        ],
      );
    }
  }
}
