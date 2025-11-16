import 'package:nashik/core/error/exceptions/server_exception.dart';
import 'package:nashik/core/supabase/config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Data source for Supabase authentication operations
/// This handles the Supabase-specific authentication logic
abstract class AuthSupabaseDataSource {
  /// Sign up with email and password in Supabase
  /// Returns the access token from Supabase
  Future<String> signUpWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with email and password in Supabase
  /// Returns the access token from Supabase
  Future<String> signInWithEmail({
    required String email,
    required String password,
  });

  /// Get current Supabase session access token
  String? getCurrentAccessToken();
}

class AuthSupabaseDataSourceImpl implements AuthSupabaseDataSource {
  @override
  Future<String> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await SupabaseConfig.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.session == null) {
        throw ServerException(
          message: 'Sign up failed: No session returned',
          code: 'SUPABASE_SIGNUP_FAILED',
        );
      }

      return response.session!.accessToken;
    } on AuthException catch (e) {
      throw ServerException(message: e.message, code: 'SUPABASE_AUTH_ERROR');
    } catch (e) {
      throw ServerException(
        message: 'Failed to sign up with Supabase: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  @override
  Future<String> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) {
        throw ServerException(
          message: 'Sign in failed: No session returned',
          code: 'SUPABASE_SIGNIN_FAILED',
        );
      }

      return response.session!.accessToken;
    } on AuthException catch (e) {
      throw ServerException(message: e.message, code: 'SUPABASE_AUTH_ERROR');
    } catch (e) {
      throw ServerException(
        message: 'Failed to sign in with Supabase: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  @override
  String? getCurrentAccessToken() {
    try {
      final session = SupabaseConfig.client.auth.currentSession;
      return session?.accessToken;
    } catch (e) {
      return null;
    }
  }
}
