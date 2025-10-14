import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/helper/constant_finals.dart';

class InfoAkunShimmer extends StatelessWidget {
  const InfoAkunShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: double.infinity,
            height: kSize64 * 3,
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(
              vertical: kSize16,
              horizontal: kSize16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar shimmer
                Container(
                  width: kSize80,
                  height: kSize80,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),

                SizedBox(width: kSize24),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Baris nama shimmer
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: kSize24,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: kSize16),
                          Container(
                            width: kSize20,
                            height: kSize20,
                            color: Colors.grey,
                          ),
                        ],
                      ),

                      SizedBox(height: kSize8),

                      // Baris ID shimmer
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: kSize18,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: kSize16),
                          Container(
                            width: kSize40,
                            height: kSize18,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // List shimmer
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              vertical: kSize32,
              horizontal: kSize16,
            ),
            itemCount: 5, // jumlah dummy card shimmer
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  height: kSize64,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
