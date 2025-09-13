import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant_finals.dart';
import '../../../data/models/user/info_akun.dart';
import '../cubit/info_akun_cubit.dart';
import '../cubit/unbind_ewallet_cubit.dart';
import 'wallet_card.dart';

class WalletSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;
  final List<Ewallet>? ewallets;

  const WalletSection({
    super.key,
    required this.isExpanded,
    required this.onTap,
    required this.ewallets,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tombol expand/collapse
        GestureDetector(
          onTap: onTap,
          child: Card(
            color: kWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(
                Icons.card_membership_sharp,
                color: Colors.orange,
              ),
              title: const Text("Dompet Aplikasi"),
              trailing: AnimatedRotation(
                turns: isExpanded ? 0.25 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(Icons.arrow_forward_ios, size: Screen.kSize18),
              ),
            ),
          ),
        ),

        // List e-wallet
        if (isExpanded)
          SizedBox(
            height: 150,
            child: BlocListener<UnbindEwalletCubit, EwalletState>(
              listener: (context, state) {
                if (state is UnbindSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  context.read<InfoAkunCubit>().getInfoAkun();
                } else if (state is UnbindError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: (ewallets == null || ewallets!.isEmpty)
                  ? const Center(
                      child: Text(
                        'Belum ada dompet',
                        style: TextStyle(color: kNeutral70),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ewallets!.length,
                      itemBuilder: (context, index) {
                        final ewallet = ewallets![index];
                        return WalletCard(ewallet: ewallet);
                      },
                    ),
            ),
          ),
      ],
    );
  }
}
