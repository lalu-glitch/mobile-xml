import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/shimmer.dart';
import '../cubit/promo_cubit.dart';
import 'widget_promo_card.dart';

class HomePromoSection extends StatelessWidget {
  const HomePromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PromoCubit>();

    return BlocBuilder<PromoCubit, PromoState>(
      buildWhen: (previous, current) =>
          current is PromoLoaded || current is PromoLoading,
      builder: (context, state) {
        if (state is PromoLoading) {
          return ShimmerBox.buildShimmerPromoList();
        }
        if (state is PromoLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: .symmetric(horizontal: 16.0),
                child: Text(
                  'Pasti Promo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: .horizontal,
                  itemCount: cubit.promoList.length,
                  itemBuilder: (context, i) {
                    return PromoCard(item: cubit.promoList[i]);
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
