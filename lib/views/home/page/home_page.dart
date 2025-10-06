// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xmlapp/views/home/widgets/new_header_card.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/shimmer.dart';
import '../../../viewmodels/balance_viewmodel.dart';
import '../../../viewmodels/icon_viewmodel.dart';
import '../../widgets/promo_popup.dart';
import '../widgets/header.dart';
import '../widgets/layanan_section.dart';
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
                                PromoSection(balanceVM: balanceVM),
                                const SizedBox(height: 24),
                                iconVM.isLoading
                                    ? ShimmerBox.buildShimmerIcons()
                                    : iconVM.error != null
                                    ? const Center(
                                        child: Text('Gagal memuat icon'),
                                      )
                                    : LayananSection(iconVM: iconVM),
                                const SizedBox(height: 24),
                                PromoSectionAlt(),
                                const SizedBox(height: 24),
                                TagihanLainnya(),
                              ],
                            ),
                          ),
                        ],
                      ),

                      //Tambahan
                      Positioned(
                        top: 110,
                        left: 25,
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Poin',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: kWhite,
                                      ),
                                    ),
                                    Text(
                                      '500.200',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: kWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: 30),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Komisi',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: kWhite,
                                      ),
                                    ),
                                    Text(
                                      '1.800.200',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: kWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top:
                            150, // atur biar card nempel di antara header & container
                        left: 16,
                        right: 16,
                        child: NewHeaderCard(balanceVM: balanceVM),
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
