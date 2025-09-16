import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:xmlapp/data/services/api_service.dart';
import 'package:xmlapp/data/services/speedcash_api_service.dart';
import 'package:xmlapp/viewmodels/balance_viewmodel.dart';
import 'package:xmlapp/viewmodels/icon_viewmodel.dart';
import 'package:xmlapp/viewmodels/provider_kartu_viewmodel.dart';
import 'package:xmlapp/viewmodels/riwayat_viewmodel.dart';
import 'package:xmlapp/viewmodels/speedcash/speedcash_viewmodel.dart';
import 'package:xmlapp/viewmodels/transaksi_viewmodel.dart';
import 'package:xmlapp/views/input_nomor/transaksi_cubit.dart';
import 'package:xmlapp/views/settings/cubit/info_akun_cubit.dart';
import 'package:xmlapp/views/settings/cubit/unbind_ewallet_cubit.dart';

import 'core/helper/flow_cubit.dart';
import 'core/route/app_route.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'data/services/location_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  // Lock orientasi layar
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const XmlApp()); // <-- langsung jalankan app
}

class XmlApp extends StatefulWidget {
  const XmlApp({super.key});

  @override
  State<XmlApp> createState() => _XmlAppState();
}

class _XmlAppState extends State<XmlApp> {
  StreamSubscription<Uri>? _sub;
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _initLocationService();
    _initDeepLinks();
  }

  Future<void> _initLocationService() async {
    final locationService = LocationService();
    try {
      await locationService.getCurrentLocation();
    } catch (e) {
      debugPrint("Lokasi error: $e");
    }
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    try {
      // Initial link kalau app dibuka pertama kali via deeplink
      final initialUri = await _appLinks.getInitialAppLink();
      if (initialUri != null) {
        _navigateFromUri(initialUri);
      }
    } catch (e) {
      debugPrint("Gagal ambil initial uri: $e");
    }

    // Listener kalau app sudah jalan lalu ada deeplink masuk
    _sub = _appLinks.uriLinkStream.listen(
      (uri) {
        if (uri != null) {
          _navigateFromUri(uri);
        }
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
      providers: [
        BlocProvider(
          create: (context) =>
              UnbindEwalletCubit(apiService: SpeedcashApiService()),
        ),
        BlocProvider(create: (context) => InfoAkunCubit(ApiService())),
        BlocProvider(create: (context) => TransaksiCubit()),
        BlocProvider(create: (context) => FlowCubit()),
      ],
      child: MultiProvider(
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
        child: MaterialApp(
          title: "XML App",
          theme: ThemeData(
            textTheme: GoogleFonts.varelaRoundTextTheme(),
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
