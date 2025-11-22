import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/error_handler.dart';
import '../../../core/utils/dialog.dart';
import '../../popup/promo_popup.dart';
import '../cubit/balance_cubit.dart';
import '../cubit/layanan_cubit.dart';
import '../cubit/promo_cubit.dart';
import '../widgets/home_header_section.dart';
import '../widgets/home_layanan_section.dart';
import '../widgets/home_promo_section.dart';
import '../widgets/main_saldo_card_carousel.dart';
import '../widgets/poin_komisi_overlay.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLogoutDialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BalanceCubit>().fetchUserBalance();
      context.read<LayananCubit>().fetchLayanan();
      context.read<PromoCubit>().fetchPromo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubitBalance = context.read<BalanceCubit>();
    final cubitLayanan = context.read<LayananCubit>();
    final cubitPromo = context.read<PromoCubit>();

    Future<void> refreshData() async {
      await Future.wait([
        cubitBalance.fetchUserBalance(),
        cubitLayanan.fetchLayanan(),
        cubitPromo.fetchPromo(),
      ]);
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<BalanceCubit, BalanceState>(
          listener: (context, state) async {
            if (state is BalanceLogout && !_isLogoutDialogShown) {
              _isLogoutDialogShown = true;
              await showForceExitDialog(context, () async {
                await const FlutterSecureStorage().deleteAll();
                if (!context.mounted) return;
                context.read<BalanceCubit>().reset();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/authPage',
                  (_) => false,
                );
              });
            }
          },
        ),
        BlocListener<PromoCubit, PromoState>(
          listener: (context, state) {
            if (state is PromoLoaded && !cubitPromo.hasShownPopUp) {
              cubitPromo.hasShownPopUp = true;
              final promos = cubitPromo.promoList;
              final img =
                  promos.firstOrNull?.icon ??
                  'assets/images/fallback_promo.png';

              PromoPopup.show(context, img);
            }
          },
        ),
      ],
      child: WillPopScope(
        onWillPop: () async {
          return await showExitDialog(context);
        },
        child: Scaffold(
          body: Stack(
            children: [
              Container(color: kOrange),
              Positioned(
                top: 35,
                left: 0,
                child: Image.asset(
                  'assets/images/bg_header.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const .only(top: 16.0),

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
                            crossAxisAlignment: .start,
                            children: [
                              Padding(
                                padding: const .symmetric(horizontal: 16),
                                child: HomeHeaderSection(),
                              ),
                              const SizedBox(height: 150),
                              BlocBuilder<LayananCubit, LayananState>(
                                builder: (context, layananState) {
                                  return BlocBuilder<PromoCubit, PromoState>(
                                    builder: (context, promoState) {
                                      if (layananState is LayananInitial ||
                                          promoState is PromoInitial) {
                                        return SizedBox.shrink();
                                      }
                                      if (layananState is LayananError ||
                                          promoState is PromoError) {
                                        return Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: kBackground,
                                          ),
                                          padding: const .all(16),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 120),
                                              SizedBox(
                                                child: ErrorHandler(
                                                  message: 'Ada yang salah',
                                                  onRetry: refreshData,
                                                ),
                                              ),
                                              const SizedBox(height: 120),
                                            ],
                                          ),
                                        );
                                      }
                                      return Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: kBackground,
                                        ),
                                        padding: const .all(16),
                                        child: Column(
                                          crossAxisAlignment: .start,
                                          children: [
                                            const SizedBox(height: 120),
                                            HomePromoSection(),
                                            const SizedBox(height: 24),
                                            HomeLayananSection(),
                                            const SizedBox(height: 120),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          PoinKomisiOverlay(),
                          MainSaldoCardCarousel(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
