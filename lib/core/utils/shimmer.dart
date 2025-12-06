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

  static Widget buildShimmerChips() {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 16),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: .horizontal,
          itemCount: 3,
          itemBuilder: (_, _) => Shimmer.fromColors(
            baseColor: kNeutral40,
            highlightColor: kNeutral20,
            child: Container(
              height: 50,
              width: 150,
              margin: .only(left: 16),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: .circular(18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildShimmerRiwayatTransaksi() {
    return Padding(
      padding: const .all(16),
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: kNeutral40,
            highlightColor: kNeutral20,
            child: Card(
              color: kWhite,
              margin: const .symmetric(vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: .circular(12)),
              child: ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: .circle,
                  ),
                ),
                title: Container(
                  width: double.infinity,
                  height: 14,
                  color: Colors.white,
                  margin: const .symmetric(vertical: 4),
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

  static Widget buildShimmerSettings() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Shimmer.fromColors(
          baseColor: kNeutral40,
          highlightColor: kNeutral20,
          child: Container(
            width: double.infinity,
            height: kSize64 * 3,
            color: Colors.transparent,
            padding: .symmetric(vertical: kSize16, horizontal: kSize16),
            child: Row(
              crossAxisAlignment: .center,
              children: [
                // Avatar shimmer
                Container(
                  width: kSize80,
                  height: kSize80,
                  decoration: BoxDecoration(
                    color: kNeutral40,
                    borderRadius: .circular(100),
                  ),
                ),

                SizedBox(width: kSize24),

                Expanded(
                  child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .start,
                    mainAxisSize: .min,
                    children: [
                      // Baris nama shimmer
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: kSize24,
                              decoration: BoxDecoration(
                                color: kNeutral40,
                                borderRadius: .circular(25),
                              ),
                            ),
                          ),
                          SizedBox(width: kSize16),
                          Container(
                            width: kSize20,
                            height: kSize20,
                            decoration: BoxDecoration(
                              color: kNeutral40,
                              borderRadius: .circular(25),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: kSize8),

                      // Baris ID shimmer
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: kSize18,
                              decoration: BoxDecoration(
                                color: kNeutral40,
                                borderRadius: .circular(25),
                              ),
                            ),
                          ),
                          SizedBox(width: kSize16),
                          Container(
                            width: kSize40,
                            height: kSize18,
                            decoration: BoxDecoration(
                              color: kNeutral40,
                              borderRadius: .circular(100),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const .symmetric(horizontal: 16),
          child: Shimmer.fromColors(
            baseColor: kNeutral40,
            highlightColor: kNeutral20,
            child: Container(
              width: double.infinity,
              height: kSize64 * 2,
              decoration: BoxDecoration(
                color: kNeutral40,
                borderRadius: .circular(12),
              ),
            ),
          ),
        ),

        SizedBox(height: kSize32),

        Padding(
          padding: const .symmetric(horizontal: 16),
          child: Shimmer.fromColors(
            baseColor: kNeutral40,
            highlightColor: kNeutral20,
            child: Container(
              width: kSize100,
              height: kSize20,
              decoration: BoxDecoration(
                color: kNeutral40,
                borderRadius: .circular(12),
              ),
            ),
          ),
        ),
        // List shimmer
        Expanded(
          child: ListView.builder(
            padding: .symmetric(vertical: kSize32, horizontal: kSize16),
            itemCount: 5, // jumlah dummy card shimmer
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: kNeutral40,
                highlightColor: kNeutral20,
                child: Container(
                  margin: const .only(bottom: 12),
                  height: kSize64,
                  decoration: BoxDecoration(
                    color: kNeutral40,
                    borderRadius: .circular(12),
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
