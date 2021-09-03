import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prio_project/data/personalInfo.dart';

class PersonalInfos with ChangeNotifier {
  PersonalInfo _item;

  PersonalInfo get items {
    return _item;
  }

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> getPersonalData() async {
    PersonalInfo personalInfo;
    try {
      // ignore: lines_longer_than_80_chars
      db
          .collection('users')
          .doc(auth.currentUser.uid)
          .get()
          .then((DocumentSnapshot value) {
        personalInfo = PersonalInfo(
          userId: auth.currentUser.uid,
          firstName: value['first_name'] as String,
          lastName: value['last_name'] as String,
          profilePic: value['img_url'] as String,
          birthdate: value['birthdate'].toDate() as DateTime,
          email: value['email'] as String,
          monthlyEarnings: value['monthly_earnings'] as double,
          monthlyGoal: value['monthly_goal'] as double,
          finishedOrders: value['finished_orders'] as int,
        );
        _item = personalInfo;

        notifyListeners();
      });
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }
}
