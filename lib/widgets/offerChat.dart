import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/data/request.dart';
import 'package:prio_project/data/user.dart';
import 'package:prio_project/widgets/profilePic.dart';
import 'package:prio_project/widgets/ratingStars.dart';

class OfferChat extends StatefulWidget {
  const OfferChat({
    Key key,
    @required this.request,
  }) : super(key: key);
  final Request request;

  @override
  _OfferChatState createState() => _OfferChatState();
}

class _OfferChatState extends State<OfferChat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[basicShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
            child: Text(
              widget.request.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: -.3,
                color: black1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width * .95,
              decoration: BoxDecoration(
                boxShadow: [basicShadow],
                gradient: blackGradient,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Center(
                      child: ProfilePic(
                        size: 30,
                        image: mainUser.imageAsset,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: const <Widget>[
                            Text(
                              'Fabian Simon',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            RatingStars(
                                rating: 4, color: Colors.white, size: 12)
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '3 fulfilled orders • member since 2018',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: purpleGradient,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[basicShadow],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(
                          CupertinoIcons.check_mark,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
