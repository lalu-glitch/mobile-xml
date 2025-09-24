// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:xmlapp/views/input_nomor/transaksi_cubit.dart';
import '../../core/helper/constant_finals.dart';
import '../../core/helper/currency.dart';
import '../../core/utils/error_dialog.dart';
import '../../data/models/transaksi/ewallet_model.dart';
import '../../viewmodels/balance_viewmodel.dart';
import '../../viewmodels/transaksi_viewmodel.dart';

class KonfirmasiPembayaranPage extends StatefulWidget {
  const KonfirmasiPembayaranPage({super.key});

  @override
  State<KonfirmasiPembayaranPage> createState() =>
      _KonfirmasiPembayaranPageState();
}

class _KonfirmasiPembayaranPageState extends State<KonfirmasiPembayaranPage> {
  final logger = Logger();
  String _selectedMethod = "SALDO"; // Default pilihan

  @override
  Widget build(BuildContext context) {
    final balanceVM = Provider.of<BalanceViewModel>(context);
    final transaksi = context.read<TransaksiCubit>().getData();

    final methods = _generatePaymentMethods(balanceVM);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Konfirmasi', style: TextStyle(color: kWhite)),
          backgroundColor: kOrange,
          iconTheme: const IconThemeData(color: kWhite),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildInfoCard(transaksi),
              const SizedBox(height: 24),

              // === Metode Pembayaran ===
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "METODE PEMBAYARAN",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Screen.kSize14,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Column(
                children: methods
                    .map((m) => _paymentOption(m, _selectedMethod == m.nama))
                    .toList(),
              ),

              const Spacer(),

              // === Tombol Bayar ===
              _buildPayButton(methods, transaksi),
            ],
          ),
        ),
      ),
    );
  }

  /// Generate daftar metode pembayaran
  List<PaymentMethod> _generatePaymentMethods(BalanceViewModel balanceVM) {
    final saldo = balanceVM.userBalance?.saldo ?? 0;
    final eWallets = balanceVM.userBalance?.ewallet ?? [];

    final methods = <PaymentMethod>[
      PaymentMethod(nama: "SALDO", kodeDompet: "", saldoEwallet: saldo),
      ...eWallets.map(
        (ew) => PaymentMethod(
          nama: ew.nama,
          kodeDompet: ew.kodeDompet,
          saldoEwallet: ew.saldoEwallet,
        ),
      ),
    ];
    return methods;
  }

  /// Card informasi transaksi
  Widget _buildInfoCard(dynamic transaksi) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _infoRow("Nomor Tujuan", transaksi.tujuan ?? ''),
            const Divider(height: 24),
            _infoRow("Kode Produk", transaksi.kodeProduk ?? ''),
            const Divider(height: 24),
            _infoRow("Nama Produk", transaksi.namaProduk ?? ''),
            const Divider(height: 24),
            _infoRow(
              "Total Pembayaran",
              CurrencyUtil.formatCurrency(transaksi.total),
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  /// Option pilihan metode pembayaran
  Widget _paymentOption(PaymentMethod method, bool isSelected) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() => _selectedMethod = method.nama ?? '');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                method.nama ?? '-',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Screen.kSize16,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (method.saldoEwallet != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
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
  Widget _buildPayButton(List<PaymentMethod> methods, dynamic transaksi) {
    final sendTransaksi = context.read<TransaksiCubit>();

    return SizedBox(
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
          final selected = methods.firstWhere((m) => m.nama == _selectedMethod);

          sendTransaksi.setKodeDompet(selected.kodeDompet!);

          // case khusus SPEEDCASH → buka WebView
          if (selected.nama == 'SPEEDCASH') {
            Navigator.pushNamed(
              context,
              '/webView',
              arguments: {
                'url': 'google.com', // <--- menyusul
                'title': 'Bayar Speedcash',
              },
            );
            return;
          }

          final saldo = selected.saldoEwallet ?? 0;
          final total = transaksi.total ?? 0;

          if (total > saldo) {
            final msg = saldo <= 0
                ? "Saldo ${selected.nama} minus, hubungi CS / admin."
                : "Saldo ${selected.nama} tidak mencukupi.";
            showErrorDialog(context, msg);
          } else {
            context
                .read<TransaksiViewModel>()
                .reset(); // <-- Reset ViewModel dulu untuk bersihkan state lama
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/transaksiProses',
              (route) => false,
            );
          }
        },
        child: Text(
          "SELANJUTNYA",
          style: TextStyle(
            fontSize: Screen.kSize16,
            fontWeight: FontWeight.bold,
            color: kWhite,
          ),
        ),
      ),
    );
  }

  /// Widget helper untuk row informasi produk
  Widget _infoRow(String label, String value, {bool isTotal = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.right,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? Screen.kSize16 : Screen.kSize14,
              color: isTotal ? kOrange : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
