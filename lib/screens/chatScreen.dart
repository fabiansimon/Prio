import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prio_project/data/chat.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/data/request.dart';
import 'package:prio_project/data/user.dart';
import 'package:prio_project/provider/personalInfosProv.dart';
import 'package:prio_project/provider/privateReqProv.dart';
import 'package:prio_project/provider/requestsProv.dart';
import 'package:prio_project/screens/chatWindow.dart';
import 'package:prio_project/widgets/appBarCostum.dart';
import 'package:prio_project/widgets/infoText.dart';
import 'package:prio_project/widgets/offerChat.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class ChatPreview {
  const ChatPreview({
    this.requestId,
    this.firstName,
    this.lastName,
    this.imgUrl,
    this.chatId,
  });
  final String requestId;
  final String firstName;
  final String lastName;
  final String imgUrl;
  final String chatId;
}

class OfferPreview {
  const OfferPreview({
    this.requestId,
    this.title,
    this.chatId,
    this.finishDateTime,
    this.firstName,
    this.lastName,
    this.imageUrl,
  });
  final String requestId;
  final String title;
  final String chatId;
  final String imageUrl;
  final String firstName;
  final String lastName;
  final DateTime finishDateTime;
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isInit = false;
  bool _isLoading = false;
  final List<ChatPreview> _chatPreviews = <ChatPreview>[];
  final List<OfferPreview> _offerPreviews = <OfferPreview>[];
  bool _isRequests = true;

  // Get initals Offers
  Future<void> _getOffers() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    List<dynamic> senderList = <dynamic>[];
    String requestId;
    String title;
    String chatId;
    String imageUrl;
    String firstName;
    String lastName;
    DateTime finishDateTime;

    try {
      await db
          .collection('users')
          .doc(auth.currentUser.uid)
          .get()
          .then((DocumentSnapshot value) async {
        senderList = value.data()['sender_chat_ids'] as List<dynamic>;
        for (int i = 0; i < senderList.length; i++) {
          await db
              .collection('chats')
              .doc(senderList[i] as String)
              .get()
              .then((DocumentSnapshot chatValue) async {
            requestId = await chatValue.data()['request_id'] as String;
            db
                .collection('requests')
                .doc(chatValue.data()['request_id'] as String)
                .get()
                .then((DocumentSnapshot requestValue) async {
              title = await requestValue.data()['title'] as String;
              finishDateTime = await requestValue
                  .data()['finishDateTime']
                  .toDate() as DateTime;
            });
          }).then((Object userValue) async {
            // db.collection("users").doc()
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // Get inital Previews
  Future<void> _getPreviews() async {
    setState(() {
      _isLoading = true;
    });

    final List<Request> personalRequests =
        Provider.of<PersonalRequests>(context, listen: false).items;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    String chatId;
    String firstName;
    String requestId;
    String lastName;
    String imgUrl;

    try {
      for (int i = 0; i < personalRequests.length; i++) {
        await db
            .collection('chats')
            .where('request_id', isEqualTo: personalRequests[i].requestId)
            .get()
            .then(
          (QuerySnapshot chatVal) {
            if (chatVal.docs.isNotEmpty) {
              for (var j = 0; j < chatVal.docs.length; j++) {
                db
                    .collection('users')
                    .doc(chatVal.docs[j].data()['sender_id'] as String)
                    .get()
                    .then(
                  (userVal) async {
                    chatId = chatVal.docs[0].id;
                    firstName = await userVal.data()['first_name'] as String;
                    lastName = await userVal.data()['last_name'] as String;
                    imgUrl = await userVal.data()['img_url'] as String;
                    requestId =
                        await chatVal.docs[j].data()['request_id'] as String;
                    _chatPreviews.add(
                      ChatPreview(
                        requestId: requestId,
                        chatId: chatId,
                        firstName: firstName,
                        lastName: lastName,
                        imgUrl: imgUrl,
                      ),
                    );
                  },
                );
              }
            } else {
              // print("empty");
            }
          },
        );
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    if (!_isInit) {
      _getPreviews();
      _getOffers();
      _isInit = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Request> personalRequests =
        Provider.of<PersonalRequests>(context).items;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            alignment: Alignment.centerRight,
            children: <Widget>[
              const AppBarCostum(
                title: 'Chats',
              ),
              Positioned(
                right: 15,
                bottom: 10,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isRequests = true;
                        });
                      },
                      child: Container(
                        height: 35,
                        width: 90,
                        decoration: BoxDecoration(
                          color: _isRequests ? black1 : black1.withOpacity(.1),
                          boxShadow: <BoxShadow>[basicShadow],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Requests',
                            style: TextStyle(
                              fontSize: 12,
                              color: white1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isRequests = false;
                        });
                      },
                      child: Container(
                        height: 35,
                        width: 90,
                        decoration: BoxDecoration(
                          color: !_isRequests ? black1 : black1.withOpacity(.1),
                          boxShadow: <BoxShadow>[basicShadow],
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Offers',
                            style: TextStyle(
                              fontSize: 12,
                              color: white1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height - 172,
            child: _isLoading
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: personalRequests.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 22.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[basicShadow],
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        top: 12.0,
                                        bottom: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          personalRequests[index].title,
                                          style: TextStyle(
                                              color: black1,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: redGradient,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(6),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 4.0,
                                            ),
                                            child: Text(
                                              // ignore: lines_longer_than_80_chars
                                              '${personalRequests[index].finishDateTime.difference(DateTime.now()).abs().inHours} h left',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_chatPreviews
                                      .where((ChatPreview element) =>
                                          element.requestId ==
                                          personalRequests[index].requestId)
                                      .toList()
                                      .isNotEmpty)
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _chatPreviews
                                          .where((ChatPreview element) =>
                                              element.requestId ==
                                              personalRequests[index].requestId)
                                          .toList()
                                          .length,
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<BuildContext>(
                                                builder: (
                                                  BuildContext context,
                                                ) =>
                                                    ChatWindow(
                                                  chatId: _chatPreviews
                                                      .where((ChatPreview
                                                              element) =>
                                                          element.requestId ==
                                                          personalRequests[
                                                                  index]
                                                              .requestId)
                                                      .toList()[i]
                                                      .chatId,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 60,
                                            decoration: BoxDecoration(
                                              gradient: blackGradient,
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: ClipOval(
                                                    child: CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor:
                                                          Colors.black,
                                                      child: Image.network(
                                                        _chatPreviews
                                                            .where((ChatPreview
                                                                    element) =>
                                                                element
                                                                    .requestId ==
                                                                personalRequests[
                                                                        index]
                                                                    .requestId)
                                                            .toList()[i]
                                                            .imgUrl,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        // ignore: lines_longer_than_80_chars
                                                        '${_chatPreviews.where((element) => element.requestId == personalRequests[index].requestId).toList()[i].firstName} ${_chatPreviews.where((element) => element.requestId == personalRequests[index].requestId).toList()[i].lastName}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      const Text(
                                                        'Nah i dont think thats fair, lets do...',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                                  child: Icon(
                                                    CupertinoIcons.mail,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  else
                                    const SizedBox(
                                      width: double.infinity,
                                      child: Center(
                                        child: InfoText(
                                          text: 'No offer at the moment',
                                        ),
                                      ),
                                    ),
                                  const SizedBox(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
