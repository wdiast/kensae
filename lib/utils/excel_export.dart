import 'dart:io';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:path_provider/path_provider.dart';
import '../models/filter_model.dart';

Future<void> exportToExcel({
  required List<String> headers,
  required List<List<String>> rows,
  required String fileName,
}) async {
  final workbook = Workbook();
  final sheet = workbook.worksheets[0];

  // Isi header
  for (int i = 0; i < headers.length; i++) {
    sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
  }

  // Isi data
  for (int i = 0; i < rows.length; i++) {
    for (int j = 0; j < rows[i].length; j++) {
      sheet.getRangeByIndex(i + 2, j + 1).setText(rows[i][j]);
    }
  }

  final bytes = workbook.saveAsStream();
  workbook.dispose();

  final dir = await getExternalStorageDirectory();
  final file = File('${dir!.path}/$fileName.xlsx');
  await file.writeAsBytes(bytes, flush: true);
}

extension WilayahOptionConverter on WilayahOption {
  Wilayah toWilayah() => Wilayah(id: iddesa, nama: nmKec);
}

extension ListWilayahOptionConverter on List<WilayahOption> {
  List<Wilayah> toWilayahList() => map((e) => e.toWilayah()).toList();
}

