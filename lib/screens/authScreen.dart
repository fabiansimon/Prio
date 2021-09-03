import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:prio_project/authentication/authenticationService.dart';
import 'package:prio_project/data/design.dart';
import 'package:prio_project/utils/oneOptionDialog.dart';
import 'package:prio_project/widgets/buttonTemplate.dart';
import 'package:prio_project/widgets/signUpWithContainer.dart';
import 'package:prio_project/widgets/textFieldCostum.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

// ignore: constant_identifier_names
enum AuthMode { LogIn, SignUp }

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final TextEditingController _phoneNrController = TextEditingController();
  DateTime _birthdate = DateTime.now();

  AuthMode _authMode = AuthMode.LogIn;

  File _image;
  final ImagePicker picker = ImagePicker();

  bool _secondStageSignUp = false;
  bool _isLoading = false;

  // To get Image from phone
  Future<void> _getImage() async {
    final PickedFile pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 100,
        maxWidth: 100);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Auth User
  void _authUser() {
    if (_authMode == AuthMode.LogIn) {
      setState(() {
        _isLoading = true;
      });

      if (_emailController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty) {
        try {
          context
              .read<AuthenticationService>()
              .logIn(
                _emailController.text.trim(),
                _passwordController.text.trim(),
                context,
              )
              .then((_) {
            setState(() {
              _isLoading = false;
            });
          });
        } on FirebaseAuthException catch (e) {
          print(e.message + 'lol');
        }
      } else {
        showDialog<Widget>(
          context: context,
          builder: (BuildContext context) {
            return OneOptionDialog(
              title: 'Hey Wait!',
              text: 'Please fill in all fields',
              context: context,
            );
          },
        );
        setState(() {
          _isLoading = false;
        });
      }
    } else if (_authMode == AuthMode.SignUp && !_secondStageSignUp) {
      if (_emailController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty &&
          _repeatPasswordController.text.trim().isNotEmpty &&
          _passwordController.text.trim() ==
              _repeatPasswordController.text.trim()) {
        setState(() {
          _secondStageSignUp = true;
        });
      } else {
        showDialog<Widget>(
          context: context,
          builder: (BuildContext context) {
            return OneOptionDialog(
              title: 'Hey Wait!',
              text: 'Please fill in all fields',
              context: context,
            );
          },
        );
        setState(() {
          _isLoading = false;
        });
      }
    } else if (_authMode == AuthMode.SignUp && _secondStageSignUp) {
      if (_firstNameController.text.trim().isNotEmpty &&
          _lastNameController.text.trim().isNotEmpty &&
          _image != null &&
          _phoneNrController.text.trim().isNotEmpty &&
          (_birthdate.difference(DateTime.now()).inDays.abs() > 18 * 365)) {
        setState(() {
          _isLoading = true;
        });

        try {
          context
              .read<AuthenticationService>()
              .signUp(
                _emailController.text.trim(),
                _passwordController.text.trim(),
                _firstNameController.text.trim(),
                _lastNameController.text.trim(),
                context,
                _birthdate,
                _phoneNrController.text.trim(),
                _image,
              )
              .then((_) {
            setState(() {
              _isLoading = false;
            });
          });
        } catch (e) {
          print(e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white1,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(gradient: purpleGradient),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .06,
                    ),
                    const Image(
                      image: AssetImage('assets/temporaryLogo.png'),
                      color: Colors.white,
                      height: 20,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: _authMode == AuthMode.LogIn
                          ? MediaQuery.of(context).size.height * .05
                          : MediaQuery.of(context).size.height * .02,
                    ),
                    Text(
                      _authMode == AuthMode.LogIn
                          ? 'Welcome back!'
                          : 'Welcome!',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter your information to get started',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -.5,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: _authMode == AuthMode.LogIn
                          ? MediaQuery.of(context).size.height * .06
                          : MediaQuery.of(context).size.height * .03,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[basicShadow],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _secondStageSignUp
                          ? signUpExtened()
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .03,
                                ),
                                Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _authMode = AuthMode.LogIn;
                                        });
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              'Login',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    _authMode == AuthMode.LogIn
                                                        ? Colors.black
                                                        : Colors.black
                                                            .withOpacity(.3),
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: -.5,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              height: 6,
                                              width: 6,
                                              decoration: BoxDecoration(
                                                color:
                                                    _authMode == AuthMode.LogIn
                                                        ? Colors.black
                                                        : Colors.transparent,
                                                shape: BoxShape.circle,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _authMode = AuthMode.SignUp;
                                        });
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              'Sign Up',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    _authMode == AuthMode.SignUp
                                                        ? Colors.black
                                                        : Colors.black
                                                            .withOpacity(.3),
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: -.5,
                                              ),
                                            ),
                                            const SizedBox(),
                                            Container(
                                              height: 6,
                                              width: 6,
                                              decoration: BoxDecoration(
                                                color:
                                                    _authMode == AuthMode.SignUp
                                                        ? Colors.black
                                                        : Colors.transparent,
                                                shape: BoxShape.circle,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 100),
                                  height: _authMode == AuthMode.LogIn
                                      ? MediaQuery.of(context).size.height * .03
                                      : MediaQuery.of(context).size.height *
                                          .028,
                                ),
                                Column(
                                  children: <Widget>[
                                    SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            width: double.infinity,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                const SizedBox(height: 15),
                                                const Text(
                                                  'Email address',
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
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xFFEEEEEE),
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 4.0),
                                                    child: TextFieldCostum(
                                                      hintText:
                                                          'john.doe@email.com',
                                                      textEditingController:
                                                          _emailController,
                                                      autoCorrection: false,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      obscureText: false,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .none,
                                                    ),
                                                  ),
                                                ),
                                                const Divider(
                                                  height: 40,
                                                  thickness: 1,
                                                  color: Color(0xFFE6E6E6),
                                                ),
                                                const Text(
                                                  'Password',
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
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xFFEEEEEE),
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 4.0),
                                                    child: TextFieldCostum(
                                                      hintText: '********',
                                                      textEditingController:
                                                          _passwordController,
                                                      keyboardType:
                                                          TextInputType
                                                              .visiblePassword,
                                                      autoCorrection: false,
                                                      obscureText: true,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .none,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                if (_authMode ==
                                                    AuthMode.SignUp)
                                                  Column(
                                                    children: <Widget>[
                                                      const Text(
                                                        'Repeat Password',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Container(
                                                        height: 40,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: const Color(
                                                                0xFFEEEEEE),
                                                          ),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(5),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      12.0,
                                                                  vertical:
                                                                      4.0),
                                                          child:
                                                              TextFieldCostum(
                                                            hintText:
                                                                '********',
                                                            textEditingController:
                                                                _repeatPasswordController,
                                                            autoCorrection:
                                                                false,
                                                            obscureText: true,
                                                            keyboardType:
                                                                TextInputType
                                                                    .visiblePassword,
                                                            textCapitalization:
                                                                TextCapitalization
                                                                    .none,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 15),
                                                    ],
                                                  )
                                                else
                                                  const SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_authMode == AuthMode.LogIn)
                                      const Padding(
                                        padding: EdgeInsets.only(right: 28.0),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'Forgot password?',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      const SizedBox(),
                                    const SizedBox(height: 15),
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: SignUpWithContainer(
                                                  text: _authMode ==
                                                          AuthMode.LogIn
                                                      ? 'Log in with Google'
                                                      : 'Sign up with Google',
                                                  icon: 'google',
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: SignUpWithContainer(
                                                text: _authMode ==
                                                        AuthMode.LogIn
                                                    ? 'Log in with Facebook'
                                                    : 'Sign up with Facebook',
                                                icon: 'facebook',
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        SignUpWithContainer(
                                          text: _authMode == AuthMode.LogIn
                                              ? 'Log in with Apple'
                                              : 'Sign in with Apple',
                                          icon: 'apple',
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                if (_isLoading)
                                  const Center(
                                    child: CupertinoActivityIndicator(),
                                  )
                                else
                                  ButtonTemplate(
                                    height: 45,
                                    radius: 6,
                                    gradient: purpleGradient,
                                    icon: CupertinoIcons.check_mark,
                                    iconSize: 18,
                                    text: _authMode == AuthMode.LogIn
                                        ? 'Log in'
                                        : 'Sign Up',
                                    textSize: 16,
                                    function: () {
                                      _authUser();
                                    },
                                  ),
                              ],
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget signUpExtened() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    onTap: () {
                      _getImage();
                    },
                    child: Container(
                      height: 85,
                      width: 85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [basicShadow],
                        border: Border.all(width: 2, color: Colors.white),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: _image.exists()!
                              ? FileImage(_image)
                              : const AssetImage('assets/profileIcon.png'),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _getImage();
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[basicShadow],
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.pen,
                        size: 18,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    'First Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            30,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFEEEEEE),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 4.0,
                                      ),
                                      child: TextFieldCostum(
                                        hintText: 'John',
                                        textEditingController:
                                            _firstNameController,
                                        autoCorrection: false,
                                        keyboardType: TextInputType.text,
                                        obscureText: false,
                                        textCapitalization:
                                            TextCapitalization.words,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    'Last Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFEEEEEE),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 4.0,
                                      ),
                                      child: TextFieldCostum(
                                        hintText: 'Doe',
                                        keyboardType: TextInputType.text,
                                        textEditingController:
                                            _lastNameController,
                                        autoCorrection: false,
                                        obscureText: false,
                                        textCapitalization:
                                            TextCapitalization.words,
                                      ),
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
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 15),
                          const Text(
                            'Phone number',
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
                              border: Border.all(
                                color: const Color(0xFFEEEEEE),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 4.0),
                              child: TextFieldCostum(
                                hintText: '+43 664 186 53 58',
                                textEditingController: _phoneNrController,
                                autoCorrection: false,
                                obscureText: false,
                                keyboardType: TextInputType.phone,
                                textCapitalization: TextCapitalization.none,
                              ),
                            ),
                          ),
                          const Divider(
                            height: 40,
                            thickness: 1,
                            color: Color(0xFFE6E6E6),
                          ),
                          const Text(
                            'Birthdate',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              DatePicker.showDatePicker(
                                context,
                                minTime: DateTime(1930, 3, 5),
                                maxTime: DateTime.now(),
                                onChanged: (DateTime date) {
                                  setState(() {
                                    _birthdate = date;
                                  });
                                },
                                onConfirm: (DateTime date) {
                                  setState(() {
                                    _birthdate = date;
                                  });
                                },
                                currentTime: DateTime.now(),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFEEEEEE),
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    DateFormat('dd.MM.yyyy').format(_birthdate),
                                    style: const TextStyle(
                                      color: Color(0xFFC1C1C2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
          const SizedBox(height: 20),
          if (_isLoading)
            const Center(
              child: CupertinoActivityIndicator(),
            )
          else
            ButtonTemplate(
              height: 45,
              radius: 6,
              gradient: purpleGradient,
              icon: CupertinoIcons.check_mark,
              iconSize: 18,
              text: 'Next',
              textSize: 16,
              function: () {
                _authUser();
              },
            ),
          const SizedBox(height: 4),
          if (!_isLoading)
            GestureDetector(
              onTap: () {
                setState(() {
                  _secondStageSignUp = false;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 100.0, vertical: 12.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        CupertinoIcons.xmark,
                        color: subtleGrey,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Cancel',
                        style: TextStyle(
                          color: subtleGrey,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }
}
