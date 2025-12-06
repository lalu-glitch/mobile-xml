import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'data/services/auth_service.dart';
import 'data/services/websocket_service.dart';
import 'views/auth/cubit/login_cubit.dart';
import 'views/auth/cubit/register_cubit.dart';
import 'views/auth/cubit/request_kode_agen_cubit.dart';
import 'views/home/cubit/balance_cubit.dart';
import 'views/home/cubit/layanan_cubit.dart';
import 'views/home/cubit/promo_cubit.dart';
import 'views/kyc/utils/cubit/kyc_helper_cubit.dart';
import 'views/layanan/cubit/flow_cubit.dart';
import 'core/routes/app_route.dart';
import 'data/services/api_service.dart';
import 'data/services/location_service.dart';
import 'data/services/speedcash_api_service.dart';
import 'views/input_nomor/utils/transaksi_helper_cubit.dart';
import 'views/layanan/noprefix/cubit/provider_noprefix_cubit.dart';
import 'views/layanan/prefix/cubit/provider_prefix_cubit.dart';
import 'views/riwayat/cubit/riwayat_transaksi_cubit.dart';
import 'views/settings/cubit/info_akun/info_akun_cubit.dart';
import 'views/settings/cubit/wallet/unbind_ewallet_cubit.dart';
import 'views/speedcash/cubit/panduan_topup_cubit.dart';
import 'views/speedcash/cubit/list_bank_cubit.dart';
import 'views/speedcash/cubit/request_topup_cubit.dart';
import 'views/transaksi/cubit/transaksi_omni/transaksi_omni_cubit.dart';
import 'views/transaksi/cubit/transaksi_websocket/websocket_cektransaksi_cubit.dart';
import 'views/transaksi/cubit/transaksi_websocket/websocket_transaksi_cubit.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  // Lock orientasi layar
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  //idk if this code is necessary or not, but ima put it here.. just in case.
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024;
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
  bool isAppReady = false;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
        RepositoryProvider<WebSocketService>(
          create: (context) => WebSocketService(AuthService()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          //auth
          BlocProvider(
            create: (context) => LoginCubit(context.read<AuthService>()),
          ),
          BlocProvider(
            create: (context) => RegisterCubit(context.read<AuthService>()),
          ),

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

          //dipakai di home
          BlocProvider(
            create: (context) => BalanceCubit(context.read<ApiService>()),
          ),
          BlocProvider(
            create: (context) => LayananCubit(context.read<ApiService>()),
          ),
          BlocProvider(
            create: (context) => PromoCubit(context.read<ApiService>()),
          ),

          //helper
          BlocProvider(create: (context) => TransaksiHelperCubit()),
          BlocProvider(create: (context) => FlowCubit()),
          BlocProvider(create: (context) => KYCHelperCubit()),

          //transaksi web socket
          BlocProvider(
            create: (context) =>
                WebsocketTransaksiCubit(context.read<WebSocketService>()),
          ),
          BlocProvider(
            create: (context) =>
                WebSocketCekTransaksiCubit(context.read<WebSocketService>()),
          ),

          //transaksi omni
          BlocProvider(create: (context) => TransaksiOmniCubit()),

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
    );
  }
}
