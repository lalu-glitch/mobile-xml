// ignore_for_file: unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';
import '../../../core/utils/dialog.dart';
import '../../../core/utils/info_row.dart';
import '../../../data/models/transaksi/metode_transaksi.dart';
import '../../../data/services/speedcash_api_service.dart';
import '../../home/cubit/balance_cubit.dart';
import '../../input_nomor/utils/transaksi_cubit.dart';
import '../cubit/transaksi_omni/transaksi_omni_cubit.dart';
import '../cubit/transaksi_speedcash/konfirmasi_transaksi_speedcash_cubit.dart';
import '../cubit/transaksi_speedcash/pembayaran_transaksi_speedcash_cubit.dart';
import 'konfirmasi_speedcash_page.dart';

class KonfirmasiPembayaranPage extends StatefulWidget {
  const KonfirmasiPembayaranPage({super.key});

  @override
  State<KonfirmasiPembayaranPage> createState() =>
      _KonfirmasiPembayaranPageState();
}

class _KonfirmasiPembayaranPageState extends State<KonfirmasiPembayaranPage> {
  String _selectedMethod = "SALDO"; // default pilihan
  final TextEditingController textController = TextEditingController();

  double getTotalTransaksi(dynamic transaksi) {
    final double basePrice = transaksi.productPrice ?? 0;

    final totalTagihanPrice = transaksi.finalTotal ?? 0;
    if (totalTagihanPrice > 0) {
      final serviceFee = transaksi.fee ?? 0.0;
      double base = totalTagihanPrice + serviceFee;
      return base;
    }
    if (transaksi.isBebasNominal == 1) {
      final double bebasNominalPrice = transaksi.bebasNominalValue ?? 0;
      return bebasNominalPrice;
    }
    return basePrice;
  }

  double getDisplayedTotal(dynamic transaksi) {
    final double totalTagihanPrice = transaksi.finalTotal ?? 0.0;
    if (totalTagihanPrice > 0) {
      final serviceFee = transaksi.fee ?? 0.0;
      return totalTagihanPrice + serviceFee;
    }
    if (transaksi.isBebasNominal == 1) {
      final productPrice = transaksi.productPrice ?? 0.0;
      final bebas = (transaksi.bebasNominalValue ?? 0).toDouble();
      return productPrice + bebas;
    }
    return transaksi.productPrice ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final transaksi = context.read<TransaksiHelperCubit>().getData();

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          title: const Text('Konfirmasi', style: TextStyle(color: kWhite)),
          backgroundColor: kOrange,
          iconTheme: const IconThemeData(color: kWhite),
        ),
        body: BlocBuilder<BalanceCubit, BalanceState>(
          builder: (context, state) {
            if (state is BalanceLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BalanceError) {
              return Center(
                child: Text('Gagal memuat saldo: ${state.message}'),
              );
            }

            if (state is BalanceLoaded) {
              final methods = _generatePaymentMethods(state);

              return Padding(
                padding: const .all(16.0),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    _buildInfoCard(transaksi),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Metode Pembayaran",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: kSize14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Column(
                      children: methods
                          .map(
                            (m) => _paymentOption(m, _selectedMethod == m.nama),
                          )
                          .toList(),
                    ),

                    const Spacer(),
                    _buildPayButton(methods, transaksi),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// Generate daftar metode pembayaran dari BalanceCubit
  List<PaymentMethodModel> _generatePaymentMethods(BalanceState state) {
    if (state is! BalanceLoaded) return [];

    final saldo = state.data.saldo ?? 0;
    final eWallets = state.data.ewallet ?? [];
    return [
      PaymentMethodModel(nama: "SALDO", kodeDompet: "", saldoEwallet: saldo),
      ...eWallets.map(
        (ewallet) => PaymentMethodModel(
          nama: ewallet.nama,
          kodeDompet: ewallet.kodeDompet,
          saldoEwallet: ewallet.saldoEwallet,
        ),
      ),
    ];
  }

  /// Card informasi transaksi
  Widget _buildInfoCard(dynamic transaksi) {
    final omni = context.read<TransaksiOmniCubit>().state;

    final nomorTujuan = omni.msisdn ?? transaksi.tujuan;
    final kodeProduk = omni.kode ?? transaksi.kodeProduk;
    final totalTransaksi = getDisplayedTotal(transaksi);

    // ===== DYNAMIC FIELD MAPPING =====
    final Map<String, dynamic> infoFields = {
      "Nomor Tujuan": nomorTujuan,
      "Kode Produk": kodeProduk,
      "Nama Produk": transaksi.namaProduk,
      if (transaksi.isBebasNominal == 1) ...{
        "Harga Produk": CurrencyUtil.formatCurrency(transaksi.productPrice),
        "Nominal": CurrencyUtil.formatCurrency(transaksi.bebasNominalValue),
      },
      "Total Pembayaran": CurrencyUtil.formatCurrency(totalTransaksi),
    };

    return Card(
      color: kWhite,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: buildDynamicInfoRows(infoFields)),
      ),
    );
  }

  /// Option pilihan metode pembayaran
  Widget _paymentOption(PaymentMethodModel method, bool isSelected) {
    return Card(
      color: kWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() => _selectedMethod = method.nama ?? '');
        },
        child: Padding(
          padding: const .symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                method.nama ?? '-',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: kSize16,
                ),
              ),
              Row(
                mainAxisSize: .min,
                children: [
                  if (method.saldoEwallet != null)
                    Padding(
                      padding: const .only(right: 8),
                      child: Text(
                        CurrencyUtil.formatCurrency(method.saldoEwallet ?? 0),
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isSelected ? kOrange : Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Tombol Bayar
  Widget _buildPayButton(List<PaymentMethodModel> methods, dynamic transaksi) {
    final sendTransaksi = context.read<TransaksiHelperCubit>();
    final totalTransaksi = getTotalTransaksi(transaksi);

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kOrange,
            padding: const .symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            shadowColor: Colors.orangeAccent.shade100,
          ),
          onPressed: () {
            final selected = methods.firstWhere(
              (m) => m.nama == _selectedMethod,
            );

            //3 ini dpakai buat di transaksi proses
            sendTransaksi.setKodeDompet(selected.kodeDompet ?? "");
            sendTransaksi.setNominalPembayaran((totalTransaksi).toInt());
            sendTransaksi.setEndUserValue(textController.text.trim());

            // Cek saldo cukup atau tidak
            final saldo = selected.saldoEwallet ?? 0;
            if (totalTransaksi > saldo) {
              final msg = saldo <= 0
                  ? "Saldo ${selected.nama} tidak cukup, hubungi CS / admin."
                  : "Saldo ${selected.nama} tidak mencukupi.";
              showErrorDialog(context, msg);
              return;
            }

            // kalo pake metode Speedcash
            if (selected.nama == 'SPEEDCASH') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => KonfirmasiTransaksiSpeedcashCubit(
                          context.read<SpeedcashApiService>(),
                        ),
                      ),
                      BlocProvider(
                        create: (context) => PembayaranTransaksiSpeedcashCubit(
                          context.read<SpeedcashApiService>(),
                        ),
                      ),
                    ],
                    child: KonfirmasiSpeedcashPage(),
                  ),
                ),
              );
              return;
            }

            // kalo cukup saldo, lanjut ke proses transaksi
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/transaksiProses',
              (route) => false,
            );
          },
          child: Text(
            "Selanjutnya",
            style: TextStyle(
              fontSize: kSize16,
              fontWeight: FontWeight.w600,
              color: kWhite,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
