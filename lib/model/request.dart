import 'package:google_maps_flutter/google_maps_flutter.dart';

class Request {
  String requestId;
  String creatorId;
  String fulfillerId;
  String title;
  String description;
  LatLng latLng;
  DateTime finishDateTime;
  double deliveryFee;
  double distance;
  List<bool> category;

  Request({
    this.requestId,
    this.creatorId,
    this.fulfillerId,
    this.title,
    this.description,
    this.latLng,
    this.finishDateTime,
    this.deliveryFee,
    this.distance,
    this.category,
  });
}
