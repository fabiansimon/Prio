import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RatingStars extends StatefulWidget {
  const RatingStars({
    Key key,
    @required this.rating,
    @required this.color,
    @required this.size,
  }) : super(key: key);
  final double rating;
  final Color color;
  final double size;

  @override
  _RatingStarsState createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(CupertinoIcons.star_fill,
            color:
                widget.rating < 1 ? widget.color.withOpacity(.2) : widget.color,
            size: widget.size),
        Icon(
          CupertinoIcons.star_fill,
          color:
              widget.rating < 2 ? widget.color.withOpacity(.2) : widget.color,
          size: widget.size,
        ),
        Icon(
          CupertinoIcons.star_fill,
          color:
              widget.rating < 3 ? widget.color.withOpacity(.2) : widget.color,
          size: widget.size,
        ),
        Icon(
          CupertinoIcons.star_fill,
          color:
              widget.rating < 4 ? widget.color.withOpacity(.2) : widget.color,
          size: widget.size,
        ),
        Icon(
          CupertinoIcons.star_fill,
          color:
              widget.rating != 5 ? widget.color.withOpacity(.2) : widget.color,
          size: widget.size,
        ),
      ],
    );
  }
}
