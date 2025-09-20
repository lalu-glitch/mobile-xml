// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../core/helper/constant_finals.dart';
import '../../core/utils/error_dialog.dart';
import '../../viewmodels/transaksi_viewmodel.dart';
import 'package:logger/logger.dart';

import '../input_nomor/transaksi_cubit.dart';

class TransaksiProsesPage extends StatefulWidget {
  const TransaksiProsesPage({super.key});

  @override
  State<TransaksiProsesPage> createState() => _TransaksiProsesPageState();
}

class _TransaksiProsesPageState extends State<TransaksiProsesPage> {
  bool _isInit = false;
  final logger = Logger();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final transaksi = context.read<TransaksiCubit>().getData();
      final vm = context.read<TransaksiViewModel>();
      _isInit = true;

      // Reset ViewModel dulu untuk bersihkan state lama
      vm.reset();

      // langsung panggil proses transaksi
      Future.microtask(() {
        if (mounted) {
          context.read<TransaksiViewModel>().prosesTransaksi(
            transaksi.tujuan!,
            transaksi.kodeProduk!,
            transaksi.kodeDompet!,
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
        style: TextStyle(fontSize: Screen.kSize24, fontWeight: FontWeight.bold),
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
        const Icon(Icons.error, color: kRed, size: 64),
        const SizedBox(height: 16),
        Text(
          (message != null && message.isNotEmpty)
              ? message
              : "Gangguan transaksi, Ulangi beberapa saat lagi.",
          style: TextStyle(color: kRed, fontSize: Screen.kSize16),
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
              fontSize: Screen.kSize32,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            status.outbox,
            style: TextStyle(fontSize: Screen.kSize14, color: Colors.black),
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
          const Icon(Icons.error, color: kRed, size: 64),
          const SizedBox(height: 16),
          Text(
            status?.keterangan ?? "GAGAL",
            style: TextStyle(
              fontSize: Screen.kSize18,
              fontWeight: FontWeight.bold,
              color: kRed,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            status?.outbox ?? "Silahkan Lihat Detail",
            style: TextStyle(fontSize: Screen.kSize14, color: Colors.black),
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
            style: TextStyle(
              fontSize: Screen.kSize18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "Transaksi mungkin memakan waktu lama, Cek history transaksi.",
            style: TextStyle(color: Colors.black, fontSize: Screen.kSize14),
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
