class Sarpras {
  final int id;
  final String nama;
  final String jenis; // SD, SMP, SMA, Masjid, Gereja, dll
  final String subject; // Pendidikan, Ibadah, dll
  final String kecamatan;
  final String desa;
  final int tahun;
  final double lat;
  final double lng;

  Sarpras({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.subject,
    required this.kecamatan,
    required this.desa,
    required this.tahun,
    required this.lat,
    required this.lng,
  });

  factory Sarpras.fromJson(Map<String, dynamic> json) {
    return Sarpras(
      id: json['id'],
      nama: json['nama'],
      jenis: json['jenis'],
      subject: json['subject'],
      kecamatan: json['kecamatan'],
      desa: json['desa'],
      tahun: json['tahun'],
      lat: double.parse(json['lat'].toString()),
      lng: double.parse(json['lng'].toString()),
    );
  }
}
