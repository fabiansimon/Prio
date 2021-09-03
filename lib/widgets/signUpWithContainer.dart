import 'package:flutter/material.dart';
import 'package:prio_project/data/design.dart';

class SignUpWithContainer extends StatefulWidget {
  const SignUpWithContainer({
    Key key,
    this.text,
    this.icon,
  }) : super(key: key);
  final String text;
  final String icon;

  @override
  _SignUpWithContainerState createState() => _SignUpWithContainerState();
}

class _SignUpWithContainerState extends State<SignUpWithContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[basicShadow],
        border: Border.all(
          color: black1,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('assets/${widget.icon}.png'),
            height: 18,
          ),
          const SizedBox(width: 5),
          Text(
            widget.text,
            style: const TextStyle(
              letterSpacing: -.2,
              color: Colors.black,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
