import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class MenuService {
  static Future<List<MenuItem>> fetchMenu() async {
    // Simulasi delay seolah-olah fetch dari server
    await Future.delayed(Duration(milliseconds: 800));

    return [
      MenuItem(
        label: "Dashboard",
        icon: Icons.home_work,
        route: "/dash",
      ),
      MenuItem(
        label: "Data",
        icon: Icons.article,
        route: "/data",
      ),
      MenuItem(
        label: "Profil Wilayah",
        icon: Icons.map,
        route: "/profil",
      ),
      MenuItem(
        label: "Tentang",
        icon: Icons.info_outline,
        route: "/tentang",
      ),
    ];
  }
}
