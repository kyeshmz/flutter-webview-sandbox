import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

enum _MenuOptions {
  setCookieApple,
  setCookieBanana,
  clearCookies,
  listCookies,
  clearCache
}

class Menu extends StatefulWidget {
  const Menu({required this.controller, Key? key}) : super(key: key);

  final Completer<WebViewController> controller;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final CookieManager cookieManager = CookieManager();

  Future<void> _onSetCookieApple(WebViewController controller) async {
    cookieManager.setCookie(const WebViewCookie(
        name: 'fruit', value: 'Apple', domain: '127.0.0.1'));
    await controller.runJavascript('''var date = new Date();
    date.setTime(date.getTime()+(30*24*60*60*1000));
    document.cookie = "fruit=Apple; expires=" + date.toGMTString();''');
    final String cookies =
        await controller.runJavascriptReturningResult('document.cookie');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            (cookies.isNotEmpty ? 'Cookie Apple set' : 'Cookie set error')),
      ),
    );
    controller.reload();
  }

  Future<void> _onSetCookieBanana(WebViewController controller) async {
    cookieManager.setCookie(const WebViewCookie(
        name: 'fruit', value: 'Banana', domain: '127.0.0.1'));
    await controller.runJavascript('''var date = new Date();
    date.setTime(date.getTime()+(30*24*60*60*1000));
    document.cookie = "fruit=Banana; expires=" + date.toGMTString();''');

    final String cookies =
        await controller.runJavascriptReturningResult('document.cookie');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        (cookies.isNotEmpty ? 'Cookie Banana set' : 'Cookie set error'),
      ),
    ));
    controller.reload();
  }

  Future<void> _onClearCookies(WebViewController controller) async {
    controller.clearCache();
    // await cookieManager.clearCookies();
    await controller.runJavascript(
        'document.cookie="fruit=Apple; expires=Thu, 01 Jan 1970 00:00:00 UTC" ');

    await controller.runJavascript(
        'document.cookie="fruit=Banana; expires=Thu, 01 Jan 1970 00:00:00 UTC" ');

    String message = 'Cookie Erased';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
    controller.reload();
  }

  Future<void> _onListCookies(WebViewController controller) async {
    final String cookies =
        await controller.runJavascriptReturningResult('document.cookie');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(cookies.isNotEmpty ? cookies : 'There are no cookies.'),
      ),
    );
  }

  Future<void> _onClearCache(WebViewController controller) async {
    controller.clearCache();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Clear cache'),
      ),
    );
    controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: widget.controller.future,
      builder: (context, controller) {
        return PopupMenuButton<_MenuOptions>(
          onSelected: (value) async {
            switch (value) {
              case _MenuOptions.setCookieApple:
                _onSetCookieApple(controller.data!);
                break;
              case _MenuOptions.setCookieBanana:
                _onSetCookieBanana(controller.data!);
                break;
              case _MenuOptions.clearCookies:
                _onClearCookies(controller.data!);
                break;

              case _MenuOptions.listCookies:
                _onListCookies(controller.data!);
                break;
              case _MenuOptions.clearCache:
                _onClearCache(controller.data!);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.setCookieApple,
              child: Text('Set Cookie Apple'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.setCookieBanana,
              child: Text('Set Cookie Banana'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.clearCookies,
              child: Text('Clear Cookies'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.clearCache,
              child: Text('Clear Cache'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.listCookies,
              child: Text('List Cookies'),
            ),
          ],
        );
      },
    );
  }
}
