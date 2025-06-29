import 'dart:convert';
import 'package:http/http.dart' as http;

class VDataService {
  static Future<List<Map<String, dynamic>>> fetchVData({
    required String slug,
    required String tableId,
    required String kecamatanId,
    required String tahun,
  }) async {
    final url = Uri.parse(
        'https://webapps.bps.go.id/kendalkab/kensae/Data_api/$slug/$tableId/$kecamatanId/$tahun');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return List<Map<String, dynamic>>.from(jsonData['v_data']);
    } else {
      throw Exception('Gagal memuat data tabel');
    }
  }
}
