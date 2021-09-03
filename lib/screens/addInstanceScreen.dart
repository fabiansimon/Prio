import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/data/request.dart';
import 'package:prio_project/data/user.dart';
import 'package:prio_project/provider/privateReqProv.dart';
import 'package:prio_project/provider/requestsProv.dart';
import 'package:prio_project/widgets/addSheet.dart';
import 'package:prio_project/widgets/appBarCostum.dart';
import 'package:prio_project/widgets/jobTile.dart';
import 'package:prio_project/widgets/statusDetail.dart';
import 'package:provider/provider.dart';

class AddInstanceScreen extends StatefulWidget {
  @override
  _AddInstanceScreenState createState() => _AddInstanceScreenState();
}

class _AddInstanceScreenState extends State<AddInstanceScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Request> requests = Provider.of<PersonalRequests>(context).items;
    final FirebaseAuth firebase = FirebaseAuth.instance;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .005 +
                          MediaQuery.of(context).size.height * .17,
                    ),
                    if (mainUser.openRequestId.isNotEmpty)
                      MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: requests
                                  .where((Request element) =>
                                      element.creatorId ==
                                      firebase.currentUser.uid)
                                  .toList()
                                  .length +
                              1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index ==
                                requests
                                    .where((Request element) =>
                                        element.creatorId ==
                                        firebase.currentUser.uid)
                                    .toList()
                                    .length) {
                              return Center(
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet<dynamic>(
                                      isScrollControlled: true,
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return AddSheet();
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: <BoxShadow>[basicShadow]),
                                    child: Icon(
                                      CupertinoIcons.add_circled_solid,
                                      size: 28,
                                      color: purple2,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet<dynamic>(
                                    isScrollControlled: true,
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (BuildContext context) {
                                      return StatusDetails(
                                        request: requests
                                            .where((Request element) =>
                                                element.creatorId ==
                                                firebase.currentUser.uid)
                                            .toList()[index],
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: JobTile(
                                    request: requests
                                        .where((Request element) =>
                                            element.creatorId ==
                                            firebase.currentUser.uid)
                                        .toList()[index],
                                  ),
                                ),
                              );
                            }
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
            title: 'Add Request',
          ),
        ],
      ),
    );
  }
}
