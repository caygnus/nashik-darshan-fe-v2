import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:nashik/core/supabase/config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service to handle deep linking for authentication
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  /// Initialize deep link listener
  void initialize() {
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleDeepLink,
      onError: (Object err) {
        debugPrint('Deep link error: $err');
      },
    );
  }

  /// Handle incoming deep links
  Future<void> _handleDeepLink(Uri uri) async {
    debugPrint('Deep link received: $uri');

    // Handle email verification links
    if (uri.pathSegments.contains('verify-email')) {
      await _handleEmailVerification(uri);
      return;
    }

    // Handle password reset links
    if (uri.pathSegments.contains('reset-password')) {
      await _handlePasswordReset(uri);
      return;
    }

    // Handle OAuth callbacks
    if (uri.pathSegments.contains('login-callback') ||
        uri.pathSegments.contains('auth-callback')) {
      await _handleOAuthCallback(uri);
      return;
    }
  }

  /// Handle email verification
  Future<void> _handleEmailVerification(Uri uri) async {
    try {
      // Extract token and type from query parameters
      final token = uri.queryParameters['token'];
      final type = uri.queryParameters['type'];

      if (token == null || type == null) {
        debugPrint('Missing token or type in email verification link');
        return;
      }

      // Verify the email using Supabase
      final response = await SupabaseConfig.client.auth.verifyOTP(
        type: OtpType.email,
        token: token,
        email: uri.queryParameters['email'],
      );

      if (response.session != null) {
        debugPrint('Email verified successfully');
        // The auth state listener will handle the session update
      }
    } catch (e) {
      debugPrint('Email verification error: $e');
    }
  }

  /// Handle password reset
  Future<void> _handlePasswordReset(Uri uri) async {
    try {
      // Extract token from query parameters
      final token = uri.queryParameters['token'];
      final type = uri.queryParameters['type'];

      if (token == null || type == null) {
        debugPrint('Missing token or type in password reset link');
        return;
      }

      // The password reset flow will be handled by the password reset page
      debugPrint('Password reset link received');
    } catch (e) {
      debugPrint('Password reset error: $e');
    }
  }

  /// Handle OAuth callback
  Future<void> _handleOAuthCallback(Uri uri) async {
    try {
      // Supabase handles OAuth callbacks automatically
      // The auth state listener will detect the session change
      debugPrint('OAuth callback received: $uri');
    } catch (e) {
      debugPrint('OAuth callback error: $e');
    }
  }

  /// Get initial link if app was opened via deep link
  Future<Uri?> getInitialLink() async {
    try {
      return await _appLinks.getInitialLink();
    } catch (e) {
      debugPrint('Error getting initial link: $e');
      return null;
    }
  }

  /// Dispose resources
  void dispose() {
    _linkSubscription?.cancel();
  }
}
