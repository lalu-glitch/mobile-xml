import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../data/services/api_service.dart';
import '../../../data/services/speedcash_api_service.dart';
import '../../../main.dart';
import '../../../viewmodels/balance_viewmodel.dart';
import '../../../viewmodels/icon_viewmodel.dart';
import '../../../viewmodels/provider_kartu_viewmodel.dart';
import '../../../viewmodels/riwayat_viewmodel.dart';
import '../../../views/settings/cubit/info_akun_cubit.dart';
import '../../../views/settings/cubit/unbind_ewallet_cubit.dart';
import '../../../viewmodels/speedcash/speedcash_viewmodel.dart';
import '../../../viewmodels/transaksi_viewmodel.dart';

class AppProviders {
  static Widget build() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UnbindEwalletCubit(apiService: SpeedcashApiService()),
        ),
        BlocProvider(create: (context) => InfoAkunCubit(ApiService())),
      ],
      child: MultiProvider(
        // <---- vanilla provider
        providers: [
          ChangeNotifierProvider(create: (_) => BalanceViewModel()),
          ChangeNotifierProvider(create: (_) => IconsViewModel()),
          ChangeNotifierProvider(create: (_) => ProviderViewModel()),

          ChangeNotifierProvider(create: (_) => RiwayatTransaksiViewModel()),
          ChangeNotifierProvider(
            create: (_) => SpeedcashVM(apiService: SpeedcashApiService()),
          ),
          ChangeNotifierProvider(
            create: (_) => TransaksiViewModel(service: ApiService()),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(
            500,
            844,
          ), // ukuran desain referensi (misal iPhone 12)
          minTextAdapt: true,
          builder: (context, child) {
            return const XmlApp();
          },
        ),
      ),
    );
  }
}
