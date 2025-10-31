// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/dialog.dart';
import '../../../core/utils/shimmer.dart';
import '../../../viewmodels/balance_viewmodel.dart';
import '../../../viewmodels/layanan_vm.dart';
import '../../../viewmodels/promo_vm.dart';
import '../../popup/promo_popup.dart';
import 'error_handler.dart';
import '../widgets/home_header_section.dart';
import '../widgets/home_layanan_section.dart';
import '../widgets/main_saldo_card_carousel.dart';
import '../widgets/poin_komisi_overlay.dart';
import '../widgets/home_promo_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isForceLogoutDialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BalanceViewModel>(context, listen: false).fetchBalance();
      Provider.of<LayananViewModel>(context, listen: false).fetchLayanan();
      Provider.of<PromoViewModel>(context, listen: false).fetchPromo();

      // buat promo
      Future.delayed(const Duration(seconds: 1), () {
        PromoPopup.show(context, "assets/images/promo.jpg");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _storage = const FlutterSecureStorage();
    final balanceVM = Provider.of<BalanceViewModel>(context);
    final layananVM = Provider.of<LayananViewModel>(context);
    final promoVM = Provider.of<PromoViewModel>(context);

    Future<void> logout() async {
      await _storage.deleteAll();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/authPage',
          (route) => false,
        );
      }
    }

    if (balanceVM.userBalance?.isLogout == true && !_isForceLogoutDialogShown) {
      _isForceLogoutDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showForceExitDialog(context, logout);
      });
    }

    // Fungsi gabungan untuk refresh dan retry
    Future<void> refreshData() async {
      await Future.wait([
        balanceVM.fetchBalance(),
        layananVM.fetchLayanan(),
        promoVM.fetchPromo(),
      ]);
    }

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
                  onRefresh: refreshData,
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
                              child: HomeHeaderSection(balanceVM: balanceVM),
                            ),
                            const SizedBox(height: 150),
                            Container(
                              decoration: BoxDecoration(color: kBackground),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 100),
                                  // Cek error
                                  if (layananVM.error != null ||
                                      promoVM.error != null)
                                    ErrorHandler(
                                      error: layananVM.error ?? promoVM.error,
                                      onRetry: refreshData,
                                    )
                                  else
                                    Column(
                                      children: [
                                        promoVM.isLoading
                                            ? ShimmerBox.buildShimmerPromoList()
                                            : const HomePromoSection(),
                                        const SizedBox(height: 24),
                                        HomeLayananSection(
                                          layananVM: layananVM,
                                        ),
                                        const SizedBox(height: 24),
                                      ],
                                    ),
                                  SizedBox(height: 300),
                                ],
                              ),
                            ),
                          ],
                        ),

                        //Poin dan Komisi
                        PoinKomisiOverlay(),

                        // Main Card
                        MainSaldoCardCarousel(balanceVM: balanceVM),
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
