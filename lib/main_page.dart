import 'package:flutter/material.dart';
import 'core/constant_finals.dart';
import 'views/home_page.dart';
import 'views/shops/shops_page.dart';
import 'views/analytics/analytics_page.dart';
import 'views/settings_page.dart';
// Tambahkan import service auth
import 'data/services/auth_guard.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    AuthGuard(child: HomePage()),
    AuthGuard(child: ShopsPage()),
    AuthGuard(child: AnalyticsPage()),
    AuthGuard(child: SettingsPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: Styles.kNunitoBold,
        unselectedLabelStyle: Styles.kNunitoRegular,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
