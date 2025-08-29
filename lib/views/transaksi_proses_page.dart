import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/transaksi_viewmodel.dart';
import 'transaksi_detail_page.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Proses Transaksi",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.orangeAccent[700],
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
      CircularProgressIndicator(
        color: Colors.orangeAccent[700],
        strokeWidth: 5,
      ),
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
      CircularProgressIndicator(
        color: Colors.orangeAccent[700],
        strokeWidth: 5,
      ),
      SizedBox(height: 16),
      Text(
        "Memproses...",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    ],
  );

  /// Widget ketika error
  Widget _errorWidget(String message) {
    logger.d("resultresult: $message");

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error, color: Colors.red, size: 64),
        const SizedBox(height: 16),
        Text(
          "Gangguan transaksi, Ulangi beberapa saat lagi.",
          style: const TextStyle(color: Colors.red, fontSize: 16),
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
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            status?.outbox ?? "Silahkan Lihat Detail",
            style: const TextStyle(fontSize: 14, color: Colors.black),
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            status?.outbox ?? "Silahkan Lihat Detail",
            style: const TextStyle(fontSize: 14, color: Colors.black),
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
          CircularProgressIndicator(
            color: Colors.orangeAccent[700],
            strokeWidth: 5,
          ),
          const SizedBox(height: 16),
          Text(
            status?.keterangan ?? "Menunggu Konfirmasi...",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          Text(
            "Transaksi mungkin memakan waktu lama, Cek history transaksi.",
            style: const TextStyle(color: Colors.black, fontSize: 14),
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
