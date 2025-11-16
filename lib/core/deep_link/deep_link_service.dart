import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:nashik/core/router/app_router.dart';
import 'package:nashik/features/auth/presentation/pages/oauth_callback_page.dart';

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
    if (uri.scheme != 'com.caygnus.nashikdarshan') {
      return;
    }

    final host = uri.host.toLowerCase();
    final path = uri.path.toLowerCase();

    // Map deep links directly to pages
    if (host == 'login-callback' ||
        host == 'auth-callback' ||
        path.contains('login-callback') ||
        path.contains('auth-callback')) {
      // OAuth callback
      final callbackUri = Uri(
        path: OAuthCallbackPage.routePath,
        queryParameters: uri.queryParameters,
      );
      Approuter.router.go(callbackUri.toString());
      return;
    }

    // Add more deep link mappings here as needed
    // Example:
    // if (host == 'verify-email') {
    //   Approuter.router.goNamed(EmailVerificationPage.routeName, ...);
    // }
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
