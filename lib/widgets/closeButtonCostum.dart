import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CloseButtonCostum extends StatefulWidget {
  const CloseButtonCostum({
    Key key,
    this.context,
  }) : super(key: key);
  final BuildContext context;

  @override
  _CloseButtonState createState() => _CloseButtonState();
}

class _CloseButtonState extends State<CloseButtonCostum> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(widget.context);
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(
            CupertinoIcons.xmark,
            color: Colors.white,
            size: 14,
          ),
        ),
      ),
    );
  }
}
