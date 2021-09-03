import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prio_project/data/request.dart';
import 'package:prio_project/provider/requestsProv.dart';
import 'package:provider/provider.dart';

class WatchlistRequests with ChangeNotifier {
  List<Request> _items = <Request>[];

  List<Request> get items {
    return <Request>[..._items];
  }

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> fetchWatchlist(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final List<Request> requests =
        Provider.of<Requests>(context, listen: false).items;
    List<String> watchlistIds = <String>[];
    _items = <Request>[];

    try {
      await db.collection('users').doc(auth.currentUser.uid).get().then(
        (DocumentSnapshot value) {
          print(value.data()['watchlist']);
          watchlistIds = value.data()['watchlist'] as List<String>;
          for (int i = 0; i < watchlistIds.length; i++) {
            _items.add(
              requests.firstWhere(
                (Request element) => element.requestId == watchlistIds[i],
              ),
            );
            notifyListeners();
          }
        },
      );
    } catch (e) {
      print(e);
    }
    print(_items);
  }

  Future<void> updateWatchlist(
      bool _addedToWatchlist, Request request, BuildContext context) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final String firebaseUID = FirebaseAuth.instance.currentUser.uid;
    List<String> watchlistUpdated = <String>[];

    try {
      if (_addedToWatchlist) {
        await db.collection('users').doc(firebaseUID).update(
          {
            'watchlist': FieldValue.arrayRemove(
              [request.requestId],
            )
          },
        ).then((_) => fetchWatchlist(context));
      } else {
        await db
            .collection('users')
            .doc(firebaseUID)
            .get()
            .then((DocumentSnapshot value) {
          if (value.data()['watchlist'] != null) {
            watchlistUpdated = value.data()['watchlist'] as List<String>;
            if (watchlistUpdated.contains(request.requestId)) {
              print('ALREADY ADDED');
            } else {
              watchlistUpdated.add(request.requestId);
              db.collection('users').doc(firebaseUID).update({
                'watchlist': FieldValue.arrayUnion(watchlistUpdated),
              });
            }
          } else {
            db.collection('users').doc(firebaseUID).update({
              'watchlist': FieldValue.arrayUnion([request.requestId]),
            });
          }
        }).then((_) => fetchWatchlist(context));
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
