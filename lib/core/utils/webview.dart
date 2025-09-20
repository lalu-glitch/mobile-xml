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

  bool _hasRedirected = false;
  bool _isActiveFailed = false; // flag untuk binding gagal

  @override
  void initState() {
    super.initState();
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
                _currentUrl = req.url;
              });
              return NavigationDecision.navigate;
            },
            onPageFinished: (String finishedUrl) {
              if (mounted) {
                setState(() {
                  isLoading = false;
                  _currentUrl = finishedUrl;
                });
              }

              final uri = Uri.tryParse(_currentUrl);
              if (uri != null && uri.queryParameters.containsKey('isActive')) {
                final isActive = uri.queryParameters['isActive'];
                if (!_hasRedirected && isActive == 'true') {
                  _hasRedirected = true;
                  Navigator.pushReplacementNamed(context, '/');
                } else if (isActive == 'false') {
                  setState(() {
                    _isActiveFailed = true;
                  });
                }
              }
            },
          ),
        )
        ..loadRequest(Uri.parse(url));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kOrange,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          if (_controller != null) WebViewWidget(controller: _controller!),
          if (isLoading) const Center(child: CircularProgressIndicator()),
          if (_isActiveFailed)
            Container(
              color: Colors.white,
              child: const Center(
                child: Text(
                  "Binding gagal, silakan coba lagi.",
                  style: TextStyle(fontSize: 18, color: kRed),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
