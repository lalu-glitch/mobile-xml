import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../helper/constant_finals.dart';

class WebviewPage extends StatefulWidget {
  final String? url;
  final String? title;

  const WebviewPage({super.key, this.url, this.title});

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  WebViewController? _controller;
  bool isLoading = true;
  String _currentUrl = '';
  String url = '';
  String title = '';

  final String finalUrl = 'https://m.youtube.com/';

  @override
  void initState() {
    super.initState();
    // Delay untuk build page dulu sebelum init WebView
    Future.delayed(const Duration(milliseconds: 1000), () {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      String tempUrl = args?['url'] ?? widget.url ?? '';
      String tempTitle = args?['title'] ?? widget.title ?? 'Webview';

      if (!tempUrl.startsWith('http://') && !tempUrl.startsWith('https://')) {
        tempUrl = 'https://$tempUrl';
      }

      setState(() {
        url = tempUrl;
        title = tempTitle;
        isLoading = true;
      });

      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              setState(() {
                isLoading = true;
              });
            },
            onNavigationRequest: (NavigationRequest req) {
              setState(() {
                _currentUrl = req.url; // Simpan URL baru saat navigasi
              });
              print('Navigasi ke: $_currentUrl');
              return NavigationDecision.navigate;
            },
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
                print('Halaman selesai dimuat: $_currentUrl');
              }
            },
          ),
        )
        ..loadRequest(Uri.parse(url));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUrl == finalUrl) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(
          context,
          '/transaksiProses',
          arguments: {
            'tujuan': '085239905885',
            'kode_produk': 'CEKDANA',
            'kode_dompet': 'SPEEDCASH',
          },
        );
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kOrange,
        iconTheme: const IconThemeData(color: kWhite),
        leading: IconButton(
          icon: const Icon(Icons.close), // ikon X
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          if (_controller != null) WebViewWidget(controller: _controller!),
          if (isLoading) const Center(child: CircularProgressIndicator()),
          if (_currentUrl == finalUrl)
            Container(
              color: Colors.white,
              child: const Center(child: Text("Redirecting...")),
            ),
        ],
      ),
    );
  }
}
