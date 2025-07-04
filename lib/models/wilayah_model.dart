class KecamatanOption {
  final String id;
  final String nama;

  KecamatanOption({required this.id, required this.nama});

  factory KecamatanOption.fromJson(Map<String, dynamic> json) {
    return KecamatanOption(
      id: json['iddesa'],     // ID untuk dipakai di value dropdown
      nama: json['nmkec'],    // Nama untuk ditampilkan di dropdown
    );
  }
}

class DesaOption {
  final String id;
  final String nama;
  final String idKecamatan;

  DesaOption({required this.id, required this.nama, required this.idKecamatan});

  factory DesaOption.fromJson(Map<String, dynamic> json) {
    final idDesa = json['iddesa'];
    return DesaOption(
      id: idDesa,
      nama: json['nmdesa'],
      idKecamatan: idDesa.substring(0, 7),
    );
  }
}

