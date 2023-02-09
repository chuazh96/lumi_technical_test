import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:lumi_technical_test/Utilities/config.dart';

class NewsPage extends StatefulWidget {
  const NewsPage(
      {super.key,
      required this.publisher,
      required this.publisherImage,
      required this.link});

  final String publisher;
  final String publisherImage;
  final String link;

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late final WebViewController controller;
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onPageFinished: (String url) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(
                child: Text(
                  "Ads from publisher's website",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              duration: Duration(seconds: 3),
              backgroundColor: Color(0xFF303030),
              elevation: 8,
            ));
            setState(() {
              loadingPercentage = 100;
            });
            Milestones().updateNumOfArticles(context);
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.link));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Image.network(
                    widget.publisherImage,
                    height: 40,
                    width: 40,
                  ),
                ),
                const SizedBox(width: 5),
                Text(widget.publisher, style: appTheme.textTheme.headlineSmall),
              ],
            ),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF9BB0FF)),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            backgroundColor: Colors.white),
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
                backgroundColor: Colors.white,
              )
          ],
        ));
  }
}
