// SubDataPage.dart (FIXED FILTERING + DATA DISPLAY)
import 'package:flutter/material.dart';
import 'package:kensae/stylesKen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../utils/excel_export.dart';
import '../utils/subdata_source.dart';
import '../models/filter_model.dart';
import '../services/filter_service.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SubDataPage extends StatefulWidget {
  const SubDataPage({super.key});

  @override
  State<SubDataPage> createState() => _SubDataPageState();
}

class _SubDataPageState extends State<SubDataPage> {
  double tableFontSize = 14.0; // Ukuran font default
  String title = '';
  String slug = '';
  String defaultFTable = '';
  FilterParam? filterParam;

  String? selectedTable;
  String? selectedKecamatan;
  String? selectedTahun;

  bool isLoading = true;
  int currentIndex = 3;

  List<String> tahunList = List.generate(3, (i) => (2022 + i).toString());
  List<Map<String, dynamic>> currentDataList = [];

  // hitung kolom dan padding
  double getCalculatedTableWidth(int columnCount) {
    const double baseColumnWidth = 120;
    const double padding = 32;
    return (columnCount * baseColumnWidth) + padding;
  }  

  //Konversi
  String buildJsonKey(String kolom, String subkolom) {
    return (kolom + '_' + subkolom).toLowerCase().replaceAll(' ', '');
  }

  List<String> getMainHeaders() {
    final tabel = filterParam?.fTtabel.firstWhere(
      (e) => e.id == selectedTable,
      orElse: () =>
          TabelOption(id: '', nama: '', dataKolom: '', dataSubKolom: ''),
    );

    if (tabel == null) return [];

    // Jika dataSubKolom tidak kosong, pake ini trus split
    if (tabel.dataSubKolom.trim().isNotEmpty) {
      return tabel.dataSubKolom.split('|').map((e) => e.trim()).toList();
    }

    // Jika dataKolom ada '|', berarti juga perlu di-split
    if (tabel.dataKolom.contains('|')) {
      return tabel.dataKolom.split('|').map((e) => e.trim()).toList();
    }

    // Kalau tidak ada split, maka hanya satu kolom
    return [tabel.dataKolom.trim()];
  }

  String getSelectedTableTitle() {
    final tabel = filterParam!.fTtabel.firstWhere((e) => e.id == selectedTable);
    return tabel.nama;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    title = args['title'];
    slug = args['slug'];
    defaultFTable = args['def'];
    selectedTahun ??= '2024';
    selectedKecamatan ??= '3324';
    selectedTable ??= defaultFTable;
    fetchUpdatedData();
  }

