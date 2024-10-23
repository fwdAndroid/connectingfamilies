import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class Webpage extends StatefulWidget {
  final String url;
  final String title;

  Webpage({required this.title, required this.url});

  @override
  _WebpageState createState() => _WebpageState();
}

class _WebpageState extends State<Webpage> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(),
                    ),
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;
                      String scheme = uri.scheme;

                      // Check if the URL scheme is a known one
                      if (![
                        "http",
                        "https",
                        "file",
                        "chrome",
                        "data",
                        "javascript",
                        "about"
                      ].contains(scheme)) {
                        // Handle WhatsApp links specifically
                        if (scheme == "whatsapp") {
                          // Launch the URL with url_launcher
                          if (await canLaunch(uri.toString())) {
                            await launch(uri.toString());
                          } else {
                            throw 'Could not launch $uri';
                          }
                          return NavigationActionPolicy
                              .CANCEL; // Prevent loading in the WebView
                        }
                        // Handle other unsupported schemes
                        if (await canLaunch(uri.toString())) {
                          await launch(uri.toString());
                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      return NavigationActionPolicy
                          .ALLOW; // Allow the WebView to load the URL
                    },
                    onLoadStop: (controller, url) async {
                      pullToRefreshController?.endRefreshing();
                      setState(() {});
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController?.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                        urlController.text = this.url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                    },
                  ),
                  // Show a circular progress indicator while loading
                  progress < 1.0
                      ? Center(
                          child: CircularProgressIndicator(value: progress))
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
