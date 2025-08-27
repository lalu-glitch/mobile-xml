import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/transaksi_viewmodel.dart';

class TransaksiProsesPage extends StatefulWidget {
  final String nomorTujuan;
  final String kodeProduk;

  const TransaksiProsesPage({
    super.key,
    required this.nomorTujuan,
    required this.kodeProduk,
  });

  @override
  State<TransaksiProsesPage> createState() => _TransaksiProsesPageState();
}

class _TransaksiProsesPageState extends State<TransaksiProsesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TransaksiViewModel>().prosesTransaksi(
          widget.nomorTujuan,
          widget.kodeProduk,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransaksiViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Proses Transaksi"),
        backgroundColor: Colors.orangeAccent,
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
    children: const [
      CircularProgressIndicator(color: Colors.orangeAccent, strokeWidth: 5),
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
    children: const [
      CircularProgressIndicator(color: Colors.orangeAccent, strokeWidth: 5),
      SizedBox(height: 16),
      Text(
        "Memproses...",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    ],
  );

  /// Widget ketika error
  Widget _errorWidget(String message) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.error, color: Colors.red, size: 64),
      const SizedBox(height: 16),
      Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 16),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          context.read<TransaksiViewModel>().prosesTransaksi(
            widget.nomorTujuan,
            widget.kodeProduk,
          );
        },
        child: const Text("Coba Lagi"),
      ),
    ],
  );

  Widget _statusWidget(TransaksiViewModel vm) {
    final status = vm.statusTransaksi;

    if (status?.isSukses ?? false) {
      // Jika SUKSES
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 64),
          const SizedBox(height: 16),
          Text(
            status!.keterangan,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Selesai"),
          ),
        ],
      );
    } else if (status?.statusTrx == 40 ||
        status?.statusTrx == 43 ||
        status?.statusTrx == 47 ||
        status?.statusTrx == 50 ||
        status?.statusTrx == 52 ||
        status?.statusTrx == 53 ||
        status?.statusTrx == 55) {
      // Jika GAGAL
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(
            status?.keterangan ?? "GAGAL",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      );
    } else {
      // Pending / menunggu
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Colors.orangeAccent,
            strokeWidth: 5,
          ),
          const SizedBox(height: 16),
          Text(
            status?.keterangan ?? "Menunggu Konfirmasi...",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () =>
                context.read<TransaksiViewModel>().cekStatusTransaksi(),
            icon: const Icon(Icons.refresh),
            label: const Text("Perbarui Status"),
          ),
        ],
      );
    }
  }
}
