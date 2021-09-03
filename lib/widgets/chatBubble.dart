import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/widgets/infoText.dart';

class ChatBubble extends StatefulWidget {
  const ChatBubble({
    Key key,
    @required this.text,
    @required this.isSelf,
    @required this.dateTime,
  }) : super(key: key);
  final String text;
  final bool isSelf;
  final DateTime dateTime;

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              widget.isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              DateFormat('HH:mm').format(widget.dateTime),
              style: TextStyle(
                fontSize: 10,
                color: subtleGrey,
              ),
            ),
            const SizedBox(height: 3),
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .65),
              decoration: BoxDecoration(
                gradient: widget.isSelf
                    ? purpleGradient
                    : const LinearGradient(
                        colors: <Color>[Colors.white, Colors.white],
                      ),
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(10),
                  bottomRight: const Radius.circular(10),
                  topLeft:
                      widget.isSelf ? const Radius.circular(10) : Radius.zero,
                  topRight:
                      widget.isSelf ? Radius.zero : const Radius.circular(10),
                ),
                boxShadow: <BoxShadow>[basicShadow],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.isSelf ? Colors.white : black2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
