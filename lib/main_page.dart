import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmlapp/data/services/api_service.dart';
import 'package:xmlapp/views/riwayat/cubit/riwayat_transaksi_cubit.dart';

import 'core/helper/constant_finals.dart';

import 'views/home/page/home_page.dart';
// import 'views/poin_dan_komisi/pages/widgets/top_bottom_ticket_cut.dart';
import 'views/riwayat/pages/riwayat_page.dart';
import 'views/shops/pages/shop_page.dart';
import 'views/settings/pages/settings_page.dart';
import 'core/helper/auth_guard.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      AuthGuard(child: HomePage()),
      AuthGuard(child: ShopPage()),
      // Scoped provider
      AuthGuard(
        child: BlocProvider<RiwayatTransaksiCubit>(
          create: (context) => RiwayatTransaksiCubit(ApiService()),
          child: RiwayatTransaksiPage(),
        ),
      ),
      // AuthGuard(child: RiwayatTransaksiPage()),
      AuthGuard(child: SettingsPage()),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
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
