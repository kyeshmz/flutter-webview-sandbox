import 'dart:async'; // Add this import
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:inapp_webview/menu.dart';
import 'package:inapp_webview/inapp_webview_screen.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Permission.camera.request();
  // await Permission.microphone.request();
  // await Permission.storage.request();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      await serviceWorkerController
          .setServiceWorkerClient(AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          print(request);
          return null;
        },
      ));
    }
  }

 runApp(
    const MaterialApp(
      home: WebViewApp(),
    ),
  );
}


class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  final controller =
      Completer<WebViewController>(); // Instantiate the controller

  bool _showAppBar = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _showAppBar
            ? AppBar(title: Text('Setting'), actions: [
                Menu(controller: controller), // Add this line
              ])
            : null,
        body: WebViewStack(
              controller:
                  controller), // Replace the WebView widget with WebViewStack
        ));
  }
}
