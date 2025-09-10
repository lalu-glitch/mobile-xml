import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/riwayat_viewmodel.dart';
import '../../data/models/transaksi_riwayat.dart';
import '../../data/services/api_service.dart';
import '../../data/services/auth_service.dart';

class RiwayatTransaksiPage extends StatelessWidget {
  const RiwayatTransaksiPage({super.key});

  Color _statusColor(RiwayatTransaksi t) {
    switch (t.status) {
      case 20:
        return Colors.green;
      case 40:
      case 43:
      case 50:
      case 52:
      case 53:
      case 55:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _statusIcon(RiwayatTransaksi t) {
    switch (t.status) {
      case 20:
        return Icons.check_circle;
      case 40:
      case 43:
      case 50:
      case 52:
      case 53:
      case 55:
        return Icons.error;
      default:
        return Icons.hourglass_top;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RiwayatTransaksiViewModel(
        service: ApiService(authService: AuthService()),
      )..loadRiwayat(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Riwayat Transaksi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.orangeAccent[700],
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Consumer<RiwayatTransaksiViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading && vm.riwayatList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (vm.riwayatList.isEmpty) {
              return Center(
                child: Text(
                  "Belum ada transaksi",
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: vm.riwayatList.length,
                    itemBuilder: (context, index) {
                      RiwayatTransaksi t = vm.riwayatList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 1,
                        ),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            leading: Icon(
                              _statusIcon(t),
                              color: _statusColor(t),
                              size: 32,
                            ),
                            title: Text(
                              t.tujuan,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tanggal: ${DateFormat('dd MMM yyyy, HH:mm').format(t.tglEntri)}",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Status: ${t.keterangan}",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: _statusColor(t),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Text(
                              "Rp ${t.harga.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/detailRiwayatTransaksi',
                                arguments: {'kode': t.kode},
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (vm.currentPage < vm.totalPages)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: SizedBox(
                      width: double.infinity, // full width
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.orangeAccent[700],
                        ),
                        onPressed: vm.isLoading
                            ? null
                            : () => vm.loadNextPage(),
                        child: vm.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Lainnya",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }
}