  Future<void> fetchUpdatedData() async {
    if (selectedTable == null ||
        selectedKecamatan == null ||
        selectedTahun == null)
      return;
    setState(() => isLoading = true);
    try {
      final data = await FilterService.fetchFilter(
        slug,
        selectedTable!,
        selectedKecamatan!,
        selectedTahun!,
      );

      setState(() {
        filterParam = data;
        currentDataList = _buildDataList(
          data.vData,
          _getFilteredWilayah(
            data.fTkec,
            data.vDesa,
          ), // TIDAK PERLU di-mapping ulang di sini
        );
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui data: $e')));
    }
  }

  List<Wilayah> _getFilteredWilayah(
    List<WilayahOption> listKecamatan,
    List<Wilayah> listDesa,
  ) {
    if (selectedKecamatan == null || selectedKecamatan == '3324') {
      return listKecamatan
          .map((e) => Wilayah(id: e.iddesa, nama: e.nmKec)) // nama kecamatan
          .toList();
    }

    return listDesa
        .where((desa) => desa.id.startsWith(selectedKecamatan!))
        .toList(); 
  }

  List<Map<String, dynamic>> _buildDataList(
    Map<String, dynamic> vData,
    List<Wilayah> wilayahList,
  ) {
    final tabel = filterParam!.fTtabel.firstWhere((e) => e.id == selectedTable);
    final headers = getMainHeaders();
    final baseKolom = tabel.dataKolom;
    final bool isUsingSubKolom = tabel.dataSubKolom.trim().isNotEmpty;
    final bool isKecamatanMode =
        selectedKecamatan == null || selectedKecamatan == '3324';

    print('[DEBUG] headers: $headers');
    print('[DEBUG] data_kolom: $baseKolom');
    print('[DEBUG] data_subkolom: ${tabel.dataSubKolom}');

    List<Map<String, dynamic>> result = [];

    for (var wilayah in wilayahList) {
      final key = wilayah.id;
      final data = vData[key];

      if (data != null && data is Map<String, dynamic>) {
        final row = <String, dynamic>{
          isKecamatanMode ? 'nama_kecamatan' : 'nama_desa': wilayah.nama,
        };

        for (var h in headers) {
          final jsonKey = isUsingSubKolom
              ? buildJsonKey(baseKolom, h) // statusdaerah_kota
              : h.toLowerCase().replaceAll(' ', ''); // misal: dataran

          final value = data[jsonKey] ?? '0';

          final outputKey = isUsingSubKolom
              ? h.toLowerCase().replaceAll(' ', '_') // simpan dengan snake_case
              : h; // simpan nama asli jika dari data_kolom

          row[outputKey] = value;

          print('[DEBUG] key=$jsonKey, value=$value, outputKey=$outputKey');
        }

        result.add(row);
      } else {
        print('[DEBUG] Data kosong untuk wilayah id: $key');
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final isKecamatanMode =
        selectedKecamatan == null || selectedKecamatan == '3324';
    final mainHeaders = getMainHeaders();
    final totalColumns = 1 + mainHeaders.length;
    final calculatedWidth = getCalculatedTableWidth(totalColumns);

    return Scaffold(
      backgroundColor: const Color(0xFFE9F3FB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul halaman tetap di luar container putih
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                ),
              ),
            ),

            // container putih
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // Dropdown Filter 1
                    DropdownButton2<String>(
                      value: selectedTable,
                      isExpanded: true,
                      items: filterParam?.fTtabel
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.nama, style: subTitleTab),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() => selectedTable = val);
                        fetchUpdatedData();
                      },
                    ),
                    const SizedBox(height: 12),

                    // Dropdown Kecamatan & Tahun
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton2<String>(
                            value: selectedKecamatan,
                            isExpanded: true,
                            items: [
                              const DropdownMenuItem(
                                value: '3324',
                                child: Text(
                                  'Semua Kecamatan',
                                  style: subTitleTab,
                                ),
                              ),
                              ...?filterParam?.fTkec.map(
                                (e) => DropdownMenuItem(
                                  value: e.iddesa,
                                  child: Text(e.nmKec, style: subTitleTab),
                                ),
                              ),
                            ],
                            onChanged: (val) {
                              setState(() => selectedKecamatan = val);
                              fetchUpdatedData();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButton2<String>(
                            value: selectedTahun,
                            isExpanded: true,
                            items: tahunList
                                .map(
                                  (tahun) => DropdownMenuItem(
                                    value: tahun,
                                    child: Text(tahun, style: subTitleTab),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() => selectedTahun = val);
                              fetchUpdatedData();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    //  tombol ukuran tabel dan export
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (tableFontSize > 10) tableFontSize--;
                                });
                              },
                            ),
                            Text('${tableFontSize.toInt()} pt'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  if (tableFontSize < 24) tableFontSize++;
                                });
                              },
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.download),
                          label: const Text('Export Excel'),
                          onPressed: () {
                            final headers = [
                              isKecamatanMode ? 'Nama Kecamatan' : 'Nama Desa',
                              ...getMainHeaders(),
                            ];
                            final rows = currentDataList.map<List<String>>((
                              row,
                            ) {
                              return [
                                row[isKecamatanMode
                                            ? 'nama_kecamatan'
                                            : 'nama_desa']
                                        ?.toString() ??
                                    '',
                                ...getMainHeaders().map(
                                  (h) =>
                                      row[h.toLowerCase().replaceAll(' ', '_')]
                                          ?.toString() ??
                                      '0',
                                ),
                              ];
                            }).toList();

                            exportToExcel(
                              headers: headers,
                              rows: rows,
                              fileName: getSelectedTableTitle().replaceAll(
                                ' ',
                                '_',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: calculatedWidth,
                            child: SfDataGrid(
                              source: SubDataSource(
                                currentDataList,
                                isKecamatanMode,
                                mainHeaders,
                                tableFontSize,
                              ),
                              allowSorting: true,
                              columnWidthMode: ColumnWidthMode.auto,
                              columns: [
                                GridColumn(
                                  columnName: isKecamatanMode ? 'nama_kecamatan' : 'nama_desa',
                                  label: Container(
                                    alignment: Alignment.center,
                                    color: const Color(0xFFD0E8FF),
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      isKecamatanMode ? 'NAMA KECAMATAN' : 'NAMA DESA',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: tableFontSize,
                                      ),
                                    ),
                                  ),
                                ),
                                ...mainHeaders.map(
                                  (h) => GridColumn(
                                    columnName: h.toLowerCase().replaceAll(' ', '_'),
                                    label: Container(
                                      alignment: Alignment.center,
                                      color: const Color(0xFFD0E8FF),
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        h.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: tableFontSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              stackedHeaderRows: filterParam != null &&
                                      filterParam!.fTtabel
                                          .firstWhere((e) => e.id == selectedTable!)
                                          .dataSubKolom
                                          .trim()
                                          .isNotEmpty
                                  ? [
                                      StackedHeaderRow(cells: [
                                        StackedHeaderCell(
                                          columnNames: mainHeaders
                                              .map((e) => e.toLowerCase().replaceAll(' ', '_'))
                                              .toList(),
                                          child: Container(
                                            alignment: Alignment.center,
                                            color: const Color(0xFFB2D6F5),
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              filterParam!.fTtabel
                                                  .firstWhere((e) => e.id == selectedTable!)
                                                  .dataKolom
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: tableFontSize,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ]
                                  : [],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF0148A4),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => currentIndex = index);
          if (index == 0) Navigator.pushNamed(context, '/');
          if (index == 1) Navigator.pushNamed(context, '/dash');
          if (index == 2) Navigator.pushNamed(context, '/tentang');
          if (index == 4) Navigator.pushNamed(context, '/profil');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.my_location), label: 'Dash'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Tentang'),
          BottomNavigationBarItem(icon: Icon(Icons.data_array), label: 'Data'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Profil'),
        ],
      ),
    );
  }
}
