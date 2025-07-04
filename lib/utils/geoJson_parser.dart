// utils/geojson_parser.dart
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class GeoJsonParser {
  static Future<List<Polygon>> parsePolygonsFromAsset(String assetPath) async {
    final geoStr = await rootBundle.loadString(assetPath);
    final geoJson = json.decode(geoStr);

    final features = geoJson['features'] as List;
    List<Polygon> polygons = [];

    for (var feature in features) {
      final geometry = feature['geometry'];
      final type = geometry['type'];
      final coordinates = geometry['coordinates'];

      if (type == 'Polygon') {
        List<LatLng> points = [];
        for (var ring in coordinates) {
          for (var coord in ring) {
            points.add(LatLng(coord[1], coord[0]));
          }
        }
        polygons.add(Polygon(points: points, color: const Color(0x220000FF)));
      } else if (type == 'MultiPolygon') {
        for (var polygon in coordinates) {
          List<LatLng> points = [];
          for (var ring in polygon) {
            for (var coord in ring) {
              points.add(LatLng(coord[1], coord[0]));
            }
          }
          polygons.add(Polygon(points: points, color: const Color(0x220000FF)));
        }
      }
    }

    return polygons;
  }
}
