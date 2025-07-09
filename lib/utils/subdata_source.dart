import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
// import 'dart:typed_data';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

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
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: isKecamatanMode ? 'nama_kecamatan' : 'nama_desa',
            value: row[isKecamatanMode ? 'nama_kecamatan' : 'nama_desa'] ?? '',
          ),
          ...headers.map((h) {
            final parts = h.split('|');

            // Jika ada 2 bagian, ambil subkolom saja
            // Jika tidak, langsung pakai nama kolom
            final jsonKey = parts.length == 2
                ? '${parts[0]}_${parts[1]}'
                      .toLowerCase()
                      .replaceAllMapped(RegExp(r'[>]'), (match) {
                        // Mengganti '>' dengan Unicode escape \u003E
                        return '\\u003E';
                      })
                      .replaceAll(RegExp(r'[^a-zA-Z0-9>_\\]'), '')
                : h
                      .split('/')
                      .first
                      .trim()
                      .toLowerCase()
                      .replaceAllMapped(RegExp(r'[>]'), (match) {
                        // Mengganti '>' dengan Unicode escape \u003E
                        return '\\u003E';
                      })
                      .replaceAll(RegExp(r'[^a-zA-Z0-9>_\\]'), '');

            // log debug
            print(
              '[DEBUG] Header: "$h" → JSON Key: "$jsonKey" → Value: ${row[jsonKey]}',
            );

              // Hitung langsung jika kolom rasio murid guru
            var value;
            if (jsonKey == 'rasiomuridguru') {
              final murid = double.tryParse(row['murid']?.toString() ?? '0') ?? 0;
              final guru = double.tryParse(row['guru']?.toString() ?? '0') ?? 0;
              value = guru > 0 ? (murid / guru).toStringAsFixed(1) : '0';
            } else {
              value = row[jsonKey]?.toString() ?? '0';
            }

            return DataGridCell<String>(
              columnName: h, // biarkan kolom tetap readable
              value: value,
            );
          }),
        ],
      );
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

  Future<void> exportToExcel(
    List<String> headers,
    List<List<String>> rows,
    String fileName,
  ) async {
    // Minta izin
    final status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      openAppSettings();
      return;
    }

    final workbook = excel.Workbook();
    final sheet = workbook.worksheets[0];

    // Header
    for (int i = 0; i < headers.length; i++) {
      sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
    }

    // Data rows
    for (int i = 0; i < rows.length; i++) {
      for (int j = 0; j < rows[i].length; j++) {
        sheet.getRangeByIndex(i + 2, j + 1).setText(rows[i][j]);
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    // Simpan ke folder Download
    final downloadsDir = Directory('/storage/emulated/0/Download');
    final file = File('${downloadsDir.path}/$fileName.xlsx');
    await file.writeAsBytes(bytes);

    print('File berhasil disimpan ke: ${file.path}');
  }
}
