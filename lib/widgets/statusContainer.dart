import 'package:flutter/material.dart';
import 'package:prio_project/data/design.dart';

class StatusContainer extends StatefulWidget {
  const StatusContainer({
    Key key,
    this.status,
  }) : super(key: key);
  final int status;

  @override
  _StatusContainerState createState() => _StatusContainerState();
}

class _StatusContainerState extends State<StatusContainer> {
  final List<String> _statusStrings = <String>[
    'Looking for worker',
    'On the way to the store',
    'Waiting for approval',
    "On it's way to you",
    'Around the corner...'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[basicShadow],
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Status',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                letterSpacing: -.7,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: <Widget>[
                Flexible(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 5,
                        color: black1.withOpacity(.1),
                      ),
                      Container(
                        height: 5,
                        width: widget.status > 0 ? double.infinity : 10,
                        color: purple2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  flex: 3,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 5,
                        color: black1.withOpacity(.1),
                      ),
                      Container(
                        height: 5,
                        color: purple2,
                        width: widget.status > 1 ? double.infinity : 0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  flex: 3,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 5,
                        color: black1.withOpacity(.1),
                      ),
                      Container(
                        height: 5,
                        color: purple2,
                        width: widget.status > 2 ? double.infinity : 0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 5,
                        color: black1.withOpacity(.1),
                      ),
                      Container(
                        height: 5,
                        color: purple2,
                        width: widget.status > 3 ? double.infinity : 0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              '${_statusStrings[widget.status]} ...',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 15,
                letterSpacing: .3,
                fontWeight: FontWeight.w300,
                color: Color(0xFF818181),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
