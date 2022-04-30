import 'dart:async';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:pdf/pdf.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({required this.controller, Key? key}) : super(key: key);

  final Completer<WebViewController> controller;

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;

  WebViewController? _controller;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: SafeArea(
            child: Stack(
          children: [
            WebView(
              gestureNavigationEnabled: false,
              allowsInlineMediaPlayback: true,
              initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
              initialUrl: 'https://stg-customize.baobaoisseymiyakedazzle.com',
              // initialUrl: 'http://10.0.0.92:3000',

              onWebViewCreated: (webViewController) {
                widget.controller.complete(webViewController);
                _controller = webViewController;
              },

              onPageStarted: (url) {
                setState(() {});
              },
              onProgress: (progress) {
                setState(() {
                  loadingPercentage = progress;
                });
              },
              onPageFinished: (url) {
                setState(() {
                  loadingPercentage = 100;
                });
              },
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: _createJavascriptChannels(context),
            ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              ),
          ],
        )));
  }

  generatePDF() async {
    String html = await _controller!.runJavascriptReturningResult(
        'document.getElementById("exportDiv").outerHTML');

    const printFormat = PdfPageFormat(
        100 * PdfPageFormat.mm, 50 * PdfPageFormat.mm,
        marginLeft: 0, marginTop: 0, marginRight: 0, marginBottom: 0);

    var pdf = await Printing.convertHtml(
      format: printFormat,
      html: html,
    );

    return await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf,
    )
  }

  generatePDFCookie(String message) async {
    String html = await _controller!.runJavascriptReturningResult(
        'document.getElementById("exportDiv").outerHTML');

    const printFormat = PdfPageFormat(
        100 * PdfPageFormat.mm, 50 * PdfPageFormat.mm,
        marginLeft: 0, marginTop: 0, marginRight: 0, marginBottom: 0);

    var pdf = await Printing.convertHtml(
      format: printFormat,
      html: html,
    );

    return await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf,
    ).then((value) => {
          if (value != null)
            {
              _controller!.runJavascript('''var date = new Date();
    date.setTime(date.getTime()+(30*24*60*60*1000));
    document.cookie = "store=${message.toLowerCase()}; expires=" + date.toGMTString();''')
            }
          else
            {
              _controller!.runJavascript('''var date = new Date();
    date.setTime(date.getTime()+(30*24*60*60*1000));
    document.cookie = "store=${message.toLowerCase()}; expires=" + date.toGMTString();''')
            }
        });
  }

  Set<JavascriptChannel> _createJavascriptChannels(
    BuildContext context,
  ) {
    return {
      JavascriptChannel(
        name: 'Flutter',
        onMessageReceived: (message) {
          print(message.message);

          generatePDF();

          // generatePDFCookie(message.message)
        },
      ),
    };
  }
}
