import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../viewmodels/layanan_vm.dart';

class ShopsCategoryChips extends StatefulWidget {
  const ShopsCategoryChips({
    required this.layananVM,
    required this.selectedHeading,
    required this.onHeadingSelected,
    super.key,
  });

  final LayananViewModel layananVM;
  final String selectedHeading;
  final ValueChanged<String> onHeadingSelected;

  @override
  State<ShopsCategoryChips> createState() => _ShopsCategoryChipsState();
}

class _ShopsCategoryChipsState extends State<ShopsCategoryChips> {
  @override
  Widget build(BuildContext context) {
    if (widget.layananVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.layananVM.error != null) {
      return Center(
        child: Text("Terjadi kesalahan: ${widget.layananVM.error}"),
      );
    }

    if (widget.layananVM.layananByHeading.isEmpty) {
      return const Center(child: Text("Tidak ada layanan tersedia."));
    }

    // opsi "Semuanya"
    final headings = ['Semuanya', ...widget.layananVM.layananByHeading.keys];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: headings.length,
          itemBuilder: (context, index) {
            final heading = headings[index];
            final isSelected = heading == widget.selectedHeading;

            return GestureDetector(
              onTap: () => widget.onHeadingSelected(heading),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
