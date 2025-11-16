import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:nashik/core/router/app_router.dart';
import 'package:nashik/core/supabase/config.dart';
import 'package:nashik/features/auth/presentation/pages/oauth_callback_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

    if (uri.pathSegments.contains('login-callback') ||
        uri.pathSegments.contains('auth-callback')) {
      final callbackUri = Uri(
        path: OAuthCallbackPage.routePath,
        queryParameters: {'deep_link': uri.toString()},
      );
      Approuter.router.go(callbackUri.toString());
      return;
    }

    if (uri.pathSegments.contains('verify-email')) {
      await _handleEmailVerification(uri);
      return;
    }

    if (uri.pathSegments.contains('reset-password')) {
      await _handlePasswordReset(uri);
      return;
    }
  }

  Future<void> _handleEmailVerification(Uri uri) async {
    try {
      final token = uri.queryParameters['token'];
      final type = uri.queryParameters['type'];

      if (token == null || type == null) {
        debugPrint('Missing token or type in email verification link');
        return;
      }

      final response = await SupabaseConfig.client.auth.verifyOTP(
        type: OtpType.email,
        token: token,
        email: uri.queryParameters['email'],
      );

      if (response.session != null) {
        debugPrint('Email verified successfully');
      }
    } catch (e) {
      debugPrint('Email verification error: $e');
    }
  }

  Future<void> _handlePasswordReset(Uri uri) async {
    try {
      final token = uri.queryParameters['token'];
      final type = uri.queryParameters['type'];

      if (token == null || type == null) {
        debugPrint('Missing token or type in password reset link');
        return;
      }

      debugPrint('Password reset link received');
    } catch (e) {
      debugPrint('Password reset error: $e');
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
