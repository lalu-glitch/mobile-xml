import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/dialog.dart';
import '../../../data/models/transaksi/websocket_transaksi.dart';

import '../../input_nomor/utils/transaksi_cubit.dart';
import '../cubit/websocket_transaksi_cubit.dart';

class TransaksiProsesPage extends StatefulWidget {
  const TransaksiProsesPage({super.key});

  @override
  State<TransaksiProsesPage> createState() => _TransaksiProsesPageState();
}

class _TransaksiProsesPageState extends State<TransaksiProsesPage> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final transaksi = context.read<TransaksiHelperCubit>().getData();
      final cubit = context.read<WebsocketTransaksiCubit>();
      _isInit = true;
      Future.microtask(() async {
        cubit.reset(); // <-- TAMBAHKAN BARIS INI
        cubit.startTransaksi(
          transaksi.tujuan ?? '',
          transaksi.kodeProduk ?? '',
          nominal: transaksi.isBebasNominal == 1
              ? transaksi.bebasNominalValue ?? 0
              : 0,
          endUser: transaksi.isEndUser == 1 ? transaksi.endUserValue ?? '' : '',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text("Proses Transaksi", style: TextStyle(color: kWhite)),
        iconTheme: const IconThemeData(color: kWhite),
        backgroundColor: kOrange,
      ),
      body: BlocListener<WebsocketTransaksiCubit, WebsocketTransaksiState>(
        listener: (context, state) {
          if (state is WebSocketTransaksiError) {
            showErrorDialog(
              context,
              (state.message.isNotEmpty)
                  ? state.message
                  : "Gangguan transaksi, Ulangi beberapa saat lagi.",
            );
          }
        },
        child: Center(
          child: BlocBuilder<WebsocketTransaksiCubit, WebsocketTransaksiState>(
            builder: (context, state) {
              debugPrint('TransaksiProsesPage State: $state');
              if (state is WebSocketTransaksiLoading) {
                return _loadingWidget();
              } else if (state is WebSocketTransaksiPending) {
                return _pendingWidget(state.data);
              } else if (state is WebSocketTransaksiSuccess) {
                return _statusWidget(state.data, context);
              } else if (state is WebSocketTransaksiError) {
                return _errorWidget(state.message);
              } else {
                return _waitingWidget();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _waitingWidget() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const CircularProgressIndicator(color: kOrange, strokeWidth: 5),
      const SizedBox(height: 16),
      const Text(
        "Menyiapkan koneksi...",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    ],
  );

  /// Widget loading (proses API ongoing)
  Widget _loadingWidget() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: kOrange, strokeWidth: 5),
        SizedBox(height: 16),
        Text(
          "Memproses...",
          style: TextStyle(fontSize: kSize24, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );

  /// Widget ketika error
  Widget _errorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: kRed, size: 64),
          const SizedBox(height: 16),
          Text(
            (message.isNotEmpty)
                ? message
                : "Gangguan transaksi, Ulangi beberapa saat lagi.",
            style: TextStyle(color: kRed, fontSize: kSize16),
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
      ),
    );
  }

  /// Widget ketika status transaksi masih pending (1 atau 2)
  Widget _pendingWidget(TransaksiResponse status) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: kOrange, strokeWidth: 5),
        const SizedBox(height: 16),
        Text(
          status.keterangan, // Menampilkan "Menunggu Jawaban", dll.
          style: TextStyle(fontSize: kSize18, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Transaksi mungkin memakan waktu lama, Cek history transaksi.",
          style: TextStyle(color: Colors.black54, fontSize: kSize14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () =>
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
          child: const Text("Kembali ke Menu Utama"),
        ),
      ],
    );
  }

  Widget _statusWidget(TransaksiResponse status, BuildContext context) {
    log('STATUS : ${status.statusTrx}}');
    if (status.statusTrx == 20) {
      // Jika SUKSES
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: kGreen, size: 64),
          const SizedBox(height: 16),
          Text(
            status.keterangan,
            style: TextStyle(
              fontSize: kSize32,
              fontWeight: FontWeight.bold,
              color: kGreen,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            status.outbox ?? '',
            style: TextStyle(fontSize: kSize14, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/transaksiDetail',
                (route) => false,
                arguments:
                    status, // <--- pass status including outbox ke page berikutnya
              );
            },
            child: const Text("Lihat Detail"),
          ),
        ],
      );
    } else if (status.statusTrx == 40 ||
        status.statusTrx == 43 ||
        status.statusTrx == 47 ||
        status.statusTrx == 45 ||
        status.statusTrx == 50 ||
        status.statusTrx == 52 ||
        status.statusTrx == 53 ||
        status.statusTrx == 55 ||
        status.statusTrx == 56 ||
        status.statusTrx == 58) {
      // Jika GAGAL
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: kRed, size: 64),
          const SizedBox(height: 16),
          Text(
            status.keterangan,
            style: TextStyle(
              fontSize: kSize24,
              fontWeight: FontWeight.bold,
              color: kRed,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            status.outbox ?? "Silahkan Lihat Detail",
            style: TextStyle(fontSize: kSize14, color: kBlack),
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
      // Jika status PENDING / MENUNGGU JAWABAN
      return _pendingWidget(status);
    }
  }
}
