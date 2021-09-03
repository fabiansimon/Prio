import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/provider/personalInfosProv.dart';
import 'package:prio_project/provider/privateReqProv.dart';
import 'package:prio_project/provider/requestsProv.dart';
import 'package:prio_project/screens/addInstanceScreen.dart';
import 'package:prio_project/screens/chatScreen.dart';
import 'package:prio_project/screens/homeScreen.dart';
import 'package:prio_project/screens/mapScreen.dart';
import 'package:prio_project/screens/profileScreen.dart';
import 'package:provider/provider.dart';

class NavigatorScreen extends StatefulWidget {
  @override
  _NavigatorScreenState createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  final PageController _pageController = PageController();
  final List<Widget> _screens = [
    HomeScreen(),
    MapScreen(),
    AddInstanceScreen(),
    ChatScreen(),
    ProfileScreen()
  ];

  int _selectedIndex = 0;
  bool _isInit = false;
  bool _isLoading = false;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _selectedIndex = selectedIndex;
    _pageController.jumpToPage(selectedIndex);
  }

  Future<void> _gatherAllInfo() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<PersonalInfos>(context, listen: false).getPersonalData();
    await Provider.of<Requests>(context, listen: false).fetchAndSetRequests();
    await Provider.of<PersonalRequests>(context, listen: false)
        .fetchAndSetPersonalRequests();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    if (!_isInit) {
      _gatherAllInfo();
      _isInit = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: white1,
        extendBody: true,
        body: _isLoading
            ? Container(
                decoration: BoxDecoration(
                  gradient: purpleGradient,
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/launchScreenIcon.png',
                      height: 40,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Getting all the important \ninformations right now!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const CupertinoActivityIndicator(),
                  ],
                ),
              )
            : PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                physics: const NeverScrollableScrollPhysics(),
                children: _screens,
              ),
        bottomNavigationBar: _isLoading
            ? const SizedBox()
            : Container(
                decoration: BoxDecoration(
                  color: black2,
                  boxShadow: [basicShadow],
                ),
                width: double.infinity,
                height: 75,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => _onItemTapped(0),
                          child: Container(
                            color: Colors.transparent,
                            child: Icon(
                              _selectedIndex == 0
                                  ? CupertinoIcons.house_fill
                                  : CupertinoIcons.house,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _onItemTapped(1),
                          child: Container(
                            color: Colors.transparent,
                            child: Icon(
                              _selectedIndex == 1
                                  ? CupertinoIcons.map_fill
                                  : CupertinoIcons.map,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _onItemTapped(2),
                          child: Container(
                            color: Colors.transparent,
                            child: Icon(
                              _selectedIndex == 2
                                  ? CupertinoIcons.add_circled_solid
                                  : CupertinoIcons.add_circled,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _onItemTapped(3),
                          child: Container(
                            color: Colors.transparent,
                            child: Icon(
                              _selectedIndex == 3
                                  ? CupertinoIcons.mail_solid
                                  : CupertinoIcons.mail,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _onItemTapped(4),
                          child: Container(
                            color: Colors.transparent,
                            child: Icon(
                              _selectedIndex == 4
                                  ? CupertinoIcons.person_crop_circle_fill
                                  : CupertinoIcons.person_crop_circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
