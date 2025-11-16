import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:nashik/core/pages/deep_link_handler_page.dart';
import 'package:nashik/core/router/app_router.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  void initialize() {
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleDeepLink,
      onError: (Object err) {
        debugPrint('Deep link error: $err');
      },
    );
  }

  Future<void> _handleDeepLink(Uri uri) async {
    debugPrint('Deep link received: $uri');

    if (uri.scheme == 'com.caygnus.nashikdarshan') {
      final handlerUri = Uri(
        path: DeepLinkHandlerPage.routePath,
        queryParameters: {'deep_link': uri.toString()},
      );
      Approuter.router.go(handlerUri.toString());
      return;
    }
  }

  Future<Uri?> getInitialLink() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        await _handleDeepLink(uri);
      }
      return uri;
    } catch (e) {
      debugPrint('Error getting initial link: $e');
      return null;
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
