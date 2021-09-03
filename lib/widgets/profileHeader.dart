import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/data/personalInfo.dart';
import 'package:prio_project/data/user.dart';
import 'package:prio_project/provider/personalInfosProv.dart';
import 'package:prio_project/widgets/buttonTemplate.dart';
import 'package:prio_project/widgets/profilePic.dart';
import 'package:prio_project/widgets/watchlistContainer.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatefulWidget {
  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    final PersonalInfo personalData = Provider.of<PersonalInfos>(context).items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(6),
            ),
            boxShadow: <BoxShadow>[
              basicShadow,
            ],
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .05,
                  ),
                  ProfilePic(
                    size: 60,
                    image: personalData.profilePic,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .05,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${personalData.firstName} ${personalData.lastName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '2 active orders • ' + '1 fulfilled orders',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF323232),
                          fontSize: 11,
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .08,
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(6),
                        ),
                        border: Border.all(
                          color: subtleGrey,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              CupertinoIcons.profile_circled,
                              color: subtleGrey,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: subtleGrey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .02,
                  ),
                  Expanded(
                    child: ButtonTemplate(
                      height: 40,
                      radius: 6,
                      gradient: purpleGradient,
                      icon: CupertinoIcons.heart_fill,
                      iconSize: 18,
                      text: 'Watchlist',
                      textSize: 14,
                      function: () {
                        showModalBottomSheet<dynamic>(
                          isScrollControlled: true,
                          enableDrag: false,
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return WatchlistContainer();
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .08,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
