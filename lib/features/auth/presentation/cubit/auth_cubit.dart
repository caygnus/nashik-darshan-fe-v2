import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nashik/core/supabase/config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial()) {
    // Listen to auth state changes
    SupabaseConfig.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        emit(AuthAuthenticated(session.user.id));
      } else if (event == AuthChangeEvent.signedOut) {
        emit(AuthUnauthenticated());
      }
    });

    // Check initial auth state
    final user = SupabaseConfig.client.auth.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user.id));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// Sign in with email and password
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        emit(AuthAuthenticated(response.user!.id));
      } else {
        emit(const AuthError('Sign in failed. Please try again.'));
      }
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      emit(AuthLoading());
      await SupabaseConfig.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.nashikdarshan://login-callback/',
      );
      // Note: The actual authentication will be handled by the auth state listener
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  /// Sign up with email and password
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final response = await SupabaseConfig.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        emit(AuthAuthenticated(response.user!.id));
      } else {
        emit(const AuthError('Sign up failed. Please try again.'));
      }
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await SupabaseConfig.client.auth.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Failed to sign out: ${e.toString()}'));
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await SupabaseConfig.client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.nashikdarshan://reset-password/',
      );
    } catch (e) {
      emit(AuthError('Failed to send password reset email: ${e.toString()}'));
    }
  }
}
