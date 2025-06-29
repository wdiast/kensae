class TabelOption {
  final String id;
  final String nama;
  final String dataKolom;
  final String dataSubKolom;

  TabelOption({
    required this.id,
    required this.nama,
    required this.dataKolom,
    required this.dataSubKolom,
  });

  factory TabelOption.fromJson(Map<String, dynamic> json) {
    return TabelOption(
      id: json['id'] ?? '',
      nama: json['data_nama'] ?? '',
      dataKolom: json['data_kolom'] ?? '',
      dataSubKolom: json['data_subkolom'] ?? '',
    );
  }
}

class WilayahOption {
  final String iddesa;
  final String nmKec;

  WilayahOption({required this.iddesa, required this.nmKec});

  factory WilayahOption.fromJson(Map<String, dynamic> json) {
    return WilayahOption(
      iddesa: json['iddesa'] ?? '',
      nmKec: json['nmkec'] ?? '',
    );
  }
}

class Wilayah {
  final String id;
  final String nama;

  Wilayah({required this.id, required this.nama});

  factory Wilayah.fromJson(Map<String, dynamic> json) {
    return Wilayah(
      id: json['iddesa'] ?? '',
      nama: json['nmdesa'] ?? '',
    );
  }
}

class FilterParam {
  final List<TabelOption> fTtabel;
  final List<WilayahOption> fTkec;
  final String fTahun;
  final Map<String, dynamic> vData;
  final List<Wilayah> vDesa;

  FilterParam({
    required this.fTtabel,
    required this.fTkec,
    required this.fTahun,
    required this.vData,
    required this.vDesa,
  });

  factory FilterParam.fromJson(Map<String, dynamic> json) {
    return FilterParam(
      fTtabel: (json['f_ttabel'] as List<dynamic>)
          .map((e) => TabelOption.fromJson(e))
          .toList(),
      fTkec: (json['f_tkec'] as List<dynamic>)
          .map((e) => WilayahOption.fromJson(e))
          .toList(),
      fTahun: json['f_tahun'] ?? '2024',
      vData: Map<String, dynamic>.from(json['v_data'] ?? {}),
      vDesa: (json['v_desa'] as List<dynamic>)
          .map((e) => Wilayah.fromJson(e))
          .toList(),
    );
  }
}
