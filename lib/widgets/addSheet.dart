import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/data/request.dart';
import 'package:prio_project/data/user.dart';
import 'package:prio_project/provider/privateReqProv.dart';
import 'package:prio_project/provider/requestsProv.dart';
import 'package:prio_project/utils/mapUtils.dart';
import 'package:prio_project/utils/oneOptionDialog.dart';
import 'package:prio_project/widgets/buttonTemplate.dart';
import 'package:prio_project/widgets/categoryBubble.dart';
import 'package:prio_project/widgets/closeButtonCostum.dart';
import 'package:prio_project/widgets/textFieldCostum.dart';
import 'package:provider/provider.dart';

class AddSheet extends StatefulWidget {
  @override
  _AddSheetState createState() => _AddSheetState();
}

class _AddSheetState extends State<AddSheet> {
  final TextEditingController _requestTitleController = TextEditingController();
  final TextEditingController _requestDescriptionController =
      TextEditingController();
  final TextEditingController _timerController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  LatLng _latLngRequest;

  final List<bool> _category = [false, false, false];

  bool _isLoading = false;

  void _updateCategory(int cat) {
    if (_category[0] && cat > 0 ||
        _category[1] && cat == 0 ||
        _category[2] && cat == 0) {
      showDialog<Widget>(
        context: context,
        builder: (BuildContext context) {
          return OneOptionDialog(
            title: 'Sorry',
            text: "You can't mix a service with a new or used product.",
            context: context,
          );
        },
      );
    } else {
      setState(() {
        _category[cat] = !_category[cat];
      });
    }
  }

  void _postRequest() {
    setState(() {
      _isLoading = true;
    });

    if (_requestTitleController.text.trim().isNotEmpty &&
        _requestDescriptionController.text.trim().isNotEmpty &&
        _timerController.text.trim().isNotEmpty &&
        _latLngRequest != null) {
      Provider.of<Requests>(context, listen: false)
          .addRequest(
        Request(
          creatorId: mainUser.id,
          title: _requestTitleController.text,
          description: _requestDescriptionController.text.trim(),
          finishDateTime: DateTime.now()
              .add(Duration(hours: int.parse(_timerController.text))),
          deliveryFee: 10,
          fulfillerId: '',
          latLng: _latLngRequest,
          requestId: '12345',
          category: _category,
        ),
      )
          .then((_) {
        Provider.of<PersonalRequests>(context, listen: false)
            .fetchAndSetPersonalRequests()
            .then((_) {
          setState(() {
            _isLoading = false;
          });
          _requestTitleController.text = '';
          _requestDescriptionController.text = '';
          _timerController.text = '';
          _locationController.text = '1';

          Navigator.pop(context);
        });
      });
    } else {
      print('Missing Informaiton');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: white1,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
        ),
        height: MediaQuery.of(context).size.height * .9,
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: blackGradient,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CloseButtonCostum(
                      context: context,
                    ),
                    const Text(
                      'Post request',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .9 - 50,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[basicShadow],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            const Text(
                              'What do you need',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: white1,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 4.0),
                                child: TextFieldCostum(
                                  hintText: 'Your title for the request',
                                  textEditingController:
                                      _requestTitleController,
                                  autoCorrection: true,
                                  obscureText: false,
                                  textCapitalization: TextCapitalization.words,
                                ),
                              ),
                            ),
                            const Divider(
                              height: 40,
                              thickness: 1,
                              color: Color(0xFFE6E6E6),
                            ),
                            const Text(
                              'Descripe your request',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 80,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: white1,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: TextFieldCostum(
                                  hintText:
                                      // ignore: lines_longer_than_80_chars
                                      'Describe it in as much detail as you can so we can',
                                  textEditingController:
                                      _requestDescriptionController,
                                  autoCorrection: true,
                                  obscureText: false,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[basicShadow],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: IntrinsicHeight(
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                flex: 3,
                                child: Column(
                                  children: <Widget>[
                                    const SizedBox(height: 15),
                                    const Text(
                                      'What category',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
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
                                            const SizedBox(height: 4),
                                            const Text(
                                              'Service',
                                              style: TextStyle(
                                                color: Color(0xFFC1C1C2),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
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
                                            const SizedBox(height: 4),
                                            const Text(
                                              'Purchase',
                                              style: TextStyle(
                                                color: Color(0xFFC1C1C2),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
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
                                            const SizedBox(height: 4),
                                            const Text(
                                              'Used',
                                              style: TextStyle(
                                                color: Color(0xFFC1C1C2),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),
                              const VerticalDivider(
                                width: 60,
                                endIndent: 20,
                                indent: 20,
                                thickness: 1,
                                color: Color(0xFFE6E6E6),
                              ),
                              Flexible(
                                flex: 2,
                                child: Column(
                                  children: <Widget>[
                                    const SizedBox(height: 15),
                                    const Text(
                                      'How urgent is it',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: 40,
                                          width: 75,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: red1),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              cursorColor: red1,
                                              controller: _timerController,
                                              style: TextStyle(color: red1),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: '24h',
                                                hintStyle: TextStyle(
                                                  color: red1.withOpacity(.3),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'in hours',
                                          style: TextStyle(
                                            color: Color(0xFFC1C1C2),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[basicShadow],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 15),
                            const Text(
                              'Your location',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: white1,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 4.0),
                                      child: TextFieldCostum(
                                        hintText: 'Approx. Delivery Adresse',
                                        textEditingController:
                                            _locationController,
                                        autoCorrection: false,
                                        obscureText: false,
                                        textCapitalization:
                                            TextCapitalization.words,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    MapUtils.getCurrentLocation()
                                        .then((LatLng latlng) {
                                      MapUtils.getAddress(latlng)
                                          .then((Address address) {
                                        _latLngRequest = latlng;
                                        _locationController.text =
                                            address.featureName.toString();
                                      });
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      gradient: purpleGradient,
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.location,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: _isLoading
                          ? const CupertinoActivityIndicator()
                          : ButtonTemplate(
                              height: 45,
                              radius: 5,
                              gradient: purpleGradient,
                              icon: CupertinoIcons.hand_thumbsup_fill,
                              iconSize: 17,
                              text: 'Post request',
                              textSize: 14,
                              function: () {
                                _postRequest();
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
