import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../../../core/helper/currency.dart';
import '../../../../data/models/produk/provider_kartu.dart';

class PrefixProductItem extends StatelessWidget {
  const PrefixProductItem({
    super.key,
    required this.produk,
    required this.isSelected,
    required this.isGangguan,
  });

  final Produk produk;
  final bool isSelected;
  final bool isGangguan;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isGangguan
            ? kNeutral20
            : isSelected
            ? kOrange
            : kWhite,
        border: Border.all(
          color: isGangguan
              ? kRed
              : isSelected
              ? Colors.deepOrange
              : Colors.grey.shade300,
          width: isGangguan ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nama produk
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isGangguan)
                  Row(
                    children: [
                      const Icon(Icons.cancel, color: kRed, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        "Gangguan",
                        style: TextStyle(color: kRed, fontSize: kSize12),
                      ),
                    ],
                  ),
                Text(
                  produk.namaProduk,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isGangguan
                        ? kRed
                        : isSelected
                        ? kWhite
                        : kBlack,
                  ),
                ),
                Text(
                  produk.kodeProduk,
                  style: TextStyle(
                    color: isGangguan
                        ? kRed
                        : isSelected
                        ? kWhite
                        : kBlack,
                  ),
                ),
              ],
            ),
          ),

          // Harga
          Text(
            CurrencyUtil.formatCurrency(produk.hargaJual),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isGangguan
                  ? kRed
                  : isSelected
                  ? kWhite
                  : kBlack,
            ),
          ),
        ],
      ),
    );
  }
}
