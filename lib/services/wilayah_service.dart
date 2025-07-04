import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wilayah_model.dart';

class WilayahService {
  static Future<Map<String, List>> fetchWilayah({
    required String kodeKecamatan,
    required String kodeDesa,
    required String subjectSlug,
  }) async {
    final url =
        'https://webapps.bps.go.id/kendalkab/kensae/Dashboard_api/sarpras/$kodeKecamatan/$kodeDesa/$subjectSlug';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List<KecamatanOption> kecamatan = (data['f_data'] as List)
          .map((item) => KecamatanOption(
                id: item['iddesa'].toString(),
                nama: item['nmkec'].toString(),
              ))
          .toList();

      final List<DesaOption> desa = (data['f_data2'] as List)
          .map((item) {
            final idDesa = item['iddesa'].toString();
            return DesaOption(
              id: idDesa,
              nama: item['nmdesa'].toString(),
              idKecamatan: idDesa.substring(0, 7), // ambil 7 digit pertama
            );
          })
          .toList();

      return {'kecamatan': kecamatan, 'desa': desa};
    } else {
      throw Exception('Gagal memuat data wilayah');
    }
  }
}
