import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:kensae/stylesKen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String selectedWilayah = 'Kecamatan';
  final Color primaryColor = const Color(0xFF0148A4);

  final List<String> wilayahOptions = ['Kecamatan', 'Desa'];

  final Map<String, List<Map<String, String>>> publikasiData = {
    'Kecamatan': [
      {
        'image': 'assets/img/kecamatan/kecweleri.png',
        'title': 'Kecamatan Weleri Dalam Angka 2024',
        'pdf': 'assets/pdf/kecamatan-weleri-dalam-angka-2024.pdf',
      },
      {
        'image': 'assets/img/kecamatan/keckendal.png',
        'title': 'Kecamatan Kendal Dalam Angka 2024',
        'pdf': 'assets/pdf/kecamatan-kota-kendal-dalam-angka-2024.pdf',
      },
    ],
    'Desa': [
      {
        'image': 'assets/img/desa/podes2024.png',
        'title': 'Statistik Potensi Desa Kabupaten Kendal 2024',
        'pdf': 'assets/pdf/statistik-potensi-desa-kabupaten-kendal-2024.pdf',
      },
    ],
  };

  Future<void> openPDF(String assetPath) async {
    final bytes = await rootBundle.load(assetPath);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${assetPath.split('/').last}');
    await file.writeAsBytes(bytes.buffer.asUint8List());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PDFView(
          filePath: file.path,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataList = publikasiData[selectedWilayah] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFCFE9FD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const SizedBox(height: 20),
                  const Text('Profil Wilayah',style: titleTextStyle),
                ],
              ),
            ),
            Expanded(
              child: Container(
                // margin: EdgeInsets.only(top: 30),
                width: double.infinity,
                decoration: boxDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20,left: 16, right: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          value: selectedWilayah,
                          items: wilayahOptions.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedWilayah = value!;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 48,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blueGrey),
                              color: const Color(0xFFFFF3CD),
                            ),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xFFFFF3CD),
                            ),
                            offset: const Offset(0, 0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.builder(
                        itemCount: dataList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.6,
                        ),
                        itemBuilder: (context, index) {
                          final item = dataList[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      item['image']!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['title']!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => openPDF(item['pdf']!),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      ),
                                      child: const Text('Baca',
                                        style: TextStyle(fontSize: 12,color: Colors.white)),
                                    ),
                                    ElevatedButton(
                                      onPressed: null, // Tambahkan fungsi download nanti
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      ),
                                      child: const Text('Download',
                                        style: TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(thickness: 1, color: Colors.black12),
                  ],
                ),
              ),
            ),  
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: 4,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/dash');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/tentang');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/data');
          } else if (index == 4) {
            // Stay on Profil
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.my_location), label: 'Dash'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Tentang'),
          BottomNavigationBarItem(icon: Icon(Icons.data_array), label: 'Data'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Profil'),
        ],
      ),
    );
  }
}
