// pages/dash_page.dart (versi dengan API real-time + geojson fallback Semua Kecamatan)
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:geojson/geojson.dart';
import '../services/sarpras_service.dart';
import '../services/wilayah_service.dart';
import '../models/sarpras_model.dart';
import '../models/wilayah_model.dart';

class DashPage extends StatefulWidget {
  const DashPage({super.key});

  @override
  State<DashPage> createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  List<KecamatanOption> kecamatanList = [];
  List<DesaOption> desaList = [];
  List<SarprasMarker> sarprasList = [];
  Map<String, int> statistik = {};
  List<LatLng> geoJsonPolygon = [];
  List<DesaOption> filteredDesaList = [];

  final KecamatanOption semuaKecamatan = KecamatanOption(
    id: '3324',
    nama: 'Semua Kecamatan',
  );
  final DesaOption semuaDesa = DesaOption(
    id: '3324',
    nama: 'Semua Desa',
    idKecamatan: '3324',
  );

  KecamatanOption selectedKecamatan = KecamatanOption(
    id: '3324',
    nama: 'Semua Kecamatan',
  );
  DesaOption selectedDesa = DesaOption(
    id: '3324',
    nama: 'Semua Desa',
    idKecamatan: '3324',
  );
  String selectedSubject = 'Pendidikan';

  final Map<String, String> subjectSlug = {
    'Pendidikan': 'sarp-pendidikan',
    'Tempat Ibadah': 'sarp-ibadah',
    'Kesehatan': 'sarp-kesehatan',
    'Pasar': 'sarp-pasar',
    'SPBU': 'sarp-spbu',
    'Alfamart dan Indomaret': 'sarp-minimarket',
    'Perbankan': 'sarp-perbankan',
    'Pemerintahan': 'sarp-pemerintahan',
    'Hotel': 'sarp-hotel',
    'ATM': 'sarp-atm',
    'Tempat Wisata': 'sarp-wisata',
  };

  @override
  void initState() {
    super.initState();
    fetchWilayah();
  }

  final Map<String, Color> kategoriWarna = {};

  Color getColorByKategori(String kategori) {
    final key = kategori.toUpperCase();

    // Cek apakah kategori sudah punya warna
    if (kategoriWarna.containsKey(key)) {
      return kategoriWarna[key]!;
    }

    // Kalau belum, ambil dari warna default
    final defaultColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.brown,
      Colors.cyan,
      Colors.indigo,
      Colors.pink,
      Colors.lime,
    ];

    final nextColor =
        defaultColors[kategoriWarna.length % defaultColors.length];
    kategoriWarna[key] = nextColor;
    return nextColor;
  }

  Future<void> fetchWilayah() async {
    final data = await WilayahService.fetchWilayah(
      kodeKecamatan: '3324',
      kodeDesa: '3324',
      subjectSlug: subjectSlug[selectedSubject]!,
    );
    setState(() {
      kecamatanList = [
        semuaKecamatan,
        ...data['kecamatan']!.cast<KecamatanOption>(),
      ];
      desaList = [semuaDesa, ...data['desa']!.cast<DesaOption>()];
      selectedKecamatan = semuaKecamatan;
      selectedDesa = semuaDesa;
    });
    debugPrint(
      '✅ Kecamatan: ${data['kecamatan']!.length}, Desa: ${data['desa']!.length}',
    );
    fetchSarpras();
    loadGeoJson();
  }

  Future<void> fetchSarpras() async {
    final result = await SarprasService.fetchSarpras(
      kodeDesa: selectedDesa.id,
      subjectSlug: subjectSlug[selectedSubject]!,
    );
    setState(() {
      sarprasList = result['markers'];
      statistik = {};
      for (final item in result['statistik']) {
        statistik[item.label] = int.tryParse(item.jumlah) ?? 0;
      }
      debugPrint(
        '✅ Sarpras berhasil dimuat: ${result['markers'].length} titik',
      );
    });
  }

  Future<void> loadGeoJson() async {
    final filename =
        (selectedKecamatan.id == '3324' && selectedDesa.id == '3324')
        ? 'assets/map/3324_kec.geojson'
        : (selectedDesa.id != '3324'
              ? 'assets/map/${selectedDesa}_sls.geojson'
              : 'assets/map/${selectedKecamatan}_desa.geojson');
    try {
      final geoStr = await rootBundle.loadString(filename);
      final geojson = GeoJson();
      geoJsonPolygon.clear();
      await geojson.parse(geoStr);
      for (final feature in geojson.features) {
        if (feature.type == GeoJsonFeatureType.polygon) {
          final polygon = feature.geometry as GeoJsonPolygon;
          geoJsonPolygon.addAll(polygon.geoSeries.first.toLatLng());
        }
      }
    } catch (e) {
      geoJsonPolygon = [];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peta Sarpras')),
      body: Column(
        children: [
          Container(
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: buildDropdown2<KecamatanOption>(
                        'Kecamatan',
                        kecamatanList,
                        selectedKecamatan,
                        (val) {
                          setState(() {
                            selectedKecamatan = val;
                            selectedDesa = desaList.firstWhere(
                              (d) => d.id.startsWith(val.id),
                              orElse: () => semuaDesa,
                            );
                          });
                          fetchSarpras();
                          loadGeoJson();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: buildDropdown2<DesaOption>(
                        'Desa',
                        desaList,
                        selectedDesa,
                        (val) {
                          setState(() => selectedDesa = val);
                          fetchSarpras();
                          loadGeoJson();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                buildDropdown2<String>(
                  'Subject',
                  subjectSlug.keys.toList(),
                  selectedSubject,
                  (val) {
                    setState(() => selectedSubject = val);
                    fetchSarpras();
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: statistik.entries.map((e) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          e.key,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${e.value}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(center: LatLng(-7.05, 110.2), zoom: 10.5),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                if (geoJsonPolygon.isNotEmpty)
                  PolygonLayer(
                    polygons: [
                      Polygon(
                        points: geoJsonPolygon,
                        color: Colors.blue.withOpacity(0.2),
                        borderStrokeWidth: 2,
                        borderColor: Colors.blue,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: sarprasList.map((s) {
                    final color = getColorByKategori(
                      s.kategori,
                    ); // Ambil warna sesuai kategori
                    return Marker(
                      width: 30,
                      height: 30,
                      point: s.posisi,
                      builder: (_) => Icon(Icons.location_on, color: color),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFF0148A4),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/');
          if (index == 1) {}
          if (index == 2) Navigator.pushNamed(context, '/tentang');
          if (index == 3) Navigator.pushNamed(context, '/data');
          if (index == 4) Navigator.pushNamed(context, '/profil');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.my_location), label: 'Dash'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Tentang'),
          BottomNavigationBarItem(icon: Icon(Icons.data_array), label: 'Data'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget buildDropdown2<T>(
    String label,
    List<T> items,
    T selected,
    Function(T) onChanged,
  ) {
    return DropdownButtonFormField2<T>(
      isExpanded: true,
      value: selected,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
      onChanged: (val) {
        if (val != null) onChanged(val);
      },
      items: items.map((e) {
        String labelText;
        if (e is KecamatanOption) {
          labelText = e.nama;
        } else if (e is DesaOption) {
          labelText = e.nama;
        } else {
          labelText = e.toString();
        }
        return DropdownMenuItem<T>(value: e, child: Text(labelText));
      }).toList(),
      buttonStyleData: const ButtonStyleData(height: 48),
    );
  }
}
