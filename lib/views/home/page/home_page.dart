// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xmlapp/views/home/widgets/dompet_card.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/shimmer.dart';
import '../../../viewmodels/balance_viewmodel.dart';
import '../../../viewmodels/icon_viewmodel.dart';
import '../../widgets/promo_popup.dart';
import '../widgets/header.dart';
import '../widgets/layanan_section.dart';
import '../widgets/poin_komisi.dart';
import '../widgets/promo_section.dart';
import '../widgets/promo_section_alt.dart';
import '../widgets/tagihan_lainnya.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final balanceVM = Provider.of<BalanceViewModel>(context, listen: false);
      final iconVM = Provider.of<IconsViewModel>(context, listen: false);
      balanceVM.fetchBalance();
      iconVM.fetchIcons();
      // buat promo
      Future.delayed(const Duration(seconds: 1), () {
        PromoPopup.show(context, "assets/images/promo.jpg");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final balanceVM = Provider.of<BalanceViewModel>(context);
    final iconVM = Provider.of<IconsViewModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background orange
          Container(color: kOrange),
          // Background image di pojok kiri atas
          Positioned(
            top: 35,
            left: 0,
            child: Image.asset(
              'assets/images/bg-header.png',
              width: 300, // sesuaikan ukuran
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          // Konten utama
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),

              child: RefreshIndicator(
                color: kOrange,
                onRefresh: () async {
                  await Future.wait([
                    balanceVM.fetchBalance(),
                    iconVM.fetchIcons(),
                  ]);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // === Header ===
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Header(balanceVM: balanceVM),
                          ),

                          const SizedBox(
                            height: 150,
                          ), // kasih space supaya card muat di overlay
                          Container(
                            decoration: BoxDecoration(color: Colors.grey[100]),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 120),
                                PromoSectionAlt(),
                                const SizedBox(height: 24),
                                iconVM.isLoading
                                    ? ShimmerBox.buildShimmerIcons()
                                    : iconVM.error != null
                                    ? const Center(
                                        child: Text('Gagal memuat icon'),
                                      )
                                    : LayananSection(iconVM: iconVM),
                                const SizedBox(height: 24),

                                const SizedBox(height: 24),
                                TagihanLainnya(),
                              ],
                            ),
                          ),
                        ],
                      ),

                      //Poin dan Komisi
                      PoinKomisi(),

                      // Main Card
                      Positioned(
                        top: 150,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: 240,
                          width: 300,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: SizedBox(
                                    width: size.width * 0.86,
                                    child: DompetCard(balanceVM: balanceVM),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: SizedBox(
                                    width: size.width * 0.85,
                                    child: DompetCard(balanceVM: balanceVM),
                                  ),
                                ),
                                const SizedBox(width: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
