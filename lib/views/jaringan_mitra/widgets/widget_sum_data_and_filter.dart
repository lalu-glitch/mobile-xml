import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class DataListHeader extends StatelessWidget {
  final int totalData;
  final String selectedSortOption;
  final ValueChanged<String?> onSortChanged;

  // Opsi Dropdown yang tersedia
  final List<String> sortOptions = const ['Terbaru', 'Terlama', 'Nama (A-Z)'];

  const DataListHeader({
    super.key,
    required this.totalData,
    required this.selectedSortOption,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(horizontal: kSize16, vertical: 20),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          // Teks "Menampilkan 48 data"
          Text(
            'Menampilkan $totalData data',
            style: const TextStyle(fontSize: 14, fontWeight: .w600),
          ),

          // Dropdown Urutkan
          Container(
            padding: const .symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: kNeutral50),
              borderRadius: .circular(16),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedSortOption,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: sortOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: onSortChanged,
                hint: const Row(
                  children: [
                    Icon(Icons.swap_vert),
                    SizedBox(width: 5),
                    Text('Urutkan'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
