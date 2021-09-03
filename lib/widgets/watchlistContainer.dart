import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/data/request.dart';
import 'package:prio_project/data/user.dart';
import 'package:prio_project/provider/requestsProv.dart';
import 'package:prio_project/provider/watchlistReqProv.dart';
import 'package:prio_project/utils/mapUtils.dart';
import 'package:prio_project/widgets/closeButtonCostum.dart';
import 'package:prio_project/widgets/infoText.dart';
import 'package:prio_project/widgets/jobDetail.dart';
import 'package:prio_project/widgets/jobTile.dart';
import 'package:provider/provider.dart';

class WatchlistContainer extends StatefulWidget {
  @override
  _WatchlistContainerState createState() => _WatchlistContainerState();
}

// ignore: constant_identifier_names
enum WatchlistState { ListView, MapView }

class _WatchlistContainerState extends State<WatchlistContainer> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  WatchlistState _watchlistState = WatchlistState.ListView;

  static LatLng _startCenter = const LatLng(48.210033, 16.363449);

  final List<Request> _watchlistRequests = <Request>[];

  bool _isLoading = false;

  Set<Circle> circles = <Circle>{};

  Future<void> _getRequestCirlces() async {
    final List<Request> wishlist =
        Provider.of<WatchlistRequests>(context, listen: false).items;

    // ignore: avoid_function_literals_in_foreach_calls
    wishlist.forEach(
      (Request element) {
        circles.add(
          Circle(
            circleId: CircleId('123'),
            center: element.latLng,
            radius: 200,
            strokeWidth: 1,
            fillColor: purple1.withOpacity(.2),
            strokeColor: Colors.white,
          ),
        );
      },
    );
  }

  Future<void> _animateNewCoordinates(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 13.5),
      ),
    );
  }

  @override
  void initState() {
    _isLoading = true;

    Provider.of<WatchlistRequests>(context, listen: false)
        .fetchWatchlist(context)
        .then(
      (_) {
        _getRequestCirlces().then(
          (void value) {
            setState(
              () {
                _isLoading = false;
                _startCenter = circles.elementAt(0).center;
              },
            );
          },
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Request> watchlist =
        Provider.of<WatchlistRequests>(context).items;

    return Stack(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          height: MediaQuery.of(context).size.height * .9,
          width: double.infinity,
          decoration: BoxDecoration(
            color: white1,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: blackGradient,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CloseButtonCostum(
                        context: context,
                      ),
                      const Text(
                        'Watchlist',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: watchlist.isNotEmpty
                    ? _watchlistState == WatchlistState.MapView
                        ? Stack(
                            children: [
                              GoogleMap(
                                myLocationButtonEnabled: false,
                                myLocationEnabled: true,
                                initialCameraPosition: CameraPosition(
                                  target: _startCenter,
                                  zoom: 13.5,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                                circles: circles,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [basicShadow],
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(100),
                                          bottomRight: Radius.circular(100),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 14.0,
                                          top: 6.0,
                                          bottom: 6.0,
                                        ),
                                        child: Text(
                                          '${watchlist.length} active jobs',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            letterSpacing: -.7,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SafeArea(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (_watchlistState ==
                                            WatchlistState.MapView)
                                          GestureDetector(
                                            onTap: () async {
                                              await MapUtils
                                                      .getCurrentLocation()
                                                  .then(
                                                (LatLng newLatLng) {
                                                  _animateNewCoordinates(
                                                      newLatLng);
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0, right: 20.0),
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  boxShadow: <BoxShadow>[
                                                    basicShadow
                                                  ],
                                                ),
                                                child: const Icon(
                                                  CupertinoIcons.location_fill,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        SizedBox(
                                          height: 75,
                                          width: double.infinity,
                                          child: PageView.builder(
                                            onPageChanged: (int value) {
                                              _animateNewCoordinates(
                                                watchlist[value].latLng,
                                              );
                                            },
                                            itemCount: watchlist.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet<
                                                        dynamic>(
                                                      isScrollControlled: true,
                                                      context: context,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      builder: (BuildContext
                                                          context) {
                                                        return JobDetail(
                                                          request:
                                                              watchlist[index],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: JobTile(
                                                    request: watchlist[index],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        : SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 20.0),
                                  child: Text(
                                    '${watchlist.length} active jobs',
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      letterSpacing: -.7,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: watchlist.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10.0,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet<dynamic>(
                                                isScrollControlled: true,
                                                context: context,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder:
                                                    (BuildContext context) {
                                                  return JobDetail(
                                                    request: watchlist[index],
                                                  );
                                                },
                                              );
                                            },
                                            child: JobTile(
                                              request: watchlist[index],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                    : Center(
                        child: InfoText(
                          text: 'No active jobs in your Watchlist',
                        ),
                      ),
              ),
            ],
          ),
        ),
        if (watchlist.isNotEmpty)
          Positioned(
            right: 20,
            top: 30,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (_watchlistState == WatchlistState.ListView) {
                    _watchlistState = WatchlistState.MapView;
                  } else {
                    _watchlistState = WatchlistState.ListView;
                  }
                });
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [basicShadow],
                ),
                child: Icon(
                  _watchlistState == WatchlistState.ListView
                      ? CupertinoIcons.map
                      : CupertinoIcons.list_bullet,
                  size: 20,
                ),
              ),
            ),
          )
        else
          const SizedBox(),
      ],
    );
  }
}
