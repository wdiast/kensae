import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:geojson/geojson.dart';

class DashPage extends StatefulWidget {
  const DashPage({super.key});

  @override
  State<DashPage> createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  List<String> kecamatanList = ['Semua', 'Kendal', 'Brangsong']; // contoh
  List<String> desaList = ['Semua', 'Desa A', 'Desa B'];
  List<String> subjectList = [
    'Pendidikan',
    'Tempat Ibadah',
    'Kesehatan',
    'Pasar',
    'SPBU',
    'Alfamart',
    'Indomart',
    'Perbankan',
    'Pemerintahan',
    'Hotel',
    'ATM',
    'Tempat Wisata'
  ];

  String selectedKecamatan = 'Semua';
  String selectedDesa = 'Semua';
  String selectedSubject = 'Pendidikan';

  List<LatLng> geoJsonPolygon = [];
  List<Map<String, dynamic>> sarprasList = [];
  Map<String, int> statistik = {};

  @override
  void initState() {
    super.initState();
    loadGeoJsonForKecamatan(selectedKecamatan);
    loadMockData();
  }

  Future<void> loadGeoJsonForKecamatan(String kecamatan) async {
    geoJsonPolygon.clear();

    if (kecamatan == 'Semua') {
      setState(() {}); // kosongkan tampilan poligon
      return;
    }

    final filePath = 'assets/map/kecamatan_${kecamatan.toLowerCase()}.geojson';
    try {
      final geojsonStr = await rootBundle.loadString(filePath);
      final geojson = GeoJson();
      await geojson.parse(geojsonStr);

      for (final feature in geojson.features) {
        if (feature.type == GeoJsonFeatureType.polygon) {
          final polygon = feature.geometry as GeoJsonPolygon;
          final coords = polygon.geoSeries.first.toLatLng();
          geoJsonPolygon.addAll(coords);
        }
      }
    } catch (e) {
      debugPrint("GeoJSON load error: $e");
    }

    setState(() {});
  }

  Future<void> loadMockData() async {
    sarprasList = [
      {
        'id': 1,
        'nama': 'SDN 01',
        'jenis': 'SD',
        'subject': 'Pendidikan',
        'kecamatan': 'Kendal',
        'desa': 'Desa A',
        'lat': -6.922,
        'lng': 110.203,
      },
      {
        'id': 2,
        'nama': 'SMPN 01',
        'jenis': 'SMP',
        'subject': 'Pendidikan',
        'kecamatan': 'Kendal',
        'desa': 'Desa A',
        'lat': -6.925,
        'lng': 110.208,
      },
      {
        'id': 3,
        'nama': 'SMAN 01',
        'jenis': 'SMA',
        'subject': 'Pendidikan',
        'kecamatan': 'Kendal',
        'desa': 'Desa B',
        'lat': -6.928,
        'lng': 110.213,
      },
    ];
    updateStatistik();
  }

  void updateStatistik() {
    final filtered = sarprasList.where((e) =>
        (selectedKecamatan == 'Semua' || e['kecamatan'] == selectedKecamatan) &&
        (selectedDesa == 'Semua' || e['desa'] == selectedDesa) &&
        (e['subject'] == selectedSubject)).toList();

    final stat = <String, int>{};
    for (final item in filtered) {
      final jenis = item['jenis'];
      stat[jenis] = (stat[jenis] ?? 0) + 1;
    }

    setState(() {
      statistik = stat;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredMarkers = sarprasList.where((e) =>
        (selectedKecamatan == 'Semua' || e['kecamatan'] == selectedKecamatan) &&
        (selectedDesa == 'Semua' || e['desa'] == selectedDesa) &&
        (e['subject'] == selectedSubject)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Sarpras'),
        backgroundColor: const Color(0xFF0148A4),
      ),
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
                      child: buildDropdown2('Kecamatan', kecamatanList, selectedKecamatan, (v) {
                        setState(() {
                          selectedKecamatan = v;
                          selectedDesa = 'Semua';
                        });
                        updateStatistik();
                        loadGeoJsonForKecamatan(v);
                      }),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: buildDropdown2('Desa', desaList, selectedDesa, (v) {
                        setState(() => selectedDesa = v);
                        updateStatistik();
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: buildDropdown2('Subject', subjectList, selectedSubject, (v) {
                        setState(() => selectedSubject = v);
                        updateStatistik();
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: statistik.entries.map((e) {
                return Expanded(
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.home, size: 25),
                      title: Text('Jumlah ${e.key}', style: const TextStyle(fontSize: 10)),
                      subtitle: Text('${e.value}'),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Lokasi ${selectedSubject} di Kecamatan ${selectedKecamatan == 'Semua' ? 'Seluruh Wilayah' : selectedKecamatan}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(-6.922, 110.203),
                zoom: 10.5,
              ),
              children: [
                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                if (geoJsonPolygon.isNotEmpty)
                  PolygonLayer(
                    polygons: [
                      Polygon(
                        points: geoJsonPolygon,
                        color: Colors.blue.withOpacity(0.2),
                        borderStrokeWidth: 2,
                        borderColor: Colors.blue,
                      )
                    ],
                  ),
                MarkerLayer(
                  markers: filteredMarkers.map((s) {
                    return Marker(
                      width: 30,
                      height: 30,
                      point: LatLng(s['lat'], s['lng']),
                      builder: (_) => const Icon(Icons.location_on, color: Colors.red),
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
          if (index == 1) {} // stay
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

  Widget buildDropdown2(String label, List<String> items, String selected, Function(String) onChanged) {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      value: selected,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
      onChanged: (val) {
        if (val != null) {
          onChanged(val);
        }
      },
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      buttonStyleData: const ButtonStyleData(height: 48),
    );
  }
}
