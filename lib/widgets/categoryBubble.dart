import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prio_project/data/design.dart';

class CategoryBubble extends StatefulWidget {
  const CategoryBubble({
    Key key,
    @required this.mode,
    @required this.size,
    @required this.active,
  }) : super(key: key);
  final int mode;
  final double size;
  final bool active;

  @override
  _CategoryBubbleState createState() => _CategoryBubbleState();
}

class _CategoryBubbleState extends State<CategoryBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size,
      width: widget.size,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.active
              ? widget.mode == 0
                  ? purple2
                  : widget.mode == 1
                      ? green1
                      : pink1
              : subtleGrey,
          width: 2,
        ),
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[basicShadow],
      ),
      child: Icon(
        widget.mode == 0
            ? Icons.directions_walk_rounded
            : widget.mode == 1
                ? CupertinoIcons.cart_fill
                : Icons.shopping_bag,
        color: widget.active
            ? widget.mode == 0
                ? purple2
                : widget.mode == 1
                    ? green1
                    : pink1
            : subtleGrey,
        size: 19,
      ),
    );
  }
}
