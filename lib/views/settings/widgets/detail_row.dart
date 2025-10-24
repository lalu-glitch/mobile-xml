import 'package:flutter/material.dart';
import '../../../core/helper/constant_finals.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isNavigate;

  DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isNavigate = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isNavigate
          ? () {
              Navigator.pushNamed(
                context,
                '/editInfoAkun',
                arguments: {'label': label, 'value': value},
              );
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: kBlack,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),

            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: kBlack,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            // Flexible(child: Icon(Icons.navigate_next_rounded)),
            isNavigate ? Icon(Icons.navigate_next_rounded) : SizedBox(),
          ],
        ),
      ),
    );
  }
}
