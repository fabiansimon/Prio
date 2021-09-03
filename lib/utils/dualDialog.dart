import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DualDialog extends StatefulWidget {
  const DualDialog({
    Key key,
    this.title,
    this.text,
    this.function,
    this.context,
  }) : super(key: key);

  final String title;
  final String text;
  final Function function;
  final BuildContext context;

  @override
  _DualDialogState createState() => _DualDialogState();
}

class _DualDialogState extends State<DualDialog> {
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
              widget.function();
              Navigator.of(widget.context).pop();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(widget.context).pop();
            },
            child: const Text('No'),
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: Text(widget.title),
        content: Text(widget.text),
        actions: [
          GestureDetector(
            onTap: () {
              widget.function();
              Navigator.pop(widget.context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: const Text('Yes'),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(widget.context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Text('No'),
            ),
          ),
        ],
      );
    }
  }
}
