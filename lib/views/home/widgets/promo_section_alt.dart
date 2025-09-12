import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant_finals.dart';

class PromoSectionAlt extends StatelessWidget {
  const PromoSectionAlt({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PASTI PROMO 2',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160, // lebih rendah biar landscape
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, i) => Container(
              width: 260, // lebih lebar dari sebelumnya
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: kWhite,
                // borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/promo_bwh${i + 1}.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Promo Murah Murah Murah Murah Murah Murah Merdeka ${i + 1}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp),
                      maxLines: 1, // batas baris
                      overflow: TextOverflow.ellipsis, // kasih ...
                      softWrap: false, // biar ga pindah baris
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
