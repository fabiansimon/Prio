import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color white1 = const Color(0xFFF2F2F4);

Color purple1 = const Color(0xFFA15BFF);
Color purple2 = const Color(0xFF6E2BFF);

Color green1 = const Color(0xFF25E495);
Color green2 = const Color(0xFF0C8250);

Color pink1 = const Color(0xFFD020C3);
Color pink2 = const Color(0xFF90109D);

Color red1 = const Color(0xFFC72F2F);
Color red2 = const Color(0xFFEC3030);

Color black1 = const Color(0xFF0F1010);
Color black2 = const Color(0xFF131415);

Color subtleGrey = const Color(0xFFC5C5C5);

Color chatInfoColor = const Color(0xFF979797);

BoxShadow basicShadow = BoxShadow(
    color: Colors.black.withOpacity(.03), blurRadius: 10, spreadRadius: 10);

List<LinearGradient> gradientArray = <LinearGradient>[
  purpleGradient,
  greenGradient,
  pinkGradient
];

List<IconData> iconsArray = <IconData>[
  CupertinoIcons.person_fill,
  CupertinoIcons.bag_fill,
  CupertinoIcons.cart_fill
];

LinearGradient purpleGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[
    purple1,
    purple2,
  ],
);

LinearGradient greenGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[
    green1,
    green2,
  ],
);

LinearGradient pinkGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[
    pink1,
    pink2,
  ],
);

LinearGradient redGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[
    red1,
    red2,
  ],
);

LinearGradient blackGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[
    black1,
    black2,
  ],
);
