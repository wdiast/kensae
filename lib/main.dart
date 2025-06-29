import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/dash_page.dart';
import 'pages/tentang_page.dart';
import 'pages/data_page.dart';
import 'pages/profil_page.dart';
import 'pages/subData_page.dart';

void main() {
  runApp(KenSaeApp());
}

class KenSaeApp extends StatelessWidget {
  const KenSaeApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KenSAE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFE9F3FB),
        fontFamily: 'Roboto', // optional: bisa diganti sesuai branding
      ),
      home: HomePage(),
      routes: {
        '/dash': (context) => DashPage(),
        '/tentang': (context) => TentangPage(),
        '/data': (context) => DataPage(),
        '/profil': (context) => ProfilPage(),
        '/subdata': (context) => const SubDataPage(),
      },
    );
  }
}
