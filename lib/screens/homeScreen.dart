import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/data/request.dart';
import 'package:prio_project/provider/personalInfosProv.dart';
import 'package:prio_project/provider/privateReqProv.dart';
import 'package:prio_project/provider/requestsProv.dart';
import 'package:prio_project/widgets/categoryBubble.dart';
import 'package:prio_project/widgets/headerMain.dart';
import 'package:prio_project/widgets/infoText.dart';
import 'package:prio_project/widgets/jobDetail.dart';
import 'package:prio_project/widgets/jobTile.dart';
import 'package:prio_project/widgets/recapModule.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<bool> _category = [true, true, true];

  final bool _isInit = false;
  final bool _isLoading = false;

  void _updateCategory(int cat) {
    setState(() {
      _category[cat] = !_category[cat];
    });
    // _currentList();
  }

  List<Request> _showList;

  Future<bool> _getCurrentRequests() async {
    await Provider.of<PersonalInfos>(context, listen: false).getPersonalData();
    await Provider.of<Requests>(context, listen: false).fetchAndSetRequests();
    await Provider.of<PersonalRequests>(context, listen: false)
        .fetchAndSetPersonalRequests();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final List<Request> _items = Provider.of<Requests>(context).items;
    return Scaffold(
      backgroundColor: white1,
      body: _isLoading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: <Widget>[
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    await _getCurrentRequests();
                  },
                ),
                SliverAppBar(
                  backgroundColor: Colors.white,
                  floating: true,
                  pinned: true,
                  flexibleSpace: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .05,
                      ),
                      HeaderMain(),
                      RecapModule(),
                    ],
                  ),
                  collapsedHeight: MediaQuery.of(context).size.height * .15,
                  expandedHeight: MediaQuery.of(context).size.height * .453,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Container(
                            color: Colors.transparent,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 14.0,
                                right: 14.0,
                                top: 24,
                                bottom: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    ' available jobs',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      letterSpacing: -.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              _updateCategory(0);
                                            },
                                            child: CategoryBubble(
                                              mode: 0,
                                              size: 40,
                                              active: _category[0],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              _updateCategory(1);
                                            },
                                            child: CategoryBubble(
                                              mode: 1,
                                              size: 40,
                                              active: _category[1],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              _updateCategory(2);
                                            },
                                            child: CategoryBubble(
                                              mode: 2,
                                              size: 40,
                                              active: _category[2],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 15,
                            right: 15,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showList = _showList.reversed.toList();
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: <BoxShadow>[basicShadow],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                ),
                                child: const Icon(
                                  CupertinoIcons.arrow_up_arrow_down,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_items.isEmpty)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 4),
                          Text(
                            'No available requests atm, sorry!',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: black1.withOpacity(.4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Icon(
                            CupertinoIcons.nosign,
                            color: black1.withOpacity(.4),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 5.0),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet<dynamic>(
                                isScrollControlled: true,
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return JobDetail(
                                    request: _items[index],
                                  );
                                },
                              );
                            },
                            child: Column(
                              children: <Widget>[
                                JobTile(
                                  request: _items[index],
                                ),
                                if (index == _items.length - 1)
                                  const SizedBox(height: 100)
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: _items.length,
                    ),
                  )
              ],
            ),
    );
  }
}
