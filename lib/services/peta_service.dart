// import 'dart:convert';
// import 'package:flutter/services.dart';
// import '../models/peta_model.dart';

// class PetaService {
//   Future<PetaModel?> loadPetaGeoJson() async {
//     try {
//       final String data = await rootBundle.loadString('assets/map/3324_sls.geojson');
//       final jsonData = json.decode(data);
//       return PetaModel.fromJson(jsonData);
//     } catch (e) {
//       print('Gagal memuat GeoJSON: $e');
//       return null;
//     }
//   }
// }