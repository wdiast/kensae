import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/sarpras_model.dart';
import 'package:latlong2/latlong.dart';

class SarprasService {
  static Future<Map<String, dynamic>> fetchSarpras({
    required String kodeKecamatan,
    required String kodeDesa,
    required String subjectSlug,
  }) async {
    // final kodeKecamatan = kodeDesa.length >= 7 ? kodeDesa.substring(0, 7) : kodeDesa;

    final url =
        'https://webapps.bps.go.id/kendalkab/kensae/Dashboard_api/sarpras/$kodeKecamatan/$kodeDesa/$subjectSlug';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final petaTitik = data['peta_titik'] ?? '';
      final kategoriStr = data['kat_titik'] ?? '';
      final popupStr = data['popup_titik'] ?? '';

      final List<LatLng> koordinatList = _parseKoordinat(petaTitik);
      final kategoriList = kategoriStr.split('|');
      final popupList = popupStr.split('|');

      final markers = <SarprasMarker>[];
      for (int i = 0; i < koordinatList.length; i++) {
        markers.add(
          SarprasMarker(
            posisi: koordinatList[i],
            kategori: i < kategoriList.length ? kategoriList[i].trim() : '-',
            popup: i < popupList.length ? popupList[i].trim() : '',
          ),
        );
        // print("titik lokasi : $koordinatList");
      }

      final boxCount = int.tryParse(data['box_var'].toString()) ?? 0;
      final statistik = <StatistikBox>[];
      for (int i = 1; i <= boxCount; i++) {
        final label = (data['box_nama$i'] ?? '').toString().replaceAll('<br>', ' ');
        final jumlah = (data['box_data$i'] ?? '0').toString();
        statistik.add(StatistikBox(label: label, jumlah: jumlah));
      }

      return {'markers': markers, 'statistik': statistik};
    } else {
      throw Exception('Gagal memuat data sarpras');
    }
  }

  // 🔹 Fungsi bantu untuk parsing string koordinat jadi List<LatLng>
  static List<LatLng> _parseKoordinat(String titikStr) {
    final titikList = titikStr.split('|');
    return titikList.map((titik) {
      final cleaned = titik.replaceAll('[', '').replaceAll(']', '').trim();
      final parts = cleaned.split(',');
      if (parts.length != 2) return LatLng(0, 0);
      final lat = double.tryParse(parts[0].trim()) ?? 0.0;
      final lng = double.tryParse(parts[1].trim()) ?? 0.0;
      return LatLng(lat, lng);
    }).toList();
  }
}
