import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xmlapp/core/helper/constant_finals.dart';

class TransactionCard extends StatelessWidget {
  final dynamic transaksi; // model transaksi

  const TransactionCard({super.key, required this.transaksi});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/detailRiwayatTransaksi',
            arguments: {'kode': transaksi.kode},
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leading Icon dalam circle
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _statusColor(transaksi).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _statusIcon(transaksi),
                  color: _statusColor(transaksi),
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),

              // Info transaksi (kiri)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tujuan
                    Text(
                      transaksi.tujuan,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Tanggal
                    Text(
                      DateFormat(
                        'dd MMM yyyy, HH:mm',
                      ).format(transaksi.tglEntri),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Harga + Status chip (kanan)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Status chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(transaksi).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      transaksi.keterangan,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _statusColor(transaksi),
                      ),
                    ),
                  ),
                  // Harga
                  Text(
                    "Rp ${transaksi.harga.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
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
  Color _statusColor(dynamic t) {
    switch (t.status) {
      case 20: // sukses
        return kGreen;
      case 40: // gagal
      case 43: // saldo tidak cukup
      case 47: // produk gangguan
      case 50: // dibatalkan
      case 52: // tujuan salah
      case 53: // luar wilayah
      case 55: // timeout
        return kRed;
      case 1: // belum diproses
      case 2: // sedang diproses
        return kYellow;
      default:
        return kNeutral40;
    }
  }

  /// Mapping icon berdasarkan status
  IconData _statusIcon(dynamic t) {
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
