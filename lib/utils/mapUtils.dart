import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong/latlong.dart' as latlong;

class MapUtils {
  MapUtils._();

  static Future<void> openMap(LatLng latLng) async {
    double latitude;
    double longitude;

    latitude = latLng.latitude;
    longitude = latLng.longitude;

    final String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static Future<LatLng> getCurrentLocation() async {
    final Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();

    return LatLng(_locationData.latitude, _locationData.longitude);
  }

  static Future<Address> getAddress(LatLng latLng) async {
    Address displayAddress;
    List<Address> addresses;
    final Coordinates coordinates =
        Coordinates(latLng.latitude, latLng.longitude);

    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

    displayAddress = addresses.first;

    return displayAddress;
  }

  static Future<num> getDistance(LatLng requestLatLng) async {
    const latlong.Distance distance = latlong.Distance();
    LatLng currentLocationLatLng;

    await getCurrentLocation().then((LatLng currentLocation) {
      currentLocationLatLng = currentLocation;
    });

    final num distanceInKm = distance.as(
      latlong.LengthUnit.Kilometer,
      latlong.LatLng(requestLatLng.latitude, requestLatLng.longitude),
      latlong.LatLng(
          currentLocationLatLng.latitude, currentLocationLatLng.longitude),
    );

    return distanceInKm;
  }
}
