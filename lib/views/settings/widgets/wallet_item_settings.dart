import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/bottom_sheet.dart';
import '../../../data/models/user/info_akun.dart';
import '../cubit/info_akun/info_akun_cubit.dart';
import '../cubit/wallet/unbind_ewallet_cubit.dart';

class WalletItem extends StatelessWidget {
  // Sekarang widget ini hanya berurusan dengan satu objek Ewallet
  final Ewallet ewallet;
  const WalletItem({required this.ewallet, super.key});

  // Widget bantu untuk merapikan kode button (Anda bisa letakkan di luar kelas atau di file terpisah)
  Widget _buildButton(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String kodeReseller = '';

    final cubit = context.read<InfoAkunCubit>();
    final cubitState = context.read<InfoAkunCubit>().state;
    if (cubitState is InfoAkunLoaded) {
      kodeReseller = cubitState.data.data.kodeReseller;
    }
    return BlocConsumer<UnbindEwalletCubit, EwalletState>(
      listener: (context, state) {
        if (state is UnbindSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          cubit.getInfoAkun();
        } else if (state is UnbindError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final int binding = ewallet.binding;
        final String kodeDompet = ewallet.kodeDompet;
        final String iconUrl = ewallet.icon;

        // Cek status loading untuk ewallet ini
        bool isUnbinding = (state is UnbindLoading && state.kode == kodeDompet);

        return Container(
          margin: const .only(right: 16),
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: kOrange, width: 3.5),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const .symmetric(vertical: 12, horizontal: 16),
            child: Column(
              mainAxisSize: .min,
              mainAxisAlignment: .center,
              children: [
                // Ganti Image.network dengan CachedNetworkImage
                Flexible(
                  child: CachedNetworkImage(
                    imageUrl: iconUrl,
                    width: 150, // Ukuran ikon
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error_outline),
                  ),
                ),
                const SizedBox(height: 8),

                // Tampilkan loading saat proses unbind
                if (isUnbinding)
                  const Center(
                    child: CircularProgressIndicator(),
                  ) //will change to shimmer
                else if (binding == 0)
                  _buildButton(
                    'Belum Terbinding',
                    kBlue, // Ganti kNeutral60 dengan warna aman jika kodenya tidak ada
                    () {
                      Navigator.pushNamed(context, '/speedcashBindingPage');
                    },
                  )
                else
                  _buildButton('Unbinding', kRed, () {
                    showUnbindBottomSheet(
                      context,
                      () => context.read<UnbindEwalletCubit>().unbindSpeedcash(
                        kodeReseller,
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
}
