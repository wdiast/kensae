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
        ...headers.map((h) => DataGridCell<String>(
              columnName: h.toLowerCase().replaceAll(' ', '_'),
              value: row[h.toLowerCase().replaceAll(' ', '_')] ?? '0',
            )),
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
