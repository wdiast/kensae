import 'package:latlong2/latlong.dart';

class SarprasMarker {
  final LatLng posisi;
  final String popup;
  final String kategori;

  SarprasMarker({required this.posisi, required this.popup, required this.kategori});
}

class StatistikBox {
  final String label;
  final String jumlah;

  StatistikBox({required this.label, required this.jumlah});
}