import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/data/personalInfo.dart';
import 'package:prio_project/data/request.dart';
import 'package:prio_project/data/user.dart';
import 'package:prio_project/provider/personalInfosProv.dart';
import 'package:prio_project/provider/privateReqProv.dart';
import 'package:prio_project/provider/requestsProv.dart';
import 'package:prio_project/utils/dualDialog.dart';
import 'package:prio_project/widgets/appBarCostum.dart';
import 'package:prio_project/widgets/jobTile.dart';
import 'package:prio_project/widgets/profileHeader.dart';
import 'package:prio_project/widgets/statusDetail.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final PersonalRequests requestsData =
        Provider.of<PersonalRequests>(context);
    final List<Request> requests = requestsData.items;
    // final FirebaseAuth firebase = FirebaseAuth.instance;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .005 +
                          MediaQuery.of(context).size.height * .17,
                    ),
                    GestureDetector(
                      onTap: () {
                        // ignore: avoid_function_literals_in_foreach_calls
                        requests.forEach((Request element) {
                          print(element.creatorId);
                        });
                      },
                      child: ProfileHeader(),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Active requests',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        letterSpacing: -.7,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (requests.isNotEmpty)
                      MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: requests.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                showModalBottomSheet<dynamic>(
                                  isScrollControlled: true,
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (BuildContext context) {
                                    return StatusDetails(
                                      request: requests[index],
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Dismissible(
                                  // ignore: missing_return
                                  confirmDismiss: (DismissDirection direction) {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      showDialog<Widget>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          if (Platform.isIOS) {
                                            return CupertinoAlertDialog(
                                              title: const Text('Are you sure'),
                                              content:
                                                  const SingleChildScrollView(
                                                child: Text(
                                                  'Do you want to remove your request?',
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Provider.of<Requests>(
                                                            context,
                                                            listen: false)
                                                        .deleteRequest(
                                                            requests[index])
                                                        .then(
                                                          (_) => Provider.of<
                                                                      PersonalRequests>(
                                                                  context,
                                                                  listen: false)
                                                              .fetchAndSetPersonalRequests(),
                                                        );
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('No'),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return AlertDialog(
                                              title: const Text('Are you sure'),
                                              content: const Text(
                                                'Do you want to remove your request?',
                                              ),
                                              actions: <Widget>[
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 8.0,
                                                    ),
                                                    child: Text('Yes'),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 8.0,
                                                    ),
                                                    child: Text('No'),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      );
                                    }
                                  },
                                  key: Key(requests[index].requestId),
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(right: 20),
                                    child: Icon(
                                      CupertinoIcons.delete,
                                      color: red1,
                                      size: 20,
                                    ),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  child: JobTile(
                                    request: requests[index],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Center(
                        child: Text(
                          'No active requests at the moment',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: subtleGrey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const AppBarCostum(
            title: 'Profile',
          ),
        ],
      ),
    );
  }
}
