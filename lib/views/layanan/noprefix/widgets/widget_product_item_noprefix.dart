import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../../../core/helper/currency.dart';
import '../../../../data/models/produk/provider_kartu.dart';

class NoPrefixProductItem extends StatelessWidget {
  const NoPrefixProductItem({
    super.key,
    required this.produk,
    required this.isGangguan,
    required this.isSelected,
  });
  final Produk produk;
  final bool isGangguan;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              ? kOrange
              : kNeutral30,
          width: isGangguan ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isGangguan)
                  Row(
                    children: const [
                      Icon(Icons.cancel, color: kRed, size: 14),
                      SizedBox(width: 4),
                      Text("Gangguan", style: TextStyle(color: kRed)),
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
