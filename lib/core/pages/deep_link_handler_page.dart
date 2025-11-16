import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/supabase/config.dart';
import 'package:nashik/features/auth/presentation/pages/oauth_callback_page.dart';
import 'package:nashik/features/home/presentation/pages/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeepLinkHandlerPage extends StatefulWidget {
  const DeepLinkHandlerPage({super.key});

  static const routeName = 'DeepLinkHandlerPage';
  static const routePath = '/deep-link-handler';

  @override
  State<DeepLinkHandlerPage> createState() => _DeepLinkHandlerPageState();
}

class _DeepLinkHandlerPageState extends State<DeepLinkHandlerPage> {
  @override
  void initState() {
    super.initState();
    _handleDeepLink();
  }

  Future<void> _handleDeepLink() async {
    try {
      final routeState = GoRouterState.of(context);
      final deepLinkParam = routeState.uri.queryParameters['deep_link'];
      final uri = deepLinkParam != null
          ? Uri.parse(deepLinkParam)
          : routeState.uri;

      developer.log('Deep link handler: Processing URI: $uri', name: 'Router');
      developer.log(
        'Deep link handler: URI breakdown - scheme: ${uri.scheme}, host: ${uri.host}, path: ${uri.path}, pathSegments: ${uri.pathSegments}, queryParams: ${uri.queryParameters}',
        name: 'Router',
      );

      if (uri.scheme == 'com.caygnus.nashikdarshan') {
        final uriString = uri.toString();
        final uriStringLower = uriString.toLowerCase();
        final host = uri.host.toLowerCase();
        final pathSegments = uri.pathSegments;
        final path = uri.path.toLowerCase();

        developer.log(
          'Deep link handler: Matching - uriString: $uriString, host: $host, path: $path, pathSegments: $pathSegments',
          name: 'Router',
        );

        final isOAuthCallback =
            uriStringLower.contains('login-callback') ||
            uriStringLower.contains('auth-callback') ||
            host == 'login-callback' ||
            host == 'auth-callback' ||
            path == '/login-callback' ||
            path == '/login-callback/' ||
            path == '/auth-callback' ||
            path == '/auth-callback/' ||
            pathSegments.contains('login-callback') ||
            pathSegments.contains('auth-callback');

        developer.log(
          'Deep link handler: isOAuthCallback: $isOAuthCallback',
          name: 'Router',
        );

        if (isOAuthCallback) {
          developer.log(
            'Deep link handler: Routing to OAuth callback page',
            name: 'Router',
          );
          final callbackUri = Uri(
            path: OAuthCallbackPage.routePath,
            queryParameters: {'deep_link': uri.toString()},
          );
          if (mounted) {
            context.go(callbackUri.toString());
          }
          return;
        }

        if (uriString.contains('verify-email') ||
            pathSegments.contains('verify-email')) {
          await _handleEmailVerification(uri);
          return;
        }

        if (uriString.contains('reset-password') ||
            pathSegments.contains('reset-password')) {
          await _handlePasswordReset(uri);
          return;
        }
      }

      if (mounted) {
        context.goNamed(HomeScreen.routeName);
      }
    } catch (e) {
      debugPrint('Deep link handler error: $e');
      if (mounted) {
        context.goNamed(HomeScreen.routeName);
      }
    }
  }

  Future<void> _handleEmailVerification(Uri uri) async {
    try {
      final token = uri.queryParameters['token'];
      final type = uri.queryParameters['type'];

      if (token == null || type == null) {
        debugPrint('Missing token or type in email verification link');
        if (mounted) {
          context.goNamed(HomeScreen.routeName);
        }
        return;
      }

      final response = await SupabaseConfig.client.auth.verifyOTP(
        type: OtpType.email,
        token: token,
        email: uri.queryParameters['email'],
      );

      if (response.session != null) {
        debugPrint('Email verified successfully');
        if (mounted) {
          context.goNamed(HomeScreen.routeName);
        }
      } else {
        if (mounted) {
          context.goNamed(HomeScreen.routeName);
        }
      }
    } catch (e) {
      debugPrint('Email verification error: $e');
      if (mounted) {
        context.goNamed(HomeScreen.routeName);
      }
    }
  }

  Future<void> _handlePasswordReset(Uri uri) async {
    try {
      final token = uri.queryParameters['token'];
      final type = uri.queryParameters['type'];

      if (token == null || type == null) {
        debugPrint('Missing token or type in password reset link');
        if (mounted) {
          context.goNamed(HomeScreen.routeName);
        }
        return;
      }

      debugPrint('Password reset link received');
      if (mounted) {
        context.goNamed(HomeScreen.routeName);
      }
    } catch (e) {
      debugPrint('Password reset error: $e');
      if (mounted) {
        context.goNamed(HomeScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
