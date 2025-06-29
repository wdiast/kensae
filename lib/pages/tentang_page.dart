import 'package:flutter/material.dart';
import 'package:kensae/stylesKen.dart';

class TentangPage extends StatefulWidget {
  const TentangPage({super.key});

  @override
  State<TentangPage> createState() => _TentangPageState();
}

class _TentangPageState extends State<TentangPage> {
  bool _isExpanded1 = false;
  bool _isExpanded2 = false;
  bool _showFullText = false;
  final Color primaryColor = const Color(0xFF0148A4);

  @override
  Widget build(BuildContext context) {
    String fullText =
        'Penerapan Satu Data Indonesia (SDI) di tingkat kabupaten bertujuan menciptakan data pemerintah yang akurat, mutakhir, terpadu, dan dapat dipertanggungjawabkan, serta mudah diakses dan dibagipakaikan antar instansi pusat dan daerah. Data yang berkualitas menjadi fondasi penting bagi perencanaan, pelaksanaan, evaluasi, dan pengendalian pembangunan. Untuk mencapai hal tersebut, diperlukan kolaborasi antara Badan Pusat Statistik (BPS) sebagai pembina data dengan Forum data yang ada di masing masing daerah.\n\nMerespon kebutuhan tersebut, Badan Pusat Statistik (BPS) Kabupaten Kendal menginisiasi sebuah program bernama Kensae, yang merupakan singkatan dari Kendal Satu Data dari Desa. Kensae dikembangkan sebagai sistem layanan data terintegrasi yang bertujuan membina desa dalam memahami pentingnya statistik desa serta membekali desa dengan sarana pengelolaan data secara mandiri, terstandarisasi, dan terintegrasi sesuai prinsip SDI.\n\nSelain memberikan manfaat langsung bagi pemerintah daerah setempat dan desa, KenSae juga berfungsi sebagai sarana pembinaan data sektoral dan data kewilayahan berbasis desa. Dalam sistem ini, data yang diinput oleh desa diverifikasi oleh kecamatan dan OPD terkait sebagai produsen data sektoral. Melalui skema ini, OPD didorong untuk meningkatkan pemahaman dan kapasitasnya dalam pengelolaan data yang berkualitas. Hal ini sejalan dengan prinsip integrasi dan sinkronisasi antar tingkatan pemerintahan.\n\nAplikasi KenSae menjadi sistem yang mendukung tata kelola data secara berjenjang, dari desa hingga kabupaten. hal ini menjadi bagian dari implementasi program Desa Cantik (Desa Cinta Statistik) sekaligus pembinaan statistik sektoral yang berkualitas dan berkelanjutan. KenSae menghadirkan penyajian data berbasis WebGIS yang interaktif dan informatif untuk memudahkan analisis kebijakan, serta alur kerja yang mendorong kolaborasi lintas sektor antara desa, kecamatan, dan OPD di lingkungan Pemerintah Kabupaten Kendal.';

    String shortText = fullText.split("\n\n")[0];

    return Scaffold(
      backgroundColor: const Color(0xFFCFE9FD),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER LOGO & TEXT
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/logo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('KenSae',style: logoTextStyle),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 15),
                          children: [
                            TextSpan(
                                text: '(Kendal ',
                                style: TextStyle(color: Color(0xFF4CAF50))),
                            TextSpan(
                                text: 'Satu ',
                                style: TextStyle(color: Colors.lightBlue)),
                            TextSpan(
                                text: 'Data ',
                                style: TextStyle(color: Colors.deepOrange)),
                            TextSpan(
                                text: 'dari Desa)',
                                style: TextStyle(color: Colors.yellow)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: boxDecoration,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3CD),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Latar Belakang',style: titleTextStyle),
                            const SizedBox(height: 8),
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 300),
                              crossFadeState: _showFullText ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              firstChild: Text(
                                shortText,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(fontSize: 14),
                              ),
                              secondChild: Text(
                                fullText, 
                                textAlign: TextAlign.justify,
                                style: const TextStyle(fontSize: 14)
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _showFullText = !_showFullText;
                                });
                              },
                              child: Text(_showFullText ? 'Sembunyikan' : 'Baca Selengkapnya'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ExpansionTile(
                        title: const Text('Filosofi Logo',style: titleTextStyle),
                        trailing: AnimatedRotation(
                          turns: _isExpanded1 ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                        ),
                        initiallyExpanded: _isExpanded1,
                        onExpansionChanged: (value) => setState(() => _isExpanded1 = value),
                        children: [
                          Container(
                            width: double.infinity,
                            color: const Color(0xFFFFF3CD),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(child: Image.asset('assets/img/logo.png', height: 100)),
                                const SizedBox(height: 12),
                                const Text(
                                  'Bentuk Hijau dan Biru (Simbol Alam dan Keseimbangan)',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Text('\u2022 Elemen hijau (Bukit) huruf “K” melambangkan lahan & sumber daya desa', textAlign: TextAlign.justify),
                                const Text('\u2022 Elemen biru (Sungai) huruf “S” menggambarkan aliran informasi digital',textAlign: TextAlign.justify),
                                const SizedBox(height: 8),
                                const Text(
                                  'Rumah Merah (Simbol Desa) huruf "A"',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Text('Rumah melambangkan desa sebagai pusat komunitas dan kehidupan masyarakat.',textAlign: TextAlign.justify),
                                const SizedBox(height: 8),
                                const Text(
                                  'Garis Kuning Vertikal (Simbol Data/Sigma) huruf "E"',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Text('Tiga garis kuning melambangkan aliran data yang terstruktur dan berkelanjutan.',textAlign: TextAlign.justify),
                                const SizedBox(height: 8),
                                const Text(
                                  'Kesatuan Bentuk',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Text('Mencerminkan integrasi & sinergi dari berbagai jenis data menjadi satu platform terpadu.',textAlign: TextAlign.justify),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      ExpansionTile(
                        title: const Text('Kontak',style: titleTextStyle),
                        trailing: AnimatedRotation(
                          turns: _isExpanded2 ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: const Icon(Icons.keyboard_arrow_down, color:Colors.grey),
                        ),
                        initiallyExpanded: _isExpanded2,
                        onExpansionChanged: (value) => setState(() => _isExpanded2 = value),
                        children: [
                          Container(
                            width: double.infinity,
                            color: const Color(0xFFFFF3CD),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text (
                                  'Kontak BPS Kendal:',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                                const Text('\nAlamat : Jl. Pramuka Komplek Perkantoran Kendal, Sukup Kulon, Purwokerto, Kec. Patebon, Kabupaten Kendal, Jawa Tengah 51351 \nWebsite: kendalkab.bps.go.id \nEmail: bps3324@gmail.com \nTelp: (0294) 381461 \nFaks: (0294) 383461',
                                  style: TextStyle(fontSize: 14))
                              ]
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/dash');
          } else if (index == 2) {
            // Stay on current page
          } else if (index == 3) {
            Navigator.pushNamed(context, '/data');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/profil');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.my_location_sharp), label: 'Dash'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Tentang'),
          BottomNavigationBarItem(icon: Icon(Icons.data_array), label: 'Data'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Profil'),
        ],
      ),
    );
  }
}
