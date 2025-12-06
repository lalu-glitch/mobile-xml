import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/helper/constant_finals.dart';
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
  bool _isScriptInjected = false;

  static const String _defaultUrl =
      "https://www.telkomsel.com/shops/channel/o2o/";

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
          onPageStarted: (_) {
            // Cek mounted agar aman dari memory leak jika widget sudah dispose saat callback jalan
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (String url) => _onPageFinished(url),
          onNavigationRequest: (NavigationRequest request) {
            _checkAndHandleUrl(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'UrlChange',
        onMessageReceived: (message) {
          log("[JS CHANGE] ${message.message}");
          _checkAndHandleUrl(message.message);
        },
      );

    // [MEMORY FIX 1] Bersihkan cache SEBELUM load.
    // Ini mencegah penumpukan cache dari sesi sebelumnya.
    _controller.clearCache().then((_) {
      _controller.loadRequest(Uri.parse(startUrl));
    });
  }

  Future<void> _onPageFinished(String url) async {
    // Cek mounted
    if (!mounted) return;

    setState(() => _isLoading = false);
    log("[Page Finish] $url");

    _checkAndHandleUrl(url);

    if (!_isScriptInjected) {
      await _controller.runJavaScript(_historyObserverScript);
      _isScriptInjected = true;
    }
  }

  void _checkAndHandleUrl(String urlString) {
    if (_hasRedirected) return;

    final uri = Uri.tryParse(urlString);
    if (uri == null) return;

    if (_isOmniSuccessUrl(uri)) {
      _processSuccessTransaction(uri);
    }
  }

  bool _isOmniSuccessUrl(Uri uri) {
    final segments = uri.pathSegments;
    if (segments.length < 5) return false;

    return segments[0] == "shops" &&
        segments[1] == "channel" &&
        segments[2] == "o2o" &&
        segments[4].contains("success");
  }

  void _processSuccessTransaction(Uri uri) {
    final segments = uri.pathSegments;
    final kodeTransaksi = segments[3];
    final msisdn = uri.queryParameters["msisdn"];

    log("Kode OMNI Found: $kodeTransaksi");
    log("Kode MSISDN Found: $msisdn");
    _hasRedirected = true;

    context.read<TransaksiOmniCubit>().setResult(
      kode: kodeTransaksi,
      msisdn: msisdn,
    );
    _navigateToNextFlow();
  }

  void _navigateToNextFlow() {
    final flowCubit = context.read<FlowCubit>();
    flowCubit.nextPage();

    final state = flowCubit.state;
    if (state != null) {
      final nextPageName = state.sequence[state.currentIndex];
      if (pageRoutes.containsKey(nextPageName)) {
        Navigator.pushNamed(context, pageRoutes[nextPageName]!);
      } else {
        log("Error: Route untuk $nextPageName tidak ditemukan");
      }
    }
  }

  @override
  void dispose() {
    // [MEMORY FIX 2] Hapus channel
    _controller.removeJavaScriptChannel('UrlChange');

    // [MEMORY FIX 3] Paksa WebView memuat halaman kosong
    // Ini memaksa browser engine melepas resource halaman berat (DOM/JS) dari memori Native.
    _controller.loadRequest(Uri.parse('about:blank'));

    // [MEMORY FIX 4] Bersihkan cache lagi saat keluar
    _controller.clearCache();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Telkomsel OMNI", style: TextStyle(color: kWhite)),
        backgroundColor: kRed,
        iconTheme: const IconThemeData(color: kWhite),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: kRed)),
        ],
      ),
    );
  }
}
