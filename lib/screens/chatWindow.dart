import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/data/user.dart';
import 'package:prio_project/utils/chatUtils.dart';
import 'package:prio_project/widgets/chatBubble.dart';
import 'package:prio_project/widgets/closeButtonCostum.dart';
import 'package:prio_project/widgets/draggableContainer.dart';
import 'package:prio_project/widgets/infoText.dart';
import 'package:prio_project/widgets/profilePic.dart';
import 'package:intl/intl.dart';
import 'package:prio_project/widgets/textFieldCostum.dart';

class ChatWindow extends StatefulWidget {
  const ChatWindow({
    Key key,
    @required this.chatId,
  }) : super(key: key);
  final String chatId;

  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final TextEditingController _chatController = TextEditingController();

  Map<String, String> infoMap;

  bool _isLoading;
  bool _isInit = false;

  // Get initial Data
  Future<void> _initData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      infoMap = await ChatUtils.getChatInformation(widget.chatId)
          as Map<String, String>;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    if (!_isInit) {
      _initData();
      _isInit = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = infoMap['createdAt'] as DateTime;
    return Scaffold(
      backgroundColor: white1,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[basicShadow],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 35.0, bottom: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Icon(
                                    CupertinoIcons.chevron_back,
                                    color: black1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 2),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  _isLoading ? ' ' : infoMap['firstName'],
                                  style: TextStyle(
                                    color: black1,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Container(
                            height: 40,
                            width: 40,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[basicShadow],
                              color: black2,
                              shape: BoxShape.circle,
                            ),
                            child: _isLoading
                                ? Image.asset('assets/profileIcon.png')
                                : Image.network(infoMap['imgUrl']),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!_isLoading)
                  Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 30,
                        decoration: BoxDecoration(gradient: redGradient),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                'Time left to negotiate',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                // ignore: lines_longer_than_80_chars
                                '${dateTime.difference(DateTime.now().add(Duration(hours: -2))).inMinutes.abs()} min',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isLoading
                            ? ''
                            // ignore: lines_longer_than_80_chars
                            : 'Chat created on the ${DateFormat('dd.MM.yyyy hh:mm').format(dateTime)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: subtleGrey,
                        ),
                      ),
                    ],
                  )
                else
                  const SizedBox(),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: _isLoading
                    ? const Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chats')
                            .doc(widget.chatId)
                            .collection('messages')
                            .orderBy('created_at')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.none) {
                            return const CupertinoActivityIndicator();
                          } else {
                            return SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: MediaQuery.removePadding(
                                context: context,
                                removeRight: true,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return index == snapshot.data.docs.length
                                        ? const SizedBox(height: 100)
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: ChatBubble(
                                              text: snapshot.data.docs[index]
                                                  ['message'] as String,
                                              isSelf: snapshot.data.docs[index]
                                                      ['user_id'] ==
                                                  FirebaseAuth
                                                      .instance.currentUser.uid,
                                              dateTime: snapshot
                                                      .data.docs[index]
                                                  ['created_at'] as DateTime,
                                            ),
                                          );
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[basicShadow],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 22.0,
                  right: 22.0,
                  top: 14.0,
                  bottom: 30.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: white1,
                    boxShadow: <BoxShadow>[basicShadow],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet<void>(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  clipBehavior: Clip.hardEdge,
                                  height: 300,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      gradient: blackGradient),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          gradient: purpleGradient,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: const <Widget>[
                                                  Icon(
                                                    CupertinoIcons
                                                        .money_dollar_circle,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    'Send offer',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              CloseButtonCostum(
                                                context: context,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                      const Text(
                                        '10\$',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationStyle:
                                              TextDecorationStyle.dotted,
                                          fontSize: 50,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'your offer',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                      Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          border: Border.all(
                                            color: purple2,
                                          ),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .8,
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              height: 60,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .4,
                                              decoration: BoxDecoration(
                                                gradient: purpleGradient,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Swipe to send',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 60,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .39,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    CupertinoIcons
                                                        .chevron_forward,
                                                    color: Colors.white
                                                        .withOpacity(.15),
                                                    size: 15,
                                                  ),
                                                  Icon(
                                                    CupertinoIcons
                                                        .chevron_forward,
                                                    color: Colors.white
                                                        .withOpacity(.3),
                                                    size: 15,
                                                  ),
                                                  const Icon(
                                                    CupertinoIcons
                                                        .chevron_forward,
                                                    color: Colors.white,
                                                    size: 15,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[basicShadow],
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(3),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                CupertinoIcons.money_dollar_circle_fill,
                                color: black2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFieldCostum(
                          autoCorrection: true,
                          hintText: 'Send message',
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          textCapitalization: TextCapitalization.sentences,
                          textEditingController: _chatController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            if (_chatController.text.isNotEmpty) {
                              FocusScope.of(context).unfocus();
                              ChatUtils.sendMessage(widget.chatId,
                                      _chatController.text.trim())
                                  .then(
                                (_) {
                                  _chatController.clear();
                                },
                              );
                            }
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              boxShadow: [basicShadow],
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(3),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                CupertinoIcons.arrow_up,
                                color: black2,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
