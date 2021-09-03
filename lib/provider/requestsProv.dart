import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prio_project/data/request.dart';

class Requests with ChangeNotifier {
  List<Request> _items = <Request>[];

  // final String authToken;
  // final String userId;

  // Requests(this._items);

  List<Request> get items {
    return <Request>[..._items];
  }

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> fetchAndSetRequests() async {
    final FirebaseAuth firebase = FirebaseAuth.instance;

    try {
      await db.collection('requests').orderBy('finishDateTime').get().then(
        (QuerySnapshot requests) {
          final List<Request> addedRequests = <Request>[];
          if (requests != null) {
            // ignore: avoid_function_literals_in_foreach_calls
            requests.docs.forEach(
              (QueryDocumentSnapshot element) {
                if (element['creatorId'] != firebase.currentUser.uid) {
                  addedRequests.add(
                    Request(
                      category: [
                        element['category'][0] as bool,
                        element['category'][1] as bool,
                        element['category'][2] as bool
                      ],
                      creatorId: element['creatorId'] as String,
                      deliveryFee: element['deliveryFee'] as double,
                      description: element['description'] as String,
                      finishDateTime:
                          element['finishDateTime'].toDate() as DateTime,
                      fulfillerId: element['fulfillerId'] as String,
                      latLng: LatLng(
                          element['Lat'] as double, element['Lng'] as double),
                      requestId: element.id,
                      title: element['title'] as String,
                    ),
                  );
                }
              },
            );
            _items = addedRequests;
            notifyListeners();
          } else {
            _items = <Request>[];
          }
          notifyListeners();
        },
      );
    } on FirebaseException catch (e) {
      throw e.message;
    }
  }

  Future<void> deleteRequest(Request request) async {
    try {
      await db.collection('requests').doc(request.requestId).delete().then((_) {
        fetchAndSetRequests();
      });
      notifyListeners();
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<void> addRequest(Request request) async {
    final FirebaseAuth firebase = FirebaseAuth.instance;

    try {
      await db.collection('requests').add(
        <String, dynamic>{
          'creatorId': firebase.currentUser.uid,
          'title': request.title,
          'description': request.description,
          'requestId': '',
          'deliveryFee': request.deliveryFee,
          'finishDateTime': request.finishDateTime,
          'fulfillerId': request.fulfillerId,
          'Lat': request.latLng.latitude,
          'Lng': request.latLng.longitude,
          'category': request.category
        },
      ).then((DocumentReference value) {
        final Request newRequest = Request(
          creatorId: request.creatorId,
          deliveryFee: request.deliveryFee,
          description: request.description,
          finishDateTime: request.finishDateTime,
          fulfillerId: request.fulfillerId,
          latLng: request.latLng,
          requestId: value.id,
          title: request.title,
          category: request.category,
        );
        _items.add(newRequest);
        notifyListeners();
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
