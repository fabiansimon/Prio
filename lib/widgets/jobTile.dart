import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/data/request.dart';

class JobTile extends StatefulWidget {
  const JobTile({
    Key key,
    @required this.request,
  }) : super(key: key);

  final Request request;

  @override
  _JobTileState createState() => _JobTileState();
}

class _JobTileState extends State<JobTile> {
  @override
  Widget build(BuildContext context) {
    final int timeDifference =
        DateTime.now().difference(widget.request.finishDateTime).inHours;
    return Container(
      clipBehavior: Clip.hardEdge,
      height: 75,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
        boxShadow: <BoxShadow>[basicShadow],
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 75,
            width: 40,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(
                    CupertinoIcons.location_solid,
                    size: 20,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '2.3 \nkm',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.request.title,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: black1,
                  ),
                ),
                const SizedBox(),
                Text(
                  widget.request.description,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: black1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  width: 65,
                  decoration: BoxDecoration(
                    color: red2,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${timeDifference.abs()}h left',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 65,
                child: widget.request.category[0]
                    ? Container(
                        height: 65 / 2,
                        width: 65,
                        decoration: BoxDecoration(
                          color: purple1,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.directions_walk_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : widget.request.category[1] && !widget.request.category[2]
                        ? Container(
                            height: 65 / 2,
                            width: 65,
                            decoration: BoxDecoration(
                              color: green1,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(6),
                                bottomRight: Radius.circular(6),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.cart_fill,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : !widget.request.category[1] &&
                                widget.request.category[2]
                            ? Container(
                                height: 65 / 2,
                                width: 65,
                                decoration: BoxDecoration(
                                  color: pink1,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(6),
                                    bottomRight: Radius.circular(6),
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.shopping_bag,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Row(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: pink1,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(6),
                                      ),
                                    ),
                                    height: 65 / 2,
                                    width: 65 / 2,
                                    child: const Icon(
                                      CupertinoIcons.cart_fill,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: green1,
                                      borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(6),
                                      ),
                                    ),
                                    height: 65 / 2,
                                    width: 65 / 2,
                                    child: const Icon(
                                      Icons.shopping_bag,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
