import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class MitraStatsHeader extends StatelessWidget {
  final int activeCount;
  final int blockedCount;

  const MitraStatsHeader({
    super.key,
    required this.activeCount,
    required this.blockedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 80,
          decoration: const BoxDecoration(
            color: kOrange,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: kBlack.withAlpha(20),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                _buildStatItem(
                  label: 'Aktif',
                  count: activeCount,
                  color: kGreen,
                  icon: Icons.check_circle_outline,
                ),
                const VerticalDivider(
                  color: Color(0xFFEEEEEE),
                  thickness: 1.5,
                  width: 32,
                ),
                _buildStatItem(
                  label: 'Terblokir',
                  count: blockedCount,
                  color: kRed,
                  icon: Icons.block_outlined,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String label,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: kGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class FilterSection extends StatelessWidget {
  final int totalData;
  final String currentSort;
  final ValueChanged<String?> onSortChanged;

  const FilterSection({
    super.key,
    required this.totalData,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total $totalData Mitra',
            style: const TextStyle(
              color: kBlack,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kNeutral30),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentSort,
                icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                style: const TextStyle(fontSize: 13, color: kBlack),
                isDense: true,
                items: ['Terbaru', 'Terlama', 'A-Z'].map((String val) {
                  return DropdownMenuItem(value: val, child: Text(val));
                }).toList(),
                onChanged: onSortChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
