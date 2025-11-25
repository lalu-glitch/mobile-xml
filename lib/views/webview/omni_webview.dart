import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/helper/dynamic_app_page.dart';
import '../layanan/cubit/flow_cubit.dart';
import '../transaksi/cubit/transaksi_omni/transaksi_omni_cubit.dart';

class OmniWebViewPage extends StatefulWidget {
  final String? initialUrl;

  const OmniWebViewPage({super.key, this.initialUrl});

  @override
  State<OmniWebViewPage> createState() => _OmniWebViewPageState();
}

class _OmniWebViewPageState extends State<OmniWebViewPage> {
  late final WebViewController _controller;

  bool _isLoading = true;
  bool _hasRedirected = false;

  // Konstanta URL Default
  static const String _defaultUrl =
      "https://www.telkomsel.com/shops/channel/o2o/";

  // Script JS untuk mendeteksi perubahan URL pada Single Page Application (SPA)
  // Ini menangkap event pushState, replaceState, dan popstate.
  static const String _historyObserverScript = '''
    (function() {
      try {
        function notify(url) {
          if (window.UrlChange && window.UrlChange.postMessage) {
            window.UrlChange.postMessage(url || window.location.href);
          }
        }
        var _push = history.pushState;
        var _replace = history.replaceState;
        
        history.pushState = function() {
          _push.apply(this, arguments);
          notify();
        };
        history.replaceState = function() {
          _replace.apply(this, arguments);
          notify();
        };
        window.addEventListener('popstate', function() { notify(); });
        // Panggil sekali saat load selesai
        notify(); 
      } catch(e) {}
    })();
  ''';

  @override
  void initState() {
    super.initState();
    _setupWebViewController();
  }

  void _setupWebViewController() {
    final startUrl = widget.initialUrl ?? _defaultUrl;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (String url) => _onPageFinished(url),
          onNavigationRequest: (NavigationRequest request) {
            // Handle navigasi standar (klik link biasa)
            _checkAndHandleUrl(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      // Channel komunikasi JS -> Flutter
      ..addJavaScriptChannel(
        'UrlChange',
        onMessageReceived: (message) {
          log("[JS CHANGE] ${message.message}");
          _checkAndHandleUrl(message.message);
        },
      )
      ..loadRequest(Uri.parse(startUrl));
  }

  /// Dipanggil ketika loading halaman selesai
  Future<void> _onPageFinished(String url) async {
    setState(() => _isLoading = false);
    log("[Page Finish] $url");

    // 1. Cek URL saat ini
    _checkAndHandleUrl(url);

    // 2. Inject script listener untuk memantau perubahan URL tanpa reload (SPA behavior)
    await _controller.runJavaScript(_historyObserverScript);
  }

  /// Pusat logika pengecekan URL
  void _checkAndHandleUrl(String urlString) {
    if (_hasRedirected) return;

    final uri = Uri.tryParse(urlString);
    if (uri == null) return;

    if (_isOmniSuccessUrl(uri)) {
      _processSuccessTransaction(uri);
    }
  }

  /// Helper: Memastikan apakah URL ini adalah URL sukses OMNI
  /// Pattern: .../shops/channel/o2o/{kode_transaksi}/success
  bool _isOmniSuccessUrl(Uri uri) {
    final segments = uri.pathSegments;
    // Minimal segments harus 5 agar tidak out of bounds saat akses index 4
    if (segments.length < 5) return false;

    return segments[0] == "shops" &&
        segments[1] == "channel" &&
        segments[2] == "o2o" &&
        segments[4].contains("success");
  }

  /// Eksekusi logika bisnis ketika transaksi sukses
  void _processSuccessTransaction(Uri uri) {
    final segments = uri.pathSegments;
    final kodeTransaksi = segments[3]; // Index 3 adalah {kode}
    final msisdn = uri.queryParameters["msisdn"];

    log("Kode OMNI Found: $kodeTransaksi");
    log("Kode MSISDN Found: $msisdn");
    _hasRedirected = true;

    // Eksekusi State Management (BLoC/Cubit)
    context.read<TransaksiOmniCubit>().setResult(
      kode: kodeTransaksi,
      msisdn: msisdn,
    );
    _navigateToNextFlow();
  }

  /// Mengurus navigasi pindah halaman di Flutter
  void _navigateToNextFlow() {
    final flowCubit = context.read<FlowCubit>();
    flowCubit.nextPage();

    final state = flowCubit.state;
    if (state != null) {
      final nextPageName = state.sequence[state.currentIndex];
      // Pastikan route ada di map pageRoutes, atau handle error jika null
      if (pageRoutes.containsKey(nextPageName)) {
        Navigator.pushNamed(context, pageRoutes[nextPageName]!);
      } else {
        log("Error: Route untuk $nextPageName tidak ditemukan");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Telkomsel OMNI",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.red)),
        ],
      ),
    );
  }
}
