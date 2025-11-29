import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/dialog.dart';
import '../../input_nomor/utils/transaksi_helper_cubit.dart';
import '../cubit/transaksi_omni/transaksi_omni_cubit.dart';
import '../cubit/transaksi_websocket/websocket_transaksi_cubit.dart';
import '../widgets/widget_status_transaksi.dart';

class TransaksiProsesPage extends StatefulWidget {
  const TransaksiProsesPage({super.key});

  @override
  State<TransaksiProsesPage> createState() => _TransaksiProsesPageState();
}

class _TransaksiProsesPageState extends State<TransaksiProsesPage> {
  @override
  void initState() {
    super.initState();
    // Memulai transaksi setelah frame pertama dirender agar konteks aman
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTransaction();
    });
  }

  void _startTransaction() {
    final transaksiHelper = context.read<TransaksiHelperCubit>();
    final transaksiData = transaksiHelper.getData();
    final omniData = context.read<TransaksiOmniCubit>();
    final socketCubit = context.read<WebsocketTransaksiCubit>();

    // Reset state socket sebelum mulai
    socketCubit.reset();

    // Persiapan data
    final tujuan = transaksiData.tujuan ?? omniData.state.msisdn ?? '';
    final kodeProduk = transaksiData.kodeProduk ?? omniData.state.kode ?? '';
    final nominal = (transaksiData.nominalPembayaran)?.toInt() ?? 0;
    final endUser = (transaksiData.isEndUser == 1)
        ? (transaksiData.endUserValue ?? '')
        : '';

    // Eksekusi
    socketCubit.startTransaksi(
      tujuan,
      kodeProduk,
      nominal: nominal,
      endUser: endUser,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: kBackground,
        body: BlocConsumer<WebsocketTransaksiCubit, WebsocketTransaksiState>(
          listener: (context, state) {
            final transaksiCubit = context.read<TransaksiHelperCubit>();

            // Logic Navigasi saat Sukses atau Gagal
            if (state is WebSocketTransaksiSuccess ||
                state is WebSocketTransaksiFailed) {
              // Ambil data argument sebelum reset
              final args = (state is WebSocketTransaksiSuccess)
                  ? state.data
                  : (state as WebSocketTransaksiFailed).data;

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/transaksiDetail',
                (route) => false,
                arguments: args,
              );
              transaksiCubit.reset();
            }

            // Logic Error Popup
            if (state is WebSocketTransaksiError) {
              transaksiCubit.reset();
              showErrorDialog(
                context,
                state.message.isNotEmpty
                    ? state.message
                    : 'Gangguan transaksi, Ulangi beberapa saat lagi.',
              );
            }
          },
          builder: (context, state) {
            // loading
            if (state is WebSocketTransaksiLoading ||
                state is WebsocketTransaksiInitial) {
              return const GenericStatusView(
                title: 'Transaksi Sedang Diproses',
                message: 'Mohon tunggu, kami sedang menghubungkan ke server...',
                isLoading: true,
              );
            }

            // pending
            if (state is WebSocketTransaksiPending) {
              return GenericStatusView(
                title: state.data.keterangan, // Judul dari API
                message:
                    'Transaksi sedikit tertunda. Cek status berkala di Riwayat.',
                isLoading: true, // Tetap loading tapi ada tombol
                showButton: true,
                buttonText: "Kembali ke Menu Utama",
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
              );
            }

            // error
            if (state is WebSocketTransaksiError) {
              return GenericStatusView(
                title: 'Ops! Terjadi Kesalahan',
                message:
                    'Terjadi kesalahan saat proses transaksi. Silahkan coba lagi.',
                isLoading: false,
                isError: true,
                showButton: true,
                buttonText: "Kembali ke Menu Utama",
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
              );
            }

            // Default fallback
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
