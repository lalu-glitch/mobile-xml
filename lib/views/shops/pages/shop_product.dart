import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/dynamic_app_page.dart';
import '../../../core/utils/shimmer.dart';
import '../../../data/models/layanan/layanan_model.dart';
import '../../input_nomor/utils/transaksi_cubit.dart';
import '../../layanan/cubit/flow_cubit.dart';

class ShopProducts extends StatelessWidget {
  const ShopProducts({
    required this.layananDataToDisplay,
    required this.selectedHeading,
    required this.isLoading,
    required this.error,
    required this.isSearchingActive,
    super.key,
  });

  // Data hasil filter yang akan ditampilkan (berisi kategori → daftar layanan)
  final Map<String, List<IconItem>> layananDataToDisplay;

  // Heading atau kategori yang sedang dipilih user
  final String selectedHeading;

  // Status loading dari ViewModel (misal ketika fetch data)
  final bool isLoading;

  // Pesan error jika terjadi kesalahan (misal gagal fetch)
  final String? error;

  // True jika user sedang mengetik di kolom pencarian
  final bool isSearchingActive;

  @override
  Widget build(BuildContext context) {
    // === 1️⃣ Tampilan Loading & Error ===
    if (isLoading) {
      // Saat data sedang dimuat
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      // Jika terjadi error, tampilkan shimmer dummy (asumsi placeholder)
      return ShimmerBox.buildShimmerIcons();
    }

    // === 2️⃣ Tentukan apakah perlu filter berdasarkan kategori ===
    // Filter hanya aktif jika:
    // - Tidak sedang mencari, dan
    // - Kategori yang dipilih bukan "Semuanya"
    final bool shouldFilterByCategory =
        !isSearchingActive && selectedHeading != 'Semuanya';

    // Ambil hanya data dari kategori yang dipilih jika perlu
    final Iterable<MapEntry<String, List<IconItem>>> entries =
        shouldFilterByCategory
        ? layananDataToDisplay.entries.where(
            (entry) => entry.key == selectedHeading,
          )
        : layananDataToDisplay.entries;

    // === 3️⃣ Handle Jika Data Kosong ===
    if (layananDataToDisplay.isEmpty) {
      // Tidak ada layanan sama sekali
      return const Center(child: Text("Tidak ada layanan tersedia."));
    }

    if (entries.isEmpty) {
      // Tidak ada hasil dari filter/pencarian
      return Center(
        child: Text(
          isSearchingActive
              ? "Hasil pencarian tidak ditemukan."
              : "Tidak ada layanan dalam kategori ini.",
        ),
      );
    }

    // === 4️⃣ Tampilan Daftar Layanan ===
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: entries.expand((entry) {
        final kategori = entry.key; // Nama kategori
        final layananList = entry.value; // Daftar layanan dalam kategori ini

        // Tentukan apakah header kategori perlu ditampilkan
        // - Selalu tampil saat pencarian aktif
        // - Tampil jika user memilih "Semuanya"
        final bool showCategoryHeader = isSearchingActive
            ? true
            : selectedHeading == 'Semuanya';

        return [
          // === Header kategori (judul) ===
          if (showCategoryHeader || entries.length > 1) ...[
            Text(
              kategori.toUpperCase(),
              style: TextStyle(fontSize: kSize18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
          ],

          // === Grid berisi layanan dalam kategori ini ===
          Container(
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            margin: EdgeInsets.only(bottom: (entries.last == entry) ? 0 : 24),
            child: GridView.builder(
              shrinkWrap: true, // Biar grid menyesuaikan tinggi kontennya
              physics:
                  const NeverScrollableScrollPhysics(), // Scroll diatur parent
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Jumlah kolom (4 item per baris)
                mainAxisSpacing: 12,
                crossAxisSpacing: 20,
                childAspectRatio: 0.85, // Proporsi lebar-tinggi tiap item
              ),
              itemCount: layananList.length,
              itemBuilder: (context, i) {
                final item = layananList[i];

                // === Tiap item layanan ===
                return GestureDetector(
                  onTap: () {
                    // Ambil urutan page flow berdasarkan kode flow item
                    final sequence = pageSequences[item.flow] ?? [];

                    // Jalankan alur transaksi dan catat kode
                    context.read<FlowCubit>().startFlow(item.flow!, item);
                    context.read<TransaksiCubit>().setKodeCatatan(
                      item.kodeCatatan,
                    );

                    // Arahkan ke halaman pertama dari alur (jika ada)
                    final firstPage = sequence.firstOrNull;
                    if (firstPage != null) {
                      Navigator.pushNamed(context, pageRoutes[firstPage]!);
                    }
                  },
                  child: Column(
                    children: [
                      // === Gambar layanan ===
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: CachedNetworkImage(
                          imageUrl: item.url ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const SizedBox(), // Kosong saat loading
                          errorWidget: (context, url, error) =>
                              Icon(Icons.apps, color: kOrange), // Icon fallback
                        ),
                      ),
                      const SizedBox(height: 6),

                      // === Nama layanan ===
                      Expanded(
                        child: Text(
                          item.title ?? '-',
                          style: TextStyle(fontSize: kSize12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // === Spasi antar kategori (jika ada lebih dari satu) ===
          if (entries.last != entry) const SizedBox(height: 12),
        ];
      }).toList(),
    );
  }
}
