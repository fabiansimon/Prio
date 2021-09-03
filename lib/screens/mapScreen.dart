import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/data/request.dart';
import 'package:prio_project/data/user.dart';
import 'package:prio_project/provider/requestsProv.dart';
import 'package:prio_project/utils/mapUtils.dart';
import 'package:prio_project/widgets/jobDetail.dart';
import 'package:prio_project/widgets/jobTile.dart';
import 'package:prio_project/widgets/textFieldCostum.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final PageController _pageViewController = PageController();
  BitmapDescriptor customIcon;

  static const LatLng _startCenter = LatLng(
    48.210033,
    16.363449,
  );

  bool _isLoading = false;
  bool _isInit = false;

  Set<Circle> circles = <Circle>{};
  Set<Marker> markers = <Marker>{};

  Future<void> _getRequestCirlces() async {
    final Requests requestsData = Provider.of<Requests>(context, listen: false);
    final List<Request> requests = requestsData.items;

    if (requests.isNotEmpty)
      // ignore: curly_braces_in_flow_control_structures
      for (int i = 0; i < requests.length; i++) {
        circles.add(
          Circle(
              circleId: CircleId(i.toString()),
              consumeTapEvents: true,
              center: requests[i].latLng,
              radius: 150,
              strokeColor: Colors.white,
              fillColor: purple1.withOpacity(.2),
              strokeWidth: 1,
              onTap: () {
                _animateNewCoordinates(requests[i].latLng).then((value) {
                  _pageViewController.jumpToPage(i);
                });
              }),
        );
        markers.add(
          Marker(
            consumeTapEvents: true,
            markerId: MarkerId('123'),
            icon: customIcon,
            position: requests[i].latLng,
          ),
        );
      }
  }

  Future<void> _animateNewCoordinates(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 13.5),
      ),
    );
  }

  @override
  void initState() {
    if (!_isInit) {
      _isLoading = true;
      final Requests requestData =
          Provider.of<Requests>(context, listen: false);

      requestData.fetchAndSetRequests().then((_) {
        if (requestData.items.isEmpty) {
          MapUtils.getCurrentLocation().then((LatLng currentLocation) {
            _animateNewCoordinates(currentLocation);
          });
        } else {
          BitmapDescriptor.fromAssetImage(
                  const ImageConfiguration(
                    size: Size(0.3, 0.2),
                  ),
                  'assets/markerMap.png')
              .then((BitmapDescriptor d) {
            customIcon = d;
          }).then((_) {
            _getRequestCirlces().then((_) {
              _animateNewCoordinates(requestData.items[0].latLng);
            });
          });
        }
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
          _isInit = true;
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Requests requestsData = Provider.of<Requests>(context);
    final List<Request> requests = requestsData.items;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          if (_isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
              child: const Center(
                child: CupertinoActivityIndicator(),
              ),
            )
          else
            GoogleMap(
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              initialCameraPosition: const CameraPosition(
                target: _startCenter,
                zoom: 11.0,
              ),
              onMapCreated: (GoogleMapController controller) async {
                _controller.complete(controller);
              },
              markers: markers,
              circles: circles,
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        height: MediaQuery.of(context).size.height * .05 + 10),
                    const Image(
                      image: AssetImage('assets/temporaryLogo.png'),
                      height: 20,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[basicShadow],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Icon(CupertinoIcons.search),
                          ),
                          const Expanded(
                            child: TextFieldCostum(
                              hintText: 'Stephansplatz',
                              autoCorrection: false,
                              obscureText: false,
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: GestureDetector(
                              onTap: () {
                                MapUtils.getCurrentLocation().then(
                                  (LatLng value) async {
                                    _animateNewCoordinates(value);
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[basicShadow],
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    CupertinoIcons.location_fill,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 90.0),
                child: SizedBox(
                  height: 75,
                  width: double.infinity,
                  child: requests.isEmpty
                      ? const SizedBox()
                      : PageView.builder(
                          controller: _pageViewController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          onPageChanged: (int value) {
                            _animateNewCoordinates(requests[value].latLng);
                          },
                          itemCount: requests.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet<dynamic>(
                                    isScrollControlled: true,
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (BuildContext context) {
                                      return JobDetail(
                                        request: requests[index],
                                      );
                                    },
                                  );
                                },
                                child: JobTile(
                                  request: requests[index],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
