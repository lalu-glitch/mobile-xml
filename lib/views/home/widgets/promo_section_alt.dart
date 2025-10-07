import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/promo_vm.dart';

class PastiPromoSection extends StatelessWidget {
  const PastiPromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final promoVM = context.watch<PromoViewModel>();

    if (promoVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (promoVM.error != null) {
      return Center(child: Text("Terjadi kesalahan: ${promoVM.error}"));
    }

    if (promoVM.promoList.isEmpty) {
      return const Center(child: Text("Belum ada promo tersedia."));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pasti Promo',
          style: TextStyle(
            fontSize: Screen.kSize18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: promoVM.promoList.length,
            itemBuilder: (context, i) {
              final item = promoVM.promoList[i];
              return Container(
                width: 260,
                margin: const EdgeInsets.only(right: 24),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: item.icon ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.image_not_supported),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
