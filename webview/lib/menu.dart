import 'dart:async';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

enum _MenuOptions {
  setCookieRLIM,
  setCookieSemba,
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

  Future<void> _onSetCookieSemba(WebViewController controller) async {
    cookieManager.setCookie(const WebViewCookie(
        name: 'store', value: 'SEMBA', domain: 'baobaoisseymiyakedazzle.com'));
    await controller.runJavascript('''var date = new Date();
    date.setTime(date.getTime()+(30*24*60*60*1000));
    document.cookie = "store=SEMBA; expires=" + date.toGMTString();''');
    final String cookies =
        await controller.runJavascriptReturningResult('document.cookie');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text((cookies.isNotEmpty ? 'SEMBA　設定完了' : 'Cookie set error')),
      ),
    );
    controller.reload();
  }

  Future<void> _onSetCookieRLIM(WebViewController controller) async {
    cookieManager.setCookie(const WebViewCookie(
        name: 'store', value: 'RLIM', domain: 'baobaoisseymiyakedazzle.com'));
    await controller.runJavascript('''var date = new Date();
    date.setTime(date.getTime()+(30*24*60*60*1000));
    document.cookie = "store=RLIM; expires=" + date.toGMTString();''');

    final String cookies =
        await controller.runJavascriptReturningResult('document.cookie');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        (cookies.isNotEmpty ? 'RLIM' : 'Cookie set error'),
      ),
    ));
    controller.reload();
  }

  Future<void> _onClearCookies(WebViewController controller) async {
    controller.clearCache();
    // await cookieManager.clearCookies();
    await controller.runJavascript(
        'document.cookie="store=RLIM; expires=Thu, 01 Jan 1970 00:00:00 UTC" ');

    await controller.runJavascript(
        'document.cookie="store=SEMBA; expires=Thu, 01 Jan 1970 00:00:00 UTC" ');

    String message = 'Cookie 削除完了';

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
        content: Text('キャッシュ削除完了'),
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
              case _MenuOptions.setCookieRLIM:
                _onSetCookieRLIM(controller.data!);
                break;
              case _MenuOptions.setCookieSemba:
                _onSetCookieSemba(controller.data!);
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
              value: _MenuOptions.setCookieRLIM,
              child: Text('RLIM として設定する'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.setCookieSemba,
              child: Text('SEMBA として設定する'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.clearCookies,
              child: Text('設定 -- 削除'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.clearCache,
              child: Text('キャッシュ削除'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.listCookies,
              child: Text('設定 -- 確認'),
            ),
          ],
        );
      },
    );
  }
}
