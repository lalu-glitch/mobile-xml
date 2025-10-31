import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'data/services/auth_service.dart';
import 'viewmodels/promo_vm.dart';
import 'views/auth/cubit/request_kode_agen_cubit.dart';
import 'views/layanan/cubit/flow_cubit.dart';
import 'core/routes/app_route.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'data/services/api_service.dart';
import 'data/services/location_service.dart';
import 'data/services/speedcash_api_service.dart';
import 'viewmodels/balance_viewmodel.dart';
import 'viewmodels/layanan_vm.dart';
import 'viewmodels/speedcash/speedcash_viewmodel.dart';
import 'viewmodels/transaksi_viewmodel.dart';
import 'views/input_nomor/utils/transaksi_cubit.dart';
import 'views/layanan/noprefix/cubit/provider_noprefix_cubit.dart';
import 'views/layanan/prefix/cubit/provider_prefix_cubit.dart';
import 'views/riwayat/cubit/riwayat_transaksi_cubit.dart';
import 'views/settings/cubit/info_akun/info_akun_cubit.dart';
import 'views/settings/cubit/wallet/unbind_ewallet_cubit.dart';
import 'views/speedcash/cubit/panduan_topup_cubit.dart';
import 'views/speedcash/cubit/list_bank_cubit.dart';
import 'views/speedcash/cubit/request_topup_cubit.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  // Lock orientasi layar
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const XmlApp());
}

class XmlApp extends StatefulWidget {
  const XmlApp({super.key});

  @override
  State<XmlApp> createState() => _XmlAppState();
}

class _XmlAppState extends State<XmlApp> {
  StreamSubscription<Uri>? _sub;
  late final AppLinks _appLinks;
  bool isAppReady = false; // FIX: Flag untuk track readiness

  @override
  void initState() {
    super.initState();
    _initDeepLinks(); // Tetap di initState, karena non-nav
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // FIX: Defer location setelah frame pertama
      _initLocationService();
      setState(() => isAppReady = true);
    });
  }

  Future<void> _initLocationService() async {
    final locationService = LocationService();
    try {
      await locationService.getCurrentLocation();
    } catch (e) {
      return;
    }
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    try {
      // Initial link kalau app dibuka pertama kali via deeplink
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _navigateFromUri(initialUri);
      }
    } catch (e) {
      debugPrint("Gagal ambil initial uri: $e");
    }

    // Listener kalau app sudah jalan lalu ada deeplink masuk
    _sub = _appLinks.uriLinkStream.listen(
      (uri) {
        _navigateFromUri(uri);
      },
      onError: (err) {
        debugPrint("Error deeplink: $err");
      },
    );
  }

  /// Mapping uri ke route Flutter
  void _navigateFromUri(Uri uri) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String route = '/';
      if (uri.host.isNotEmpty) route = '/${uri.host}';
      if (uri.path.isNotEmpty && uri.path != "/") {
        route = '/${uri.pathSegments.first}';
      }

      debugPrint("Navigate ke: $route, query: ${uri.queryParameters}");

      if (appRoutes.containsKey(route)) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          route,
          (r) => false,
          arguments: uri.queryParameters,
        );
      } else {
        navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (r) => false);
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      //dependency injection
      providers: [
        RepositoryProvider<ApiService>(create: (context) => ApiService()),
        RepositoryProvider<SpeedcashApiService>(
          create: (context) => SpeedcashApiService(),
        ),
        RepositoryProvider<AuthService>(create: (context) => AuthService()),
      ],
      child: MultiBlocProvider(
        providers: [
          //umum
          BlocProvider(
            create: (context) => InfoAkunCubit(context.read<ApiService>()),
          ),
          BlocProvider(
            create: (context) =>
                RequestKodeAgenCubit(context.read<AuthService>()),
          ),
          BlocProvider(
            create: (context) =>
                ProviderNoPrefixCubit(context.read<ApiService>()),
          ),
          BlocProvider(
            create: (context) =>
                ProviderPrefixCubit(context.read<ApiService>()),
          ),
          BlocProvider(
            create: (context) =>
                RiwayatTransaksiCubit(context.read<ApiService>()),
          ),
          BlocProvider(create: (context) => TransaksiHelperCubit()),
          BlocProvider(create: (context) => FlowCubit()),

          //speedcash
          BlocProvider(
            create: (context) =>
                UnbindEwalletCubit(context.read<SpeedcashApiService>()),
          ),
          BlocProvider(
            create: (context) =>
                SpeedcashBankCubit(context.read<SpeedcashApiService>()),
          ),
          BlocProvider(
            create: (context) =>
                PanduanTopUpCubit(context.read<SpeedcashApiService>()),
          ),
          BlocProvider(
            create: (context) =>
                RequestTopUpCubit(context.read<SpeedcashApiService>()),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => BalanceViewModel()),
            ChangeNotifierProvider(create: (_) => LayananViewModel()),
            ChangeNotifierProvider(create: (_) => PromoViewModel()),
            ChangeNotifierProvider(
              create: (context) =>
                  SpeedcashVM(apiService: context.read<SpeedcashApiService>()),
            ),
            ChangeNotifierProvider(
              create: (context) =>
                  TransaksiViewModel(service: context.read<ApiService>()),
            ),
          ],
          child: MaterialApp(
            title: "XML App",
            theme: ThemeData(
              textTheme: Theme.of(
                context,
              ).textTheme.apply(fontFamily: 'Gabarito'),
              fontFamily: 'Gabarito',
              useMaterial3: true,
            ),
            navigatorKey: navigatorKey,
            initialRoute: '/',
            routes: appRoutes,
          ),
        ),
      ),
    );
  }
}
