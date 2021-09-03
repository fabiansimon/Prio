import 'package:flutter/material.dart';
import 'package:prio_project/data/design.dart';

class ButtonTemplate extends StatefulWidget {
  const ButtonTemplate({
    Key key,
    @required this.height,
    @required this.radius,
    @required this.gradient,
    @required this.icon,
    @required this.iconSize,
    @required this.text,
    @required this.textSize,
    @required this.function,
  }) : super(key: key);
  final double height;
  final double radius;
  final LinearGradient gradient;
  final IconData icon;
  final double iconSize;
  final String text;
  final double textSize;
  final Function function;

  @override
  _ButtonTemplateState createState() => _ButtonTemplateState();
}

bool _isTapDown = false;
int _animationTime = 50;

class _ButtonTemplateState extends State<ButtonTemplate> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          _isTapDown = true;
        });
      },
      onTapCancel: () {
        setState(() {
          _isTapDown = false;
        });
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          _isTapDown = false;
        });
      },
      onTap: () {
        setState(() {
          _isTapDown = true;
        });
        Future<int>.delayed(Duration(milliseconds: _animationTime)).then((_) {
          setState(() {
            _isTapDown = false;
          });
        });
        widget.function();
      },
      child: SizedBox(
        height: widget.height,
        child: AnimatedPadding(
          curve: Curves.easeOutQuart,
          duration: Duration(milliseconds: _animationTime),
          padding: EdgeInsets.symmetric(
            horizontal: _isTapDown ? 10.0 : 0,
            vertical: _isTapDown ? 1.0 : 0,
          ),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[basicShadow],
              gradient: widget.gradient,
              borderRadius: BorderRadius.all(
                Radius.circular(widget.radius),
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedContainer(
                    curve: Curves.easeOutQuart,
                    duration: Duration(milliseconds: _animationTime),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: _isTapDown ? widget.iconSize - 2 : widget.iconSize,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedDefaultTextStyle(
                    curve: Curves.easeOutQuart,
                    duration: Duration(milliseconds: _animationTime),
                    style: TextStyle(
                      fontSize:
                          _isTapDown ? widget.textSize - 2 : widget.textSize,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    child: Text(
                      widget.text,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
