import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../cubit/info_akun_cubit.dart';

class Header extends StatelessWidget {
  final InfoAkunLoaded state;

  const Header({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Screen.kSize64 * 3,
      color: kOrange,
      padding: EdgeInsets.symmetric(
        vertical: Screen.kSize16,
        horizontal: Screen.kSize16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            width: Screen.kSize80,
            height: Screen.kSize80,
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(100),
            ),
            child: ClipOval(
              child: Image.asset('assets/images/pfp.png', fit: BoxFit.cover),
            ),
          ),

          SizedBox(width: Screen.kSize24),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Baris nama + icon edit
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: kWhite.withAlpha(80),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: kWhite.withAlpha(100)),
                        ),
                        child: Text(
                          state.data.data.nama,
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: Screen.kSize16),
                    IconButton(
                      icon: Icon(Icons.mode_edit_rounded),
                      color: kWhite,
                      onPressed: () =>
                          Navigator.pushNamed(context, '/detailInfoAkun'),
                    ),
                  ],
                ),

                SizedBox(height: Screen.kSize8),

                // Baris ID + Badge
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: kWhite.withAlpha(80),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: kWhite.withAlpha(100)),
                        ),
                        child: Text(
                          state.data.data.kodeReseller,
                          style: TextStyle(
                            color: kWhite,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: Screen.kSize16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: kWhite.withAlpha(80),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: kWhite.withAlpha(100)),
                        ),
                        child: Text(
                          state.data.data.kodeLevel,
                          style: TextStyle(
                            color: kWhite,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
