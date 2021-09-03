import 'package:flutter/material.dart';
import 'package:prio_project/data/design.dart';

class TextFieldCostum extends StatefulWidget {
  const TextFieldCostum({
    Key key,
    this.hintText,
    this.textEditingController,
    this.autoCorrection,
    this.textCapitalization,
    this.obscureText,
    this.keyboardType,
  }) : super(key: key);
  final String hintText;
  final TextEditingController textEditingController;
  final bool autoCorrection;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;

  @override
  _TextFieldCostumState createState() => _TextFieldCostumState();
}

class _TextFieldCostumState extends State<TextFieldCostum> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: widget.autoCorrection,
      textCapitalization: widget.textCapitalization,
      obscureText: widget.obscureText,
      cursorColor: black1,
      keyboardType: widget.keyboardType,
      controller: widget.textEditingController,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Color(0xFFC1C1C2),
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
