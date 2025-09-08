import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                color: Colors.white, // background putih 1 blok
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

                  return GestureDetector(
                    onTap: () {
                      ///sementara di hardcode dulu kali yaaa
                      final routeName = (i == 0 || i == 1 || i == 3)
                          ? '/detailNoPrefix'
                          : '/detailPrefix';

                      Navigator.pushNamed(
                        context,
                        routeName,
                        arguments: iconItem,
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
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
    ;
  }
}
