import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../cubit/panduan_topup_cubit.dart';

class PanduanSection extends StatelessWidget {
  const PanduanSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PanduanTopUpCubit, PanduanTopUpState>(
      builder: (context, state) {
        if (state is PanduanTopUpLoading) {
          return const Center(child: CircularProgressIndicator(color: kOrange));
        }
        if (state is PanduanTopError) return const SizedBox.shrink();
        if (state is PanduanTopUpLoaded) {
          final panduanList = state.data.data;
          if (panduanList.isEmpty) {
            return const Center(
              child: Text(
                "Panduan belum tersedia.",
                style: TextStyle(color: kNeutral70),
              ),
            );
          }
          return ListView.builder(
            itemCount: panduanList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) {
              final p = panduanList[i];
              return Card(
                color: kNeutral30,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                child: ExpansionTile(
                  title: Text(
                    p.label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: kNeutral100,
                    ),
                  ),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 18),
                  childrenPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  shape: const Border(),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        p.data.length,
                        (x) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text("${x + 1}. ${p.data[x]}"),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
