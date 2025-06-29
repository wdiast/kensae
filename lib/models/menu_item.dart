import 'package:flutter/material.dart';

class MenuItem {
  final String label;
  final IconData icon;
  final String route;

  MenuItem({
    required this.label,
    required this.icon,
    required this.route,
  });

  // untuk membuat MenuItem dari JSON (dari API atau file JSON)
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      label: json['label'],
      route: json['route'],
      icon: _getIconFromName(json['icon']),
    );
  }

  // Fungsi konversi nama ikon (String dari JSON) ke IconData Flutter
  static IconData _getIconFromName(String name) {
    switch (name) {
      case 'dashboard':
        return Icons.dashboard;
      case 'info_outline':
        return Icons.info_outline;
      case 'table_chart':
        return Icons.table_chart;
      case 'map':
        return Icons.map;
      case 'article':
        return Icons.article;
      case 'home_work':
        return Icons.home_work;
      case 'people':
        return Icons.people;
      default:
        return Icons.help_outline;
    }
  }
}
