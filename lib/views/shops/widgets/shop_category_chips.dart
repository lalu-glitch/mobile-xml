import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class ShopsCategoryChips extends StatelessWidget {
  const ShopsCategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 35,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Container(
                width: 100,
                height: 35,
                decoration: BoxDecoration(
                  color: kNeutral40,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Chip $index',
                    style: const TextStyle(
                      color: kBlack,
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
