class Statistik {
  final String label;
  final int jumlah;

  Statistik({
    required this.label,
    required this.jumlah,
  });

  factory Statistik.fromJson(Map<String, dynamic> json) {
    return Statistik(
      label: json['label'],
      jumlah: json['jumlah'],
    );
  }
}
