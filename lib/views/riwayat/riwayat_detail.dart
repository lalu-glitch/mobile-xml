import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // Untuk Clipboard
import 'package:intl/intl.dart';

import '../../../core/constant_finals.dart';
import '../../data/services/api_service.dart';
import '../../data/services/auth_service.dart';
import '../../core/helper/error_dialog.dart';
import '../../viewmodels/riwayat_viewmodel.dart';

class DetailRiwayatPage extends StatefulWidget {
  final String kode;
  const DetailRiwayatPage({super.key, required this.kode});

  @override
  State<DetailRiwayatPage> createState() => _DetailRiwayatPageState();
}

class _DetailRiwayatPageState extends State<DetailRiwayatPage> {
  late final RiwayatTransaksiViewModel vm;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    vm = RiwayatTransaksiViewModel(
      service: ApiService(authService: AuthService()),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final String kode = args['kode'];
      vm.loadDetailRiwayat(kode); // aman, context sudah valid
      _isInit = true;
    }
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Consumer<RiwayatTransaksiViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (vm.error != null) {
            return Scaffold(body: Center(child: Text(vm.error!)));
          }

          final status = vm.statusTransaksi!;
          // final bool isSuccess = status.statusTrx == 20;

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Detail Riwayat Transaksi',
                style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
              ),
              backgroundColor: kOrange,
              iconTheme: const IconThemeData(color: kWhite),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildDetailItem("Kode", status.kode.toString()),
                      _buildDetailItem("Produk", status.kodeProduk),
                      _buildDetailItem("Tujuan", status.tujuan),
                      _buildDetailItem(
                        "Waktu",
                        DateFormat(
                          'dd MMM yyyy, HH:mm',
                        ).format(status.tglEntri),
                      ),
                      _buildDetailItem("Status", status.keterangan),
                      _buildDetailItem("Harga", status.harga.toString()),
                      _buildDetailItem("SN", status.sn),
                      _buildDetailItem("Outbox", status.outbox),
                    ],
                  ),
                ),
                // Tombol Struk di paling bawah
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kOrange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        shadowColor: Colors.orangeAccent.shade100,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/struk',
                          arguments: {'transaksi': status},
                        );
                      },
                      child: Text(
                        "Cetak Struk",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: kWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(String label, String? value) => Card(
    margin: const EdgeInsets.symmetric(vertical: 1),
    child: ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(value ?? '-'), // tampilkan '-' kalau null
      trailing: IconButton(
        icon: const Icon(Icons.copy, size: 20),
        onPressed: () {
          if (value != null && value.isNotEmpty) {
            Clipboard.setData(ClipboardData(text: value));
            showInfoToast("Text berhasil di copy : $value");
          } else {
            showInfoToast("gagal copy");
          }
        },
      ),
    ),
  );
}
