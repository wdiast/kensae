// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/sarpras_model.dart';
// import '../models/statistik_model.dart';
// import '../models/filter_model.dart';

// class SarprasService {
//   static const String baseUrl = "http://your-api-url.com/api";

//   static Future<List<Sarpras>> fetchSarpras(FilterModel filter) async {
//     final uri = Uri.parse("$baseUrl/sarpras").replace(queryParameters: filter.toQuery());
//     final response = await http.get(uri);

//     if (response.statusCode == 200) {
//       final List data = jsonDecode(response.body);
//       return data.map((e) => Sarpras.fromJson(e)).toList();
//     } else {
//       throw Exception('Gagal memuat data sarpras');
//     }
//   }

//   static Future<List<Statistik>> fetchStatistik(FilterParam filter) async {
//     final uri = Uri.parse("$baseUrl/statistik").replace(queryParameters: filter.toQuery());
//     final response = await http.get(uri);

//     if (response.statusCode == 200) {
//       final List data = jsonDecode(response.body);
//       return data.map((e) => Statistik.fromJson(e)).toList();
//     } else {
//       throw Exception('Gagal memuat statistik');
//     }
//   }
// }
