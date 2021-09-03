import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prio_project/data/request.dart';
import 'package:prio_project/data/user.dart';
import 'package:prio_project/model/user.dart';
import 'package:prio_project/provider/watchlistReqProv.dart';
import 'package:prio_project/screens/chatWindow.dart';
import 'package:prio_project/utils/chatUtils.dart';
import 'package:prio_project/utils/mapUtils.dart';
import 'package:prio_project/widgets/buttonTemplate.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/widgets/categoryBubble.dart';
import 'package:prio_project/widgets/closeButtonCostum.dart';
import 'package:prio_project/widgets/profilePic.dart';
import 'package:prio_project/widgets/ratingStars.dart';
import 'package:provider/provider.dart';

class JobDetail extends StatefulWidget {
  const JobDetail({
    Key key,
    @required this.request,
  }) : super(key: key);
  final Request request;

  @override
  _JobDetailState createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  Address displayAddress;
  num distance;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  bool _isLoading = true;
  bool _addedToWatchlist = false;

  CurrentUser _currentUser;

  Set<Circle> circles = <Circle>{};

  Future<void> _openChat() async {
    final CollectionReference db =
        FirebaseFirestore.instance.collection('chats');
    final FirebaseAuth auth = FirebaseAuth.instance;

    final String chatId = await ChatUtils.getChatId(widget.request.creatorId);

    try {
      await db
          .where('receiver_id', isEqualTo: widget.request.creatorId)
          .where('sender_id', isEqualTo: auth.currentUser.uid)
          .get()
          .then((QuerySnapshot value) {
        if (value.docs.isEmpty) {
          ChatUtils.openChat(widget.request).then((String valueId) {
            Navigator.push(
              context,
              MaterialPageRoute<BuildContext>(
                builder: (
                  BuildContext context,
                ) =>
                    ChatWindow(
                  chatId: valueId,
                ),
              ),
            );
          });
        } else {
          Navigator.push(
            context,
            MaterialPageRoute<BuildContext>(
              builder: (
                BuildContext context,
              ) =>
                  ChatWindow(
                chatId: chatId,
              ),
            ),
          );
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _checkIfWL() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final String firebaseUID = FirebaseAuth.instance.currentUser.uid;

    try {
      await db
          .collection('users')
          .doc(firebaseUID)
          .get()
          .then((DocumentSnapshot value) {
        if (value.data()['watchlist'].contains(widget.request.requestId) !=
            null) {
          setState(() {
            _addedToWatchlist = true;
          });
        } else {
          setState(() {
            _addedToWatchlist = false;
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getUserData() async {
    final DocumentReference db = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.request.creatorId);

    try {
      await db.get().then(
        (DocumentSnapshot value) {
          _currentUser = CurrentUser(
            firstName: value.data()['first_name'] as String,
            lastName: value.data()['last_name'] as String,
            imgUrl: value.data()['img_url'] as String,
            userId: widget.request.creatorId,
            rating: value.data()['rating'] as double,
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _geographicalData() async {
    await MapUtils.getAddress(widget.request.latLng).then(
      (Address value) {
        setState(
          () {
            displayAddress = value;
            circles.add(
              Circle(
                circleId: CircleId('123'),
                center: widget.request.latLng,
                radius: 200,
                strokeWidth: 1,
                fillColor: purple1.withOpacity(.2),
                strokeColor: Colors.white,
              ),
            );
          },
        );
      },
    );
    await MapUtils.getDistance(widget.request.latLng).then((num distanceValue) {
      setState(() {
        distance = distanceValue;
      });
    });
  }

  Future<void> _initFunction() async {
    await _geographicalData();
    await _checkIfWL();
    await _getUserData();
  }

  @override
  void initState() {
    _isLoading = true;

    _initFunction().then((_) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: MediaQuery.of(context).size.height * .9,
      width: double.infinity,
      decoration: BoxDecoration(
        color: white1,
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
      ),
      child: _isLoading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(gradient: blackGradient),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 25,
                          ),
                          ClipOval(
                            child: CircleAvatar(
                              radius: MediaQuery.of(context).size.height * .045,
                              backgroundColor: Colors.black,
                              child: Image.network(_currentUser.imgUrl),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                // ignore: lines_longer_than_80_chars
                                '${_currentUser.firstName} ${_currentUser.lastName.replaceRange(1, _currentUser.lastName.length, '.')}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const Icon(
                                CupertinoIcons.right_chevron,
                                color: Colors.white,
                                size: 16,
                              )
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '3 active orders • member since 2018',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RatingStars(
                                rating: _currentUser.rating,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                '(11)',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 15,
                      top: 15,
                      child: CloseButtonCostum(
                        context: context,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 22),
                        Row(
                          children: <Widget>[
                            Text(
                              widget.request.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              CupertinoIcons.location_solid,
                              size: 18,
                            ),
                            Text(
                              distance != null ? '$distance km' : '...',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.request.description,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                if (widget.request.category[0])
                                  CategoryBubble(
                                      mode: 0, size: 35, active: true),
                                if (widget.request.category[1])
                                  CategoryBubble(
                                      mode: 1, size: 35, active: true),
                                const SizedBox(width: 4),
                                if (widget.request.category[2])
                                  CategoryBubble(
                                      mode: 2, size: 35, active: true),
                              ],
                            ),
                            Container(
                              height: 35,
                              decoration: BoxDecoration(
                                boxShadow: [basicShadow],
                                color: red1,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  child: Text(
                                    // ignore: lines_longer_than_80_chars
                                    '${widget.request.finishDateTime.difference(DateTime.now()).inHours}h left',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const Divider(
                          height: 40,
                          thickness: 1,
                          color: Color(0xFFE6E6E6),
                        ),
                        const Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: <Widget>[
                            const Icon(
                              CupertinoIcons.location_solid,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              displayAddress == null
                                  ? 'Loading...'
                                  // ignore: lines_longer_than_80_chars
                                  : '${displayAddress.subLocality}, ${displayAddress.adminArea}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: black1.withOpacity(.8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          height: 130,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: [basicShadow],
                            color: subtleGrey,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          child: _isLoading
                              ? const Center(
                                  child: CupertinoActivityIndicator(),
                                )
                              : GoogleMap(
                                  onTap: (LatLng argument) async {
                                    await MapUtils.openMap(
                                        widget.request.latLng);
                                  },
                                  myLocationEnabled: true,
                                  zoomControlsEnabled: false,
                                  rotateGesturesEnabled: false,
                                  scrollGesturesEnabled: false,
                                  tiltGesturesEnabled: false,
                                  zoomGesturesEnabled: false,
                                  myLocationButtonEnabled: false,
                                  initialCameraPosition: CameraPosition(
                                    target: widget.request.latLng,
                                    zoom: 13.5,
                                  ),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);
                                  },
                                  circles: circles,
                                ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: ButtonTemplate(
                                height: 40,
                                radius: 100,
                                gradient: purpleGradient,
                                icon: CupertinoIcons.share,
                                iconSize: 16,
                                text: 'Share',
                                textSize: 12,
                                function: () {
                                  print('Share');
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ButtonTemplate(
                                height: 40,
                                radius: 100,
                                gradient: purpleGradient,
                                icon: CupertinoIcons.heart_fill,
                                iconSize: 16,
                                text: _addedToWatchlist
                                    ? 'Remove from Watchlist'
                                    : 'Add to Watchlist',
                                textSize: 12,
                                function: () {
                                  Provider.of<WatchlistRequests>(context,
                                          listen: false)
                                      .updateWatchlist(_addedToWatchlist,
                                          widget.request, context)
                                      .then(
                                        (_) async => _checkIfWL(),
                                      );
                                  print('Watchlist');
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ButtonTemplate(
                          height: 45,
                          radius: 6,
                          gradient: purpleGradient,
                          icon: CupertinoIcons.mail,
                          iconSize: 16,
                          text: 'Make Offer',
                          textSize: 14,
                          function: () {
                            _openChat();
                            print('Offer');
                          },
                        ),
                        const SizedBox(height: 61.7),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
