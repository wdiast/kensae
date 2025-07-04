import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SubDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];
  final double fontSize;

  SubDataSource(
    List<Map<String, dynamic>> data,
    bool isKecamatanMode,
    List<String> headers,
    this.fontSize,
  ) {
    _rows = data.map((row) {
      return DataGridRow(cells: [
        DataGridCell<String>(
          columnName: isKecamatanMode ? 'nama_kecamatan' : 'nama_desa',
          value: row[isKecamatanMode ? 'nama_kecamatan' : 'nama_desa'] ?? '',
        ),
        ...headers.map((h) {
          final parts = h.split('|');

          // Jika ada 2 bagian, ambil subkolom saja (contoh: 'Status|Kota' → 'kota')
          // Jika tidak, langsung pakai nama kolom (contoh: 'Jumlah Kepala Keluarga')
          final jsonKey = parts.length == 2
              ? '${parts[0]}_${parts[1]}'.toLowerCase().replaceAll(' ', '')
              : h.toLowerCase().replaceAll(' ', '');


          // log debug
          print('[DEBUG] Header: "$h" → JSON Key: "$jsonKey" → Value: ${row[jsonKey]}');

          return DataGridCell<String>(
            columnName: h, // biarkan kolom tetap readable
            value: row[jsonKey]?.toString() ?? '0',
          );
        }),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: Text(
            cell.value.toString(),
            style: TextStyle(fontSize: fontSize),
          ),
        );
      }).toList(),
    );
  }
}
