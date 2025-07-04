import 'package:flutter/material.dart';
// import 'package:kensae/pages/subData_page.dart';
import 'package:kensae/stylesKen.dart';


class DataPage extends StatelessWidget {
  const DataPage({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dataMenu = [
      {'title': 'Geografi', 'icon': Icons.map,'slug':'geografi', 'def':'0702'},
      {'title': 'Pemerintahan', 'icon': Icons.account_balance, 'slug':'pemerintahan','def':'0701'},
      {'title': 'Kependudukan', 'icon': Icons.people, 'slug':'kependudukan','def':'0101'},
      {'title': 'Tenaga Kerja', 'icon': Icons.work,'slug':'tenaga','def':'0501'},
      {'title': 'Perdagangan', 'icon': Icons.store,'slug':'perdagangan','def':'0404'},
      {'title': 'Pendidikan', 'icon': Icons.school,'slug':'pendidikan','def':'0202'},
      {'title': 'Kesehatan', 'icon': Icons.local_hospital,'slug':'kesehatan','def':'0302'},
      {'title': 'Pertanian', 'icon': Icons.agriculture,'slug':'pertanian','def':'0802'},
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFCFE9FD),
      body: SafeArea(
        child: Column(
          children: [
            // Header with fade-in animation
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: const [
                  Icon(Icons.bar_chart, size: 32, color: Color(0xFF003366)),
                  SizedBox(width: 8),
                  Text('Data',style: titleTextStyle),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: boxDecoration,
                child: ListView.separated(
                  itemCount: dataMenu.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final item = dataMenu[index];
                    return ListTile(
                      leading: Icon(item['icon'], color: Colors.blue),
                      title: Text(item['title'],style: subtitleText,),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/subdata',
                          arguments:{
                            'title': item['title'],
                            'slug': item['slug'],
                            'def': item['def'],
                            } 
                        );
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: const Color(0xFF0148A4),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/dash');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/tentang');
          } else if (index == 3) {
            // Stay on current page
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