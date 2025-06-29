import 'package:flutter/material.dart';
import 'package:kensae/stylesKen.dart';
import '../models/menu_item.dart';
import '../services/menu_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MenuItem> menuItems = [];
  final Color primaryColor = const Color(0xFF0148A4);

  @override
  void initState() {
    super.initState();
    loadMenu();
  }

  Future<void> loadMenu() async {
    final items = await MenuService.fetchMenu();
    setState(() {
      menuItems = items;
    });
  }

  Widget buildStat(String number, String label) {
    return Column(
      children: [
        Text(number,
            style: const TextStyle(
              color:Color(0xFF1E56A0), 
              fontSize: 24, 
              fontWeight: FontWeight.bold
            )
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget buildMenuTile(MenuItem item) {
    return Card(
      color: const Color(0xFFF1F5FE),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(item.icon, color: primaryColor,size: 50),
        title: Text(
          item.label,
          style: TextStyle(
            color: Color(0xFF003366),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.pushNamed(context, item.route);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFE9FD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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

            // CONTENT PUTIH DI BAWAH HEADER
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: boxDecoration,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStat("269", "Desa"),
                                    buildStat("1,112k", "Populasi"),
                                    buildStat("122k", "Penerima Bantuan"),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ...menuItems.map(buildMenuTile),
                                const Spacer(),
                                SizedBox(height: 12),
                                  Image.asset(
                                    'assets/img/Footer.png',
                                    fit: BoxFit.contain,
                                    opacity: AlwaysStoppedAnimation(0.8), // semi transparan biar kalem
                                  ),
                                const Divider(thickness: 1, color: Colors.black12),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            // Stay on current page
          } else if (index == 1) {
            Navigator.pushNamed(context, '/dash');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/tentang');
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
