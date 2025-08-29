import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/riwayat_viewmodel.dart';
import '../models/transaksi_riwayat.dart';
import 'struk.dart';

class RiwayatTransaksiPage extends StatefulWidget {
  const RiwayatTransaksiPage({super.key});

  @override
  State<RiwayatTransaksiPage> createState() => _RiwayatTransaksiPageState();
}

class _RiwayatTransaksiPageState extends State<RiwayatTransaksiPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<HistoryViewModel>(context, listen: false).fetchHistory(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HistoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Colors.orangeAccent[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: vm.isLoading && vm.transaksi.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : vm.transaksi.isEmpty
                ? const Center(child: Text("Belum ada transaksi"))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: vm.transaksi.length,
                    itemBuilder: (context, index) {
                      final trx = vm.transaksi[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StrukPage(transaksi: trx),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  child: Text(
                                    trx.produk.isNotEmpty
                                        ? trx.produk[0].toUpperCase()
                                        : "?",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trx.produk,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Nomor: ${trx.nomor}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Tanggal: ${trx.tanggal}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "Rp ${trx.total}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // tombol Load More
          if (vm.hasMore)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: vm.isLoading
                    ? null
                    : () async {
                        await vm.fetchHistory(loadMore: true);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                ),
                child: vm.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text("Muat Lebih Banyak"),
              ),
            ),
        ],
      ),
    );
  }
}
