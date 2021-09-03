import 'package:flutter/material.dart';
import 'package:prio_project/data/design.dart';

class DraggableContainer extends StatefulWidget {
  @override
  _DraggableContainerState createState() => _DraggableContainerState();
}

class _DraggableContainerState extends State<DraggableContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * .4,
      decoration: BoxDecoration(
        gradient: purpleGradient,
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: const Center(
        child: Text(
          'Swipe to send',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
