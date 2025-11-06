import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../data/models/layanan/layanan_model.dart';
import '../../../viewmodels/layanan_vm.dart';
import '../widgets/shop_category_chips.dart';
import '../widgets/shop_app_bar_actions.dart';
import 'shop_product.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  // Controller untuk menangani input teks pencarian
  final searchController = TextEditingController();

  // Menandakan apakah mode pencarian sedang aktif
  bool isSearching = false;

  // Kategori yang sedang dipilih di Chips (default: tampil semua)
  String selectedHeading = 'Semuanya';

  // ViewModel untuk mengelola data layanan
  late LayananViewModel layananVM;

  // Data hasil filter (berdasarkan kategori atau pencarian)
  Map<String, List<IconItem>> filteredLayanan = {};

  @override
  void initState() {
    super.initState();

    // Ambil instance ViewModel tanpa rebuild (listen: false)
    layananVM = context.read<LayananViewModel>();

    // Jalankan setelah build pertama selesai
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Ambil data layanan dari server atau sumber data
      await layananVM.fetchLayanan();
      // Perbarui hasil tampilan setelah data berhasil di-fetch
      _updateFilteredData();
    });

    // Dengarkan perubahan teks pencarian secara real-time
    searchController.addListener(_updateFilteredData);
  }

  // Fungsi untuk memperbarui data tampilan sesuai pencarian user
  void _updateFilteredData() {
    final query = searchController.text.toLowerCase(); // ubah ke huruf kecil
    final allData = layananVM.layananByHeading; // ambil semua data layanan

    setState(() {
      if (query.isEmpty) {
        // Jika kolom pencarian kosong → tampilkan semua data asli
        filteredLayanan = Map.from(allData);
      } else {
        // Jika user mengetik sesuatu → filter berdasarkan judul layanan
        filteredLayanan = {
          for (final entry in allData.entries)
            if (entry.value.any(
              (item) =>
                  item.title?.toLowerCase().trim().contains(query) ?? false,
            ))
              entry.key: entry.value
                  .where(
                    (item) =>
                        item.title?.toLowerCase().trim().contains(query) ??
                        false,
                  )
                  .toList(),
        };
      }
    });
  }

  void onClearText() {
    setState(() {
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan watch() agar UI rebuild otomatis saat ada perubahan data
    final layananVM = context.watch<LayananViewModel>();

    return Scaffold(
      backgroundColor: kBackground,

      // === APP BAR (Header Atas) ===
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: isSearching
            // Jika mode pencarian aktif → tampilkan TextField
            ? TextField(
                controller: searchController,
                autofocus: true,
                style: TextStyle(color: kWhite),
                decoration: InputDecoration(
                  hintText: 'Cari layanan',
                  hintStyle: TextStyle(color: kWhite.withAlpha(200)),
                  border: InputBorder.none,
                ),
              )
            // Jika tidak → tampilkan judul halaman
            : Text('Layanan Toko', style: TextStyle(color: kWhite)),
        backgroundColor: kOrange,
        iconTheme: IconThemeData(color: kWhite),
        actions: [
          // Tombol pencarian (ikon kaca pembesar / tutup)
          ShopsAppBarActions(
            isSearching: isSearching,
            onSearchChanged: (value) => setState(() => isSearching = value),
            onClear: onClearText,
          ),
        ],
      ),

      // === BODY (Isi Halaman) ===
      body: SingleChildScrollView(
        child: Column(
          children: [
            // === 1️⃣ Chips kategori ===
            // Menampilkan daftar kategori yang bisa dipilih
            ShopsCategoryChips(
              layananVM: layananVM,
              selectedHeading: selectedHeading,
              onHeadingSelected: (heading) =>
                  setState(() => selectedHeading = heading),
            ),

            const Divider(color: kNeutral50, thickness: 4),

            // === 2️⃣ Daftar produk layanan ===
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShopProducts(
                layananDataToDisplay: filteredLayanan, // data hasil filter
                selectedHeading: selectedHeading, // kategori aktif
                isLoading: layananVM.isLoading, // status loading
                error: layananVM.error, // pesan error (jika ada)
                isSearchingActive:
                    isSearching &&
                    searchController.text.isNotEmpty, // mode cari
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.removeListener(_updateFilteredData);
    searchController.dispose();
    super.dispose();
  }
}
