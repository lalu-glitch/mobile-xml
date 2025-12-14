import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../helper/constant_finals.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kNeutral40,
      highlightColor: kNeutral20,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: .circular(radius),
        ),
      ),
    );
  }

  static Widget dMainShimmerWallet() {
    return Shimmer.fromColors(
      baseColor: kNeutral40,
      highlightColor: kNeutral20,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          // Title shimmer
          Container(
            width: 150,
            height: 20,
            margin: const .only(bottom: 12),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: .circular(8),
            ),
          ),

          // Balance shimmer
          Container(
            width: double.infinity,
            height: 150,
            margin: const .only(bottom: 12),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: .circular(12),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildShimmerIcons() => GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
    ),
    itemCount: 8,
    itemBuilder: (_, _) => Column(
      children: [
        Expanded(
          child: ShimmerBox(width: double.infinity, height: 60, radius: 12),
        ),
        const SizedBox(height: 6),
        ShimmerBox(width: 40, height: 10, radius: 4),
      ],
    ),
  );

  static Widget buildShimmerPromoList() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        SizedBox(
          height: 20,
          width: 100,
          child: Shimmer.fromColors(
            baseColor: kNeutral40,
            highlightColor: kNeutral20,
            child: Container(
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: .circular(18),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: .horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 260,
                margin: const .only(right: 16),
                child: Shimmer.fromColors(
                  baseColor: kNeutral40,
                  highlightColor: kNeutral20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: .circular(18),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static Widget buildShimmerCardPromo() {
    return Shimmer.fromColors(
      baseColor: kNeutral40,
      highlightColor: kNeutral20,
      child: Container(
        width: 260,
        decoration: BoxDecoration(color: kWhite, borderRadius: .circular(18)),
      ),
    );
  }
}
