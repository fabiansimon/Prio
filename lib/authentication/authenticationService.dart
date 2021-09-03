import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:prio_project/provider/personalInfosProv.dart';
import 'package:prio_project/utils/oneOptionDialog.dart';
import 'package:provider/provider.dart';

class AuthenticationService {
  AuthenticationService(
    this._firebaseAuth,
  );
  final FirebaseAuth _firebaseAuth;
  bool isLoading = true;

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> logIn(
      String email, String password, BuildContext context) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'Logged In';
    } on FirebaseAuthException catch (e) {
      print(e.message);
      showDialog<Widget>(
        context: context,
        builder: (BuildContext context) {
          return OneOptionDialog(
            title: 'Hey Wait!',
            text: e.message,
            context: context,
          );
        },
      );
      return e.message;
    }
  }

  Future<String> signUp(
      String email,
      String password,
      String firstName,
      String lastName,
      BuildContext context,
      DateTime birthdate,
      String phoneNr,
      File profilePic) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (UserCredential value) {
          print(_firebaseAuth.currentUser.uid);
          final Reference ref = storage.ref().child(value.user.uid);
          ref.putFile(profilePic).then((TaskSnapshot value) {
            print(value.ref);
            ref.getDownloadURL().then((String value) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .set(
                <String, dynamic>{
                  'email': email,
                  'first_name': firstName,
                  'last_name': lastName,
                  'birthdate': birthdate,
                  'phone_nr': phoneNr,
                  'img_url': value,
                  'monthly_earnings': 0.1,
                  'monthly_goal': 0.1,
                  'finished_orders': 0,
                  'watchlist': <String>[],
                  'receiver_chat_ids': <String>[],
                  'sender_chat_ids': <String>[],
                },
              );
            });
          }).then((_) {
            Provider.of<PersonalInfos>(context, listen: false)
                .getPersonalData();
          });
        },
      );

      return 'Signed Up';
    } on FirebaseAuthException catch (e) {
      print(e.message);
      showDialog<Widget>(
        context: context,
        builder: (BuildContext context) {
          return OneOptionDialog(
            title: 'Hey Wait!',
            text: e.message,
            context: context,
          );
        },
      );
      return e.message;
    }
  }
}
