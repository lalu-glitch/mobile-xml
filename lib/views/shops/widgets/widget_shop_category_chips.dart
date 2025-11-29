import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../home/cubit/layanan_cubit.dart';

class ShopsCategoryChips extends StatelessWidget {
  const ShopsCategoryChips({
    required this.cubit,
    required this.selectedHeading,
    required this.onHeadingSelected,
    super.key,
  });

  final LayananCubit cubit;
  final String selectedHeading;
  final ValueChanged<String> onHeadingSelected;

  @override
  Widget build(BuildContext context) {
    final layananByHeading = cubit.layananByHeading;

    if (layananByHeading.isEmpty) {
      return const Center(child: Text("Tidak ada layanan tersedia."));
    }

    final headings = ['Semuanya', ...layananByHeading.keys];
    return Padding(
      padding: const .symmetric(vertical: 16),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: headings.length,
          itemBuilder: (context, index) {
            final heading = headings[index];
            final isSelected = heading == selectedHeading;

            return GestureDetector(
              onTap: () => onHeadingSelected(heading),
              child: Container(
                margin: const .symmetric(horizontal: 8),
                padding: const .symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? kOrange : kNeutral50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    heading,
                    style: TextStyle(
                      color: isSelected ? kWhite : kBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
