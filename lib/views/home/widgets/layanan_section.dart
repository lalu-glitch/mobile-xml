import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/dynamic_app_page.dart';

import '../../../data/models/transaksi/transaksi_helper_model.dart';
import '../../../viewmodels/icon_viewmodel.dart';

class LayananSection extends StatelessWidget {
  const LayananSection({required this.iconVM, super.key});

  final IconsViewModel iconVM;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: iconVM.iconsByCategory.entries.map((entry) {
        final doubledList = [...entry.value, ...entry.value];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.key.toUpperCase(),
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: kWhite, // background putih 1 blok
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),

              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                // itemCount: entry.value.length,
                ///test icon banyakan
                itemCount: doubledList.length,

                itemBuilder: (context, i) {
                  // final iconItem = entry.value[i];

                  ///test icon banyakan
                  final iconItem = doubledList[i];

                  final trx = TransaksiModel(
                    tujuan: iconItem.filename,
                    kodeProduk: '',
                    namaProduk: '',
                    total: 0,
                  );
                  return GestureDetector(
                    onTap: () {
                      // Ambil sequence berdasarkan flow
                      final sequence = pageSequences[iconItem.flow] ?? [];
                      if (sequence.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid flow ID: ${iconItem.flow}'),
                          ),
                        );
                        return;
                      }
                      // Navigate ke page pertama dari sequence
                      Navigator.pushNamed(
                        context,
                        pageRoutes[sequence[0]]!,
                        arguments: {
                          'flow': iconItem.flow,
                          'iconItem': iconItem,
                          'currentIndex': 0,
                          'sequence': sequence,
                          'transaksi': trx,
                        },
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.orange.shade200,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              iconItem.url,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.apps,
                                color: Colors.orange.shade200,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Text(
                            iconItem.filename,
                            style: TextStyle(fontSize: 12.sp),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      }).toList(),
    );
  }
}
