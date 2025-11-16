import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nashik/core/supabase/config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for native Google Sign-In with Supabase
///
/// This service handles the native Google Sign-In flow and exchanges
/// the Google tokens with Supabase for authentication.
///
/// Flow:
/// 1. User signs in with Google using native sign-in (no browser redirect)
/// 2. App receives Google ID token and access token
/// 3. App exchanges tokens with Supabase using signInWithIdToken()
/// 4. Supabase verifies tokens and creates/updates user session
/// 5. User is authenticated in the app via Supabase
///
/// Note: The OAuth Client ID must be configured in:
/// - Google Cloud Console (Android/iOS OAuth client IDs)
/// - Supabase Dashboard (Authentication → Providers → Google)
class GoogleAuthService {
  static final GoogleAuthService _instance = GoogleAuthService._internal();
  factory GoogleAuthService() => _instance;
  GoogleAuthService._internal();

  /// GoogleSignIn instance configured for native sign-in
  /// The OAuth Client ID is automatically read from Google Cloud Console
  /// based on the app's package name and SHA-1 fingerprint (Android)
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // Note: serverClientId is optional for native sign-in with Supabase
    // If Supabase requires it, you can add it here:
    // serverClientId: 'your-web-client-id.apps.googleusercontent.com',
  );

  /// Sign in with Google natively and authenticate with Supabase
  ///
  /// Returns the Supabase access token if successful, null if user canceled
  ///
  /// Throws Exception if sign-in fails
  Future<String?> signInWithGoogle() async {
    try {
      // Step 1: Trigger the native Google Sign-In flow
      // This shows the native Google account picker (no browser redirect)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in dialog
        return null;
      }

      // Step 2: Obtain authentication tokens from Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Step 3: Extract the ID token and access token
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception(
          'Failed to get Google authentication tokens. '
          'Please ensure Google Sign-In is properly configured.',
        );
      }

      // Step 4: Exchange Google tokens with Supabase
      // Supabase will verify the tokens with Google and create/update user session
      final response = await SupabaseConfig.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      // Step 5: Verify Supabase session was created
      if (response.session != null) {
        // Return the Supabase access token for the authenticated session
        return response.session?.accessToken;
      }

      throw Exception(
        'Failed to create Supabase session. '
        'Please verify Google OAuth Client ID is configured in Supabase Dashboard.',
      );
    } on PlatformException catch (e) {
      // Handle platform-specific errors (e.g., Google Play Services not available)
      throw Exception('Google Sign-In platform error: ${e.message}');
    } catch (e) {
      // Handle other errors
      throw Exception('Google Sign-In error: $e');
    }
  }

  /// Sign out from Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      // Ignore errors during sign out
    }
  }

  /// Check if user is already signed in to Google
  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  /// Get current Google user
  Future<GoogleSignInAccount?> getCurrentUser() async {
    return _googleSignIn.currentUser;
  }
}
