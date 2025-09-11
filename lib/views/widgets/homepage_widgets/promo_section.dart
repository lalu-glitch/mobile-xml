import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../viewmodels/balance_viewmodel.dart';

class PromoSection extends StatelessWidget {
  const PromoSection({required this.balanceVM, super.key});

  final BalanceViewModel balanceVM;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280, // total tinggi section
      child: Stack(
        children: [
          // 👉 Background gradient besar
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.only(
                right: 40,
              ), // lebih lebar dari slider
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.bottomLeft,
                  radius: 1.2,
                  colors: [Colors.orangeAccent, Colors.grey.shade100],
                  stops: const [0.0, 1.0],
                ),

                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
              ),

              // 👉 tambahin child di atas background
              child: Align(
                alignment: Alignment
                    .bottomLeft, // atau Alignment.centerLeft kalau mau di kiri
                child: Container(
                  width: 200,
                  height: 300,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/images/bg-promo.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ),

          // 👉 Konten ditaruh center
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // biar tinggi ikut isi
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        // SLIDE PERTAMA -> teks promosi (pop up awal)
                        return Container(
                          width: 0,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          child: SizedBox(),
                        );
                      }

                      // SLIDE PROMO BERGAMBAR
                      return Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(10),
                              blurRadius: 6,
                              spreadRadius: 1,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 160,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/promo$i.jpg',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Promo Murah Merdeka Merdeka Merdeka $i",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14.sp),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
