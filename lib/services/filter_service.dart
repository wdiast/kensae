import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/filter_model.dart';

class FilterService {
  static Future<FilterParam> fetchFilter(String slug, String fTabel, String fKec, String fTahun) async {
    const String baseUrl = 'https://webapps.bps.go.id/kendalkab/kensae/Data_api'; 
    final url = Uri.parse('$baseUrl/$slug/$fTabel/$fKec/$fTahun');

    print('[DEBUG] Fetching URL: $url'); // ✅ DEBUG LINE
    
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      return FilterParam.fromJson(jsonDecode(response.body));
    } else {
      print('[ERROR] Status code: ${response.statusCode}'); // optional debug
      throw Exception('Failed to fetch data');
    }
  }
}

