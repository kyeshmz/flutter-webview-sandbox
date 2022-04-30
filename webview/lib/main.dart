import 'dart:async'; // Add this import

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Add this import back
import 'package:webview/src/menu.dart';

import 'src/web_view_stack.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
            ? AppBar(title: Text('設定'), actions: [
                Menu(controller: controller), // Add this line
              ])
            : null,
        body: WebViewStack(
              controller:
                  controller), // Replace the WebView widget with WebViewStack
        ));
  }
}
