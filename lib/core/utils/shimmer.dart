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
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
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

  static buildShimmerIcons() => GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
    ),
    itemCount: 8,
    itemBuilder: (_, __) => Column(
      children: [
        Expanded(
          child: ShimmerBox(width: double.infinity, height: 60, radius: 12),
        ),
        const SizedBox(height: 6),
        ShimmerBox(width: 40, height: 10, radius: 4),
      ],
    ),
  );
}
