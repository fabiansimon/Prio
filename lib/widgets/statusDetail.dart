import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/data/request.dart';
import 'package:prio_project/utils/mapUtils.dart';
import 'package:prio_project/widgets/closeButtonCostum.dart';
import 'package:prio_project/widgets/ratingStars.dart';
import 'package:prio_project/widgets/statusContainer.dart';

class StatusDetails extends StatefulWidget {
  const StatusDetails({
    Key key,
    this.request,
  }) : super(key: key);
  final Request request;

  @override
  _StatusDetailsState createState() => _StatusDetailsState();
}

class _StatusDetailsState extends State<StatusDetails> {
  Address displayAddress;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  bool _isLoading = false;

  Set<Circle> circles = <Circle>{};

  @override
  void initState() {
    _isLoading = true;

    MapUtils.getAddress(widget.request.latLng).then(
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
            _isLoading = false;
          },
        );
      },
    );

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
                  Text(
                    widget.request.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .9 - 50,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  StatusContainer(status: 0),
                  const SizedBox(height: 30),
                  const Text(
                    'Your driver',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      letterSpacing: -.7,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[basicShadow],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Alexander W.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              RatingStars(
                                rating: 5,
                                color: black2,
                                size: 16,
                              ),
                            ],
                          ),
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[basicShadow],
                              gradient: purpleGradient,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.mail,
                                color: Colors.white,
                                size: 17.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Current Location',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      letterSpacing: -.7,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(),
                  Expanded(
                    child: SafeArea(
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [basicShadow],
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: GoogleMap(
                          onTap: (LatLng argument) async {
                            await MapUtils.openMap(widget.request.latLng);
                          },
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: widget.request.latLng,
                            zoom: 13.5,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          circles: circles,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
