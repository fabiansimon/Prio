import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prio_project/data/request.dart';

class PersonalRequests with ChangeNotifier {
  List<Request> _items = <Request>[];

  List<Request> get items {
    return <Request>[..._items];
  }

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> fetchAndSetPersonalRequests() async {
    final FirebaseAuth firebase = FirebaseAuth.instance;

    try {
      await db
          .collection('requests')
          .where('creatorId', isEqualTo: firebase.currentUser.uid)
          .get()
          .then(
        (QuerySnapshot requests) {
          final List<Request> addedRequests = <Request>[];
          if (requests != null) {
            // ignore: avoid_function_literals_in_foreach_calls
            requests.docs.forEach(
              (QueryDocumentSnapshot element) {
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
}
