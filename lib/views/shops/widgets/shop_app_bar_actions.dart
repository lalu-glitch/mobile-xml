import 'package:flutter/material.dart';

import '../../../core/utils/bottom_sheet.dart';

class ShopsAppBarActions extends StatelessWidget {
  final bool isSearching;
  final ValueChanged<bool> onSearchChanged;

  const ShopsAppBarActions({
    super.key,
    required this.isSearching,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (isSearching) {
      return IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => onSearchChanged(false),
      );
    } else {
      return Row(
        children: [
          IconButton(
            onPressed: () => onSearchChanged(true),
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            onPressed: () =>
                showCSBottomSheet(context, 'Hubungi Customer Service'),
            icon: const Icon(Icons.headset_mic_rounded),
          ),
        ],
      );
    }
  }
}
