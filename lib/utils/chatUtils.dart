import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prio_project/data/request.dart';

class ChatUtils {
  ChatUtils._();

  static Future<String> openChat(Request request) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    String valueId;
    dynamic myChatIds = <dynamic>[];
    dynamic theirChatIds = <dynamic>[];

    try {
      await db.collection('chats').add({
        'request_id': request.requestId,
        'receiver_id': request.creatorId,
        'sender_id': FirebaseAuth.instance.currentUser.uid,
        'created_at': Timestamp.now(),
      }).then((DocumentReference value) {
        valueId = value.id;

        db
            .collection('users')
            .doc(request.creatorId)
            .get()
            .then((DocumentSnapshot data) {
          theirChatIds = data.data()['receiver_chat_ids'];
          theirChatIds.add(valueId);
          db.collection('users').doc(request.creatorId).update({
            'receiver_chat_ids': FieldValue.arrayUnion([theirChatIds]),
          });
        });

        db
            .collection('users')
            .doc(auth.currentUser.uid)
            .get()
            .then((DocumentSnapshot data) {
          myChatIds = data.data()['sender_chat_ids'];
          myChatIds.add(valueId);
          db.collection('users').doc(auth.currentUser.uid).update({
            'sender_chat_ids': FieldValue.arrayUnion([myChatIds]),
          });
        });
      });
    } catch (e) {
      print(e);
      return null;
    }
    return valueId;
  }

  static Future<String> getChatId(String receiver) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    String id = '';

    try {
      await db
          .collection('chats')
          .where('receiver_id', isEqualTo: receiver)
          .where('sender_id', isEqualTo: auth.currentUser.uid)
          .get()
          .then((QuerySnapshot value) {
        id = value.docs[0].id;
      });
    } catch (e) {
      print(e);
    }

    return id;
  }

  static Future<void> sendMessage(String chatId, String message) async {
    final DocumentReference db =
        FirebaseFirestore.instance.collection('chats').doc(chatId);

    try {
      await db.collection('messages').add(
        <String, dynamic>{
          'message': message,
          'user_id': FirebaseAuth.instance.currentUser.uid,
          'created_at': Timestamp.now(),
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<Map<String, dynamic>> getChatInformation(String chatId) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    String receiverId;
    String imgUrl;
    String firstName;
    String lastName;
    DateTime createdAt;
    Map<String, dynamic> returnMap;

    try {
      await db
          .collection('chats')
          .doc(chatId)
          .get()
          .then((DocumentSnapshot value) {
        receiverId = value.data()['receiver_id'] as String;
        createdAt = value.data()['created_at'].toDate() as DateTime;
      });

      await db
          .collection('users')
          .doc(receiverId)
          .get()
          .then((DocumentSnapshot user) {
        firstName = user.data()['first_name'] as String;
        lastName = user.data()['last_name'] as String;
        imgUrl = user.data()['img_url'] as String;

        returnMap = <String, dynamic>{
          'firstName': firstName,
          'lastName': lastName,
          'imgUrl': imgUrl,
          'createdAt': createdAt,
        };
      });
    } catch (e) {
      print(e);
    }
    print(returnMap);
    return returnMap;
  }
}
