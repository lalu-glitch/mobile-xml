import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'routes/app_route.dart';
import 'services/api_service.dart';
import 'viewmodels/balance_viewmodel.dart';
import 'viewmodels/icon_viewmodel.dart';
import 'viewmodels/provider_viewmodel.dart';
import 'viewmodels/riwayat_viewmodel.dart';
import 'viewmodels/transaksi_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
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
      options.dsn =
          'https://caa991a372d49f2d8dde12c4f6e9ac85@o4509902367096832.ingest.de.sentry.io/4509902501183568';
      options.sendDefaultPii = true;
      options.tracesSampleRate = 0.01;

      // Tambahan logging untuk debug
      options.debug = kDebugMode;
    },
    // Jalankan aplikasi setelah Sentry siap
    appRunner: () => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BalanceViewModel()),
          ChangeNotifierProvider(create: (_) => IconsViewModel()),
          ChangeNotifierProvider(create: (_) => ProviderViewModel()),
          ChangeNotifierProvider(
            create: (_) => TransaksiViewModel(service: ApiService()),
          ),
          ChangeNotifierProvider(create: (_) => HistoryViewModel()),
        ],
        child: const XmlApp(),
      ),
    ),
  );
}

class XmlApp extends StatelessWidget {
  const XmlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "XML App",
      theme: ThemeData(textTheme: GoogleFonts.varelaRoundTextTheme()),
      navigatorObservers: [
        SentryNavigatorObserver(), // <-- Auto-tracking navigasi
      ],
      initialRoute: '/',
      routes: appRoutes, // untuk halaman statis
    );
  }
}
