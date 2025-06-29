import 'package:flutter/material.dart';

const TextStyle titleTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Color(0xFF003366),
);

const BoxDecoration boxDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFE9F3FB),
    ],
  ),
  borderRadius: BorderRadius.only(
  topLeft: Radius.circular(24),
  topRight: Radius.circular(24),
  ),
  border: Border(top: BorderSide(color: Color(0xFF3366CC)))
);

const TextStyle logoTextStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Color(0xFF003366),
);

const TextStyle subtitleText = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Color(0xFF003366),
);

const TextStyle subTitleTab = TextStyle(
  fontSize: 14
);