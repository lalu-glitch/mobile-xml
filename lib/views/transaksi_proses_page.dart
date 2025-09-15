// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/constant_finals.dart';
import '../core/helper/error_dialog.dart';
import '../viewmodels/transaksi_viewmodel.dart';
import 'package:logger/logger.dart';

class TransaksiProsesPage extends StatefulWidget {
  const TransaksiProsesPage({
    super.key,
    required String kode_produk,
    required String tujuan,
  }); // kosong, karena pakai pushNamed

  @override
  State<TransaksiProsesPage> createState() => _TransaksiProsesPageState();
}

class _TransaksiProsesPageState extends State<TransaksiProsesPage> {
  late String tujuan;
  late String kode_produk;
  late String kode_dompet;
  bool _isInit = false;

  final logger = Logger();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      tujuan = args['tujuan'];
      kode_produk = args['kode_produk'];
      if (args['kode_dompet'] != null) {
        kode_dompet = args['kode_dompet'] as String;
      } else {
        kode_dompet = "";
      }
      _isInit = true;

      // langsung panggil proses transaksi
      Future.microtask(() {
        if (mounted) {
          context.read<TransaksiViewModel>().prosesTransaksi(
            tujuan,
            kode_produk,
            kode_dompet,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransaksiViewModel>();

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text("Proses Transaksi", style: TextStyle(color: kWhite)),
        iconTheme: const IconThemeData(color: kWhite),
        backgroundColor: kOrange,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: vm.isLoading
              ? _loadingWidget()
              : vm.error != null
              ? _errorWidget(vm.error!)
              : vm.statusTransaksi != null
              ? _statusWidget(vm)
              : _waitingResponseWidget(vm),
        ),
      ),
    );
  }

  /// Widget ketika transaksi pertama kali dikirim, menunggu response awal
  Widget _waitingResponseWidget(TransaksiViewModel vm) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(color: kOrange, strokeWidth: 5),
      SizedBox(height: 16),
      Text(
        "Mengirim Permintaan...",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      Text("Mohon tunggu sebentar...", textAlign: TextAlign.center),
    ],
  );

  /// Widget loading (proses API ongoing)
  Widget _loadingWidget() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(color: kOrange, strokeWidth: 5),
      SizedBox(height: 16),
      Text(
        "Memproses...",
        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
      ),
    ],
  );

  /// Widget ketika error
  bool _dialogShown = false;

  Widget _errorWidget(String message) {
    // logger.d("resultresult: $message");

    if (!_dialogShown) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showErrorDialog(
          context,
          (message != null && message.isNotEmpty)
              ? message
              : "Gangguan transaksi, Ulangi beberapa saat lagi.",
        );
      });
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error, color: Colors.red, size: 64),
        const SizedBox(height: 16),
        Text(
          (message != null && message.isNotEmpty)
              ? message
              : "Gangguan transaksi, Ulangi beberapa saat lagi.",
          style: TextStyle(color: Colors.red, fontSize: 16.sp),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
          child: const Text("Kembali ke Home"),
        ),
      ],
    );
  }

  Widget _statusWidget(TransaksiViewModel vm) {
    final status = vm.statusTransaksi;
    // logger.d("resultresult: $vm");

    if (status?.isSukses ?? false) {
      // Jika SUKSES
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 64),
          const SizedBox(height: 16),
          Text(
            status!.keterangan,
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            status.outbox,
            style: TextStyle(fontSize: 14.sp, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/transaksiDetail',
                (route) => false,
                arguments: status,
              );
            },
            child: const Text("Lihat Detail"),
          ),
        ],
      );
    } else if ([40, 43, 47, 50, 52, 53, 55].contains(status?.statusTrx)) {
      // Jika GAGAL
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(
            status?.keterangan ?? "GAGAL",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            status?.outbox ?? "Silahkan Lihat Detail",
            style: TextStyle(fontSize: 14.sp, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/transaksiDetail',
                (route) => false,
                arguments: status,
              );
            },
            child: const Text("Lihat Detail"),
          ),
        ],
      );
    } else {
      // Pending / menunggu
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: kOrange, strokeWidth: 5),
          const SizedBox(height: 16),
          Text(
            status?.keterangan ?? "Menunggu Konfirmasi...",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          Text(
            "Transaksi mungkin memakan waktu lama, Cek history transaksi.",
            style: TextStyle(color: Colors.black, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text("Ke Menu Utama"),
          ),
        ],
      );
    }
  }
}
