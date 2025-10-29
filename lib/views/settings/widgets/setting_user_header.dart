import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../cubit/info_akun/info_akun_cubit.dart';

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
      child: UserProfileCard(state: state),
    );
  }
}

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key, required this.state, this.color = kWhite});

  final InfoAkunLoaded state;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person_rounded,
            color: color == kOrange ? kWhite : kBlack,
            size: 50,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.data.data.nama,
                  style: TextStyle(
                    color: color == kOrange ? kWhite : kBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  state.data.data.kodeReseller,
                  style: TextStyle(
                    color: color == kOrange ? kWhite : kBlack,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFf4b95a), Color(0xFFba770c)],
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: const [
                Icon(Icons.verified_rounded, color: kWhite),
                const SizedBox(width: 16),
                Text(
                  'Mitra VVIP',
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
    );
  }
}
