// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/dialog.dart';
import '../../../core/utils/shimmer.dart';
import '../../../viewmodels/balance_viewmodel.dart';
import '../../../viewmodels/layanan_vm.dart';
import '../../../viewmodels/promo_vm.dart';
import '../../widgets/promo_popup.dart';
import '../widgets/home_header.dart';
import '../widgets/saldo_card.dart';
import '../widgets/layanan_section.dart';
import '../widgets/poin_komisi.dart';
import '../widgets/promo_section.dart';

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
      final layananVM = Provider.of<LayananViewModel>(context, listen: false);
      final promoVM = Provider.of<PromoViewModel>(context, listen: false);
      balanceVM.fetchBalance();
      layananVM.fetchLayanan();
      promoVM.fetchPromo();
      // buat promo
      Future.delayed(const Duration(seconds: 1), () {
        PromoPopup.show(context, "assets/images/promo.jpg");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final balanceVM = Provider.of<BalanceViewModel>(context);
    final layananVM = Provider.of<LayananViewModel>(context);
    final promoVM = Provider.of<PromoViewModel>(context);
    return WillPopScope(
      onWillPop: () async {
        return await showExitDialog(context);
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background orange
            Container(color: kOrange),
            // Background image di pojok kiri
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
                      layananVM.fetchLayanan(),
                      promoVM.fetchPromo(),
                    ]);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    dragStartBehavior: DragStartBehavior.down,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: HomeHeader(balanceVM: balanceVM),
                            ),
                            const SizedBox(height: 150),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 120),
                                  PastiPromoSection(),
                                  const SizedBox(height: 24),
                                  layananVM.isLoading
                                      ? ShimmerBox.buildShimmerIcons()
                                      : layananVM.error != null
                                      ? const Center(
                                          child: Text('Gagal memuat icon'),
                                        )
                                      : LayananSection(layananVM: layananVM),
                                  const SizedBox(height: 24),

                                  const SizedBox(height: 24),
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
                            height: 220,
                            child: PageView.builder(
                              controller: PageController(viewportFraction: 0.9),
                              padEnds: true,
                              clipBehavior: Clip.none,
                              itemCount: 2, // jumlah card
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: SaldoCard(balanceVM: balanceVM),
                                );
                              },
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
      ),
    );
  }
}
