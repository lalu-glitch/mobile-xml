import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constant_finals.dart';

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
            height: Screen.kSize64 * 3,
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(
              vertical: Screen.kSize16,
              horizontal: Screen.kSize16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar shimmer
                Container(
                  width: Screen.kSize80,
                  height: Screen.kSize80,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),

                SizedBox(width: Screen.kSize24),

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
                              height: Screen.kSize24,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: Screen.kSize16),
                          Container(
                            width: Screen.kSize20,
                            height: Screen.kSize20,
                            color: Colors.grey,
                          ),
                        ],
                      ),

                      SizedBox(height: Screen.kSize8),

                      // Baris ID shimmer
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: Screen.kSize18,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: Screen.kSize16),
                          Container(
                            width: Screen.kSize40,
                            height: Screen.kSize18,
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
              vertical: Screen.kSize32,
              horizontal: Screen.kSize16,
            ),
            itemCount: 5, // jumlah dummy card shimmer
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  height: Screen.kSize64,
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
