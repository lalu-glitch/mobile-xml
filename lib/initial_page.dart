import 'package:flutter/material.dart';
import 'core/helper/constant_finals.dart';
import 'views/home/page/home_page.dart';
import 'views/riwayat/pages/riwayat_page.dart';
import 'views/shops/pages/shop_page.dart';
import 'views/settings/pages/settings_page.dart';
import 'core/helper/auth_guard.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      AuthGuard(child: const HomePage()),
      AuthGuard(child: const ShopPage()),
      AuthGuard(child: const RiwayatTransaksiPage()),
      AuthGuard(child: const SettingsPage()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: kWhite,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_rounded),
            label: 'Toko',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'User',
          ),
        ],
      ),
    );
  }
}
