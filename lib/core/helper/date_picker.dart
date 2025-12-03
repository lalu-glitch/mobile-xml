import 'package:flutter/material.dart';

import 'constant_finals.dart';

class DatePicker extends StatelessWidget {
  final String label;
  final String hint;
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const DatePicker({
    super.key,
    required this.label,
    required this.hint,
    required this.selectedDate,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    // Manual format DD/MM/YYYY agar tidak perlu package intl
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kBlack,
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: kNeutral50)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null ? _formatDate(selectedDate!) : hint,
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedDate != null ? kBlack : kNeutral50,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  color: kGrey,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
