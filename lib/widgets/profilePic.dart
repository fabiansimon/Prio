import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/data/personalInfo.dart';
import 'package:prio_project/provider/personalInfosProv.dart';
import 'package:provider/provider.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key key,
    @required this.size,
    @required this.image,
  }) : super(key: key);
  final double size;
  final String image;

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  @override
  Widget build(BuildContext context) {
    final PersonalInfo personalData = Provider.of<PersonalInfos>(context).items;
    return Container(
      clipBehavior: Clip.hardEdge,
      height: widget.size,
      width: widget.size,
      decoration: BoxDecoration(
        border: Border.all(color: black1),
        color: black2,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          basicShadow,
        ],
      ),
      child: personalData.profilePic != null
          ? ClipOval(
              child: Image.network(personalData.profilePic),
            )
          : const SizedBox(),
    );
  }
}
