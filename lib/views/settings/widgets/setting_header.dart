import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../cubit/info_akun_cubit.dart';

class SettingHeader extends StatelessWidget {
  final InfoAkunLoaded state;

  const SettingHeader({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: kSize64 * 2,
      color: kOrange,
      padding: EdgeInsets.symmetric(vertical: kSize16, horizontal: kSize16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.person_rounded, color: kBlack, size: 50),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.data.data.nama,
                  style: TextStyle(
                    color: kBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  state.data.data.kodeReseller,
                  style: TextStyle(
                    color: kNeutral80,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18),
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFf4b95a), Color(0xFFba770c)],
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified_rounded, color: kWhite),
                  const SizedBox(width: 16),
                  Text(
                    'Mitra VIP',
                    style: TextStyle(
                      color: kWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Row(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     // Avatar
      //     Container(
      //       width: kSize80,
      //       height: kSize80,
      //       decoration: BoxDecoration(
      //         color: kWhite,
      //         borderRadius: BorderRadius.circular(100),
      //       ),
      //       child: ClipOval(
      //         child: Image.asset('assets/images/pfp.png', fit: BoxFit.cover),
      //       ),
      //     ),

      //     SizedBox(width: kSize24),

      //     Expanded(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           // Baris nama + icon edit
      //           Row(
      //             children: [
      //               Expanded(
      //                 child: Container(
      //                   padding: const EdgeInsets.symmetric(
      //                     horizontal: 12,
      //                     vertical: 6,
      //                   ),
      //                   decoration: BoxDecoration(
      //                     color: kWhite.withAlpha(80),
      //                     borderRadius: BorderRadius.circular(20),
      //                     border: Border.all(color: kWhite.withAlpha(100)),
      //                   ),
      //                   child: Text(
      //                     state.data.data.nama,
      //                     style: TextStyle(
      //                       color: kWhite,
      //                       fontSize: 16,
      //                       fontWeight: FontWeight.w600,
      //                       letterSpacing: 0.5,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //               SizedBox(width: kSize16),
      //               IconButton(
      //                 icon: Icon(Icons.mode_edit_rounded),
      //                 color: kWhite,
      //                 onPressed: () =>
      //                     Navigator.pushNamed(context, '/detailInfoAkun'),
      //               ),
      //             ],
      //           ),

      //           SizedBox(height: kSize8),

      //           // Baris ID + Badge
      //           Row(
      //             children: [
      //               Expanded(
      //                 child: Container(
      //                   padding: const EdgeInsets.symmetric(
      //                     horizontal: 12,
      //                     vertical: 6,
      //                   ),
      //                   decoration: BoxDecoration(
      //                     color: kWhite.withAlpha(80),
      //                     borderRadius: BorderRadius.circular(20),
      //                     border: Border.all(color: kWhite.withAlpha(100)),
      //                   ),
      //                   child: Text(
      //                     state.data.data.kodeReseller,
      //                     style: TextStyle(
      //                       color: kWhite,
      //                       fontWeight: FontWeight.w500,
      //                       letterSpacing: 0.5,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //               SizedBox(width: kSize16),
      //               Expanded(
      //                 child: Container(
      //                   padding: const EdgeInsets.symmetric(
      //                     horizontal: 12,
      //                     vertical: 6,
      //                   ),
      //                   decoration: BoxDecoration(
      //                     color: kWhite.withAlpha(80),
      //                     borderRadius: BorderRadius.circular(20),
      //                     border: Border.all(color: kWhite.withAlpha(100)),
      //                   ),
      //                   child: Text(
      //                     state.data.data.kodeLevel,
      //                     style: TextStyle(
      //                       color: kWhite,
      //                       fontWeight: FontWeight.w500,
      //                       letterSpacing: 0.5,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
