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
  @override
  void initState() {
    super.initState();
    final transaksi = context.read<TransaksiHelperCubit>().getData();
    final cubit = context.read<WebsocketTransaksiCubit>();

    cubit.reset();
    cubit.startTransaksi(
      transaksi.tujuan ?? '',
      transaksi.kodeProduk ?? '',
      nominal: transaksi.isBebasNominal == 1
          ? transaksi.bebasNominalValue ?? 0
          : 0,
      endUser: transaksi.isEndUser == 1 ? transaksi.endUserValue ?? '' : '',
    );
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
      body: Center(
        child: BlocConsumer<WebsocketTransaksiCubit, WebsocketTransaksiState>(
          listener: (context, state) {
            final transaksiCubit = context.read<TransaksiHelperCubit>();
            if (state is WebSocketTransaksiSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/transaksiDetail',
                (route) => false,
                arguments: state.data,
              );
              transaksiCubit.reset();
            }
            if (state is WebSocketTransaksiFailed) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/transaksiDetail',
                (route) => false,
                arguments: state.data,
              );
              transaksiCubit.reset();
            }
            if (state is WebSocketTransaksiError) {
              showErrorDialog(
                context,
                (state.message.isNotEmpty)
                    ? state.message
                    : 'Gangguan transaksi, Ulangi beberapa saat lagi.',
              );
              transaksiCubit.reset();
            }
          },
          builder: (context, state) {
            if (state is WebSocketTransaksiLoading) {
              return _loadingWidget();
            } else if (state is WebSocketTransaksiPending) {
              return _statusWidget(state.data, context);
            } else if (state is WebSocketTransaksiError) {
              return _errorWidget(state.message);
            } else {
              return _waitingWidget();
            }
          },
        ),
      ),
    );
  }

  Widget _waitingWidget() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(color: kOrange, strokeWidth: 5),
      const SizedBox(height: 16),
      Text(
        'Koneksi Sedang Disiapkan',
        style: TextStyle(
          fontSize: kSize18,
          fontWeight: FontWeight.w500,
          color: kOrange,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 8),
      Text(
        "Koneksi kamu sedang disiapkan",
        style: TextStyle(color: kBlack, fontSize: kSize14),
        textAlign: TextAlign.center,
      ),
    ],
  );

  /// Widget loading (proses API ongoing)
  Widget _loadingWidget() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: kOrange, strokeWidth: 5),
        const SizedBox(height: 16),
        Text(
          'Transaksi Sedang Disiapkan',
          style: TextStyle(
            fontSize: kSize18,
            fontWeight: FontWeight.w500,
            color: kOrange,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Transaksi kamu sedang disiapkan",
          style: TextStyle(color: kBlack, fontSize: kSize14),
          textAlign: TextAlign.center,
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
          Text(
            'Ops! Terjadi Kesalahan',
            style: TextStyle(
              color: kRed,
              fontSize: kSize24,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Terjadi kesalahan saat proses transaksi. Silahkan coba lagi.',
            style: TextStyle(color: kBlack, fontSize: kSize14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kOrange,
                foregroundColor: kWhite,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
              child: const Text("Kembali ke Menu Utama"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusWidget(TransaksiResponse status, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: kOrange, strokeWidth: 5),
        const SizedBox(height: 32),
        Text(
          status.keterangan,
          style: TextStyle(
            fontSize: kSize18,
            fontWeight: FontWeight.w600,
            color: kOrange,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            text:
                'Proses Transaksi sedikit tertunda. Mohon bersabar ya, kamu bisa cek statusnya secara berkala di ',
            style: TextStyle(
              color: kNeutral60,
              fontSize: kSize12,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(
                text: 'Riwayat Transaksi',
                style: TextStyle(
                  color: kNeutral100,
                  fontSize: kSize12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kOrange,
              foregroundColor: kWhite,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text("Kembali ke Menu Utama"),
          ),
        ),
      ],
    );
  }
}
