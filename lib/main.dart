import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_links/app_links.dart';
import 'core/app_providers.dart';
import 'core/route/app_route.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  // Pastikan binding yang sesuai untuk Sentry
  SentryWidgetsFlutterBinding.ensureInitialized();

  // Lock orientasi layar
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inisialisasi Sentry
  await SentryFlutter.init(
    (options) {
      options.dsn = '${dotenv.env['SENTRY_LINK']}';
      options.sendDefaultPii = true;
      options.tracesSampleRate = 0.01;

      // Tambahan logging untuk debug
      options.debug = kDebugMode;
    },
    //Jalankan aplikasi setelah Sentry siap
    appRunner: () => runApp(AppProviders.build()),
  );
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
    _initDeepLinks();
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
        // ignore: unnecessary_null_comparison
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
    return MaterialApp(
      title: "XML App",
      theme: ThemeData(textTheme: GoogleFonts.varelaRoundTextTheme()),
      navigatorObservers: [SentryNavigatorObserver()],
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}
