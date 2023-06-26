import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_telebirr/flutter_telebirr.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  InAppWebViewController? webViewController;

  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _startPayment(),
            child: const Text('Start Payment'),
          ),
          SizedBox(
            height: 500,
            child: Stack(
              children: [
                InAppWebView(
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
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
                progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _startPayment() async {
    const String publicKey = '<PublicKey>';

    TelebirrPayment.instance.configure(
      publicKey: publicKey,
      appId: '<appId>',
      appKey: "<appKey>",
      notifyUrl: "https://localhost/notifyUrl",
      shortCode: "<shortCode>",
      merchantDisplayName: "Organization name",
      // mode: Mode.test,
      // testUrl: 'http://<IP>:<PORT>/service-openup',
    );

    final TeleBirrPayResponse? response =
        await TelebirrPayment.instance.startPayment(
      itemName: "Item Name",
      totalAmount: "10",
    );
    if (response != null && response.isSuccess) {
      webViewController?.loadUrl(
          urlRequest:
              URLRequest(url: Uri.parse(response.data?.toPayUrl ?? '')));
    }
  }
}
