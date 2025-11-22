import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';
import '../../settings/cubit/info_akun/info_akun_cubit.dart';
import '../cubit/list_bank_cubit.dart';
import '../widgets/bank_card.dart';
import 'speedcash_topup.dart';

class SpeedcashTopUpPage extends StatefulWidget {
  const SpeedcashTopUpPage({super.key});

  @override
  State<SpeedcashTopUpPage> createState() => _SpeedcashTopUpPageState();
}

class _SpeedcashTopUpPageState extends State<SpeedcashTopUpPage> {
  @override
  void initState() {
    super.initState();
    final infoState = context.read<InfoAkunCubit>().state;
    if (infoState is InfoAkunLoaded) {
      final kodeReseller = infoState.data.data.kodeReseller;
      context.read<SpeedcashBankCubit>().fetchBanks(kodeReseller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text('Speedcash TopUp', style: TextStyle(color: kWhite)),
        backgroundColor: kOrange,
        iconTheme: const IconThemeData(color: kWhite),
      ),
      body: SafeArea(
        child: Padding(
          padding: const .symmetric(vertical: 0, horizontal: 16),
          child: CustomScrollView(
            slivers: [
              BlocBuilder<SpeedcashBankCubit, SpeedcashBankState>(
                builder: (context, state) {
                  if (state is SpeedcashBankLoading) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(color: kOrange),
                      ),
                    );
                  }
                  if (state is SpeedcashBankError) {
                    return SliverFillRemaining(
                      child: Center(child: Text(state.message)),
                    );
                  }
                  if (state is SpeedcashBankLoaded) {
                    final banks = state.dataBank.bank;
                    final virtualAccounts = state.dataBank.va;

                    return SliverList(
                      delegate: SliverChildListDelegate([
                        if (banks.isNotEmpty) ...[
                          const Padding(
                            padding: .only(top: 16.0, bottom: 8.0),
                            child: Text(
                              'Bank',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...banks.map((bank) {
                            return BankCard(
                              title: bank.name,
                              minimumTopUp:
                                  'Min. Top Up ${CurrencyUtil.formatCurrency(double.tryParse(bank.minDeposit) ?? 0)}',
                              imageUrl: bank.image,
                              klik: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SpeedcashTopUp(
                                      imageUrl: bank.image,
                                      title: bank.code,
                                      minimumTopUp: bank.minDeposit,
                                      isBank: true,
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                        if (virtualAccounts.isNotEmpty) ...[
                          const Padding(
                            padding: .only(top: 16.0, bottom: 8.0),
                            child: Text(
                              'Virtual Account',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...virtualAccounts.map((va) {
                            return BankCard(
                              title: va.bank.toUpperCase(),
                              minimumTopUp:
                                  'Biaya admin ${CurrencyUtil.formatCurrency(double.tryParse(va.fee) ?? 0)}',
                              imageUrl: va.image,
                              klik: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SpeedcashTopUp(
                                      imageUrl: va.image,
                                      title: va.bank,
                                      minimumTopUp: va.fee,
                                      isBank: false,
                                      kodeVA: va.vaNumber,
                                      atasNama: va.vaUsername,
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                        if (banks.isEmpty && virtualAccounts.isEmpty)
                          const Padding(
                            padding: .only(top: 32.0),
                            child: Center(
                              child: Text('Tidak ada metode top up tersedia.'),
                            ),
                          ),
                      ]),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
