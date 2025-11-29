import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/helper/auth_guard.dart';
import '../../../core/helper/constant_finals.dart';
import '../../../data/services/api_service.dart';
import '../cubit/detail_riwayat_transaksi_cubit.dart';
import '../pages/detail_riwayat_page.dart';

class TransactionCard extends StatelessWidget {
  final dynamic t; // model transaksi

  const TransactionCard({super.key, required this.t});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const .only(top: 14, bottom: 4),
      color: kWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              //scoped provider
              builder: (context) => BlocProvider(
                create: (context) =>
                    DetailRiwayatTransaksiCubit(context.read<ApiService>()),
                child: AuthGuard(child: DetailRiwayatPage(kode: t.kode)),
              ),
            ),
          );
        },
        child: Padding(
          padding: const .symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              // Leading Icon dalam circle
              Container(
                padding: const .all(10),
                decoration: BoxDecoration(
                  color: _statusColor(t).withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(_statusIcon(t), color: _statusColor(t), size: 28),
              ),
              const SizedBox(width: 14),

              // Info transaksi (kiri)
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    // Tujuan
                    Text(
                      t.tujuan,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: kBlack,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Tanggal
                    Text(
                      DateFormat('dd MMM yyyy, HH:mm').format(t.tglEntri),
                      style: const TextStyle(fontSize: 13, color: kNeutral90),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Harga + Status chip (kanan)
              Column(
                crossAxisAlignment: .end,
                children: [
                  // Status chip
                  Container(
                    padding: const .symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(t).withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      t.keterangan,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _statusColor(t),
                      ),
                    ),
                  ),
                  // Harga
                  Text(
                    "Rp ${t.harga.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: kBlack,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Mapping warna berdasarkan status
  static Color _statusColor(dynamic t) {
    switch (t.status) {
      case 20: // sukses
        return kGreen;
      case 40: // gagal
      case 43: // saldo tidak cukup
      case 45: // sotk kosong
      case 47: // produk gangguan
      case 50: // dibatalkan
      case 52: // tujuan salah
      case 53: // luar wilayah
      case 55: // timeout
      case 56: // nomor blacklist
      case 58: // nomor tidak aktif
        return kRed;
      case 0: // menunggu jawaban
      case 1: // belum diproses
      case 2: // sedang proses
      case 4: // sedang proses
        return kYellow;
      default:
        return kNeutral90;
    }
  }

  /// Mapping icon berdasarkan status
  static IconData _statusIcon(dynamic t) {
    switch (t.status) {
      case 20: // sukses
        return Icons.check_circle;
      case 40: // gagal
      case 43: // saldo tidak cukup
      case 47: // produk gangguan
      case 50: // dibatalkan
      case 52: // tujuan salah
      case 53: // luar wilayah
      case 55: // timeout
        return Icons.error;
      case 1: // belum diproses
      case 2: // sedang diproses
        return Icons.hourglass_top;
      default:
        return Icons.info;
    }
  }
}
