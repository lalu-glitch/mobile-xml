import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  String url = '';
  String title = '';

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
            onPageFinished: (_) {
              if (mounted) {
                setState(() => isLoading = false);
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          if (_controller != null) WebViewWidget(controller: _controller!),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
