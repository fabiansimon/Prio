import 'package:flutter/material.dart';
import 'package:prio_project/data/user.dart';
import 'package:prio_project/widgets/profilePic.dart';

class HeaderMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Image(
                  image: AssetImage('assets/temporaryLogo.png'),
                  height: 20,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Hey!',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    letterSpacing: -.7,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Let's see if there is a suitable job for you!",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -.7,
                    fontSize: 13,
                    color: Colors.black.withOpacity(.6),
                  ),
                )
              ],
            ),
            ProfilePic(
              size: 50,
              image: mainUser.imageAsset,
            ),
          ],
        ),
      ),
    );
  }
}
