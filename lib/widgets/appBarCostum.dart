import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/utils/dualDialog.dart';

class AppBarCostum extends StatefulWidget {
  const AppBarCostum({
    Key key,
    this.title,
  }) : super(key: key);
  final String title;

  @override
  _AppBarCostumState createState() => _AppBarCostumState();
}

class _AppBarCostumState extends State<AppBarCostum> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .15,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              basicShadow,
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * .05),
                const Image(
                  image: AssetImage('assets/temporaryLogo.png'),
                  height: 20,
                ),
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    letterSpacing: -.7,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.title == 'Profile')
          GestureDetector(
            onTap: () {
              showDialog<Widget>(
                context: context,
                builder: (BuildContext context) {
                  return DualDialog(
                    title: 'Hey Wait!',
                    text: 'Are you sure you want to log out?',
                    function: FirebaseAuth.instance.signOut,
                    context: context,
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: white1,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(3),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.logout,
                        size: 16,
                        color: black1.withOpacity(.6),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 13,
                          color: black1.withOpacity(.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        else
          const SizedBox(),
      ],
    );
  }
}
