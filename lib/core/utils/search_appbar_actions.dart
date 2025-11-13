import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget {
  final bool isSearching;
  final ValueChanged<bool> onSearchChanged;
  final VoidCallback onClear;

  const SearchAppBar({
    super.key,
    required this.isSearching,
    required this.onSearchChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    if (isSearching) {
      return IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          onSearchChanged(false);
          onClear();
        },
      );
    } else {
      return Row(
        children: [
          IconButton(
            onPressed: () => onSearchChanged(true),
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      );
    }
  }
}
