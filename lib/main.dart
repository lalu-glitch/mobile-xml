import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'routes/app_route.dart';
import 'viewmodels/balance_viewmodel.dart';
import 'viewmodels/icon_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, // opsional kalau mau support terbalik
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BalanceViewModel()),
        ChangeNotifierProvider(create: (_) => IconsViewModel()),
      ],
      child: const XmlApp(),
    ),
  );
}

class XmlApp extends StatelessWidget {
  const XmlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "XML App",
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(), // 🔹 Ganti ke Inter
      ),
      initialRoute: '/', // Start dari login
      routes: appRoutes, // Panggil route dari file terpisah
    );
  }
}
