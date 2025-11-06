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
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  static buildMainShimmerCard() {
    return Shimmer.fromColors(
      baseColor: kNeutral40,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title shimmer
          Container(
            width: 150,
            height: 20,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          // Balance shimmer
          Container(
            width: double.infinity,
            height: 100,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          // 3 small shimmer boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (index) {
              return Flexible(
                fit: FlexFit.tight,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 20,
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  static buildShimmerIcons() => GridView.builder(
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
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 260,
            margin: const EdgeInsets.only(right: 16),
            child: Shimmer.fromColors(
              baseColor: kNeutral40,
              highlightColor: kNeutral20,
              child: Container(
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static buildShimmerCardPromo() {
    return Shimmer.fromColors(
      baseColor: kNeutral40,
      highlightColor: kNeutral20,
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  static buildShimmerChips() {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 16),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (_, _) => Shimmer.fromColors(
            baseColor: kNeutral40,
            highlightColor: kNeutral20,
            child: Container(
              height: 50,
              width: 150,
              margin: EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static buildShimmerRiwayatTransaksi() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: kNeutral40,
            highlightColor: kNeutral20,
            child: Card(
              color: kWhite,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                title: Container(
                  width: double.infinity,
                  height: 14,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
                subtitle: Container(
                  width: double.infinity,
                  height: 12,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
