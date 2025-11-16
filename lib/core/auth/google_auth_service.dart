import 'package:google_sign_in/google_sign_in.dart';
import 'package:nashik/core/supabase/config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for native Google Sign-In
class GoogleAuthService {
  static final GoogleAuthService _instance = GoogleAuthService._internal();
  factory GoogleAuthService() => _instance;
  GoogleAuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  /// Sign in with Google natively
  /// Returns the access token if successful
  Future<String?> signInWithGoogle() async {
    try {
      // Trigger the native Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Get the access token
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception('Failed to get Google authentication tokens');
      }

      // Sign in to Supabase with the Google credentials
      final response = await SupabaseConfig.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.session != null) {
        // Return the Supabase access token
        return response.session?.accessToken;
      }

      throw Exception('Failed to sign in with Google');
    } catch (e) {
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
