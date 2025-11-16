import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nashik/core/supabase/config.dart';
import 'package:nashik/features/auth/domain/usecases/get_current_user.dart';
import 'package:nashik/features/auth/domain/usecases/signin_with_email.dart';
import 'package:nashik/features/auth/domain/usecases/signup_with_email.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class AuthCubit extends Cubit<AuthState> {
  final SignupWithEmail signupWithEmail;
  final SigninWithEmail signinWithEmail;
  final GetCurrentUser getCurrentUser;

  AuthCubit({
    required this.signupWithEmail,
    required this.signinWithEmail,
    required this.getCurrentUser,
  }) : super(const AuthState.initial()) {
    _initializeAuthState();
  }

  void _initializeAuthState() {
    // Listen to auth state changes
    SupabaseConfig.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        _loadCurrentUser();
      } else if (event == AuthChangeEvent.signedOut) {
        emit(const AuthState.unauthenticated());
      }
    });

    // Check initial auth state
    final user = SupabaseConfig.client.auth.currentUser;
    if (user != null) {
      _loadCurrentUser();
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _loadCurrentUser() async {
    final result = await getCurrentUser();
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  /// Sign up with email and password
  /// This orchestrates: Supabase signup -> Backend signup
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    emit(const AuthState.loading());

    final params = SignupWithEmailParams(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );

    final result = await signupWithEmail(params);

    result.fold((failure) => emit(AuthState.error(failure.message)), (_) async {
      // After successful signup, load the current user
      await _loadCurrentUser();
    });
  }

  /// Sign in with email and password
  /// This orchestrates: Supabase signin -> Get user from backend
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(const AuthState.loading());

    final params = SigninWithEmailParams(email: email, password: password);

    final result = await signinWithEmail(params);

    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      emit(const AuthState.loading());
      await SupabaseConfig.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.nashikdarshan://login-callback/',
      );
      // Note: The actual authentication will be handled by the auth state listener
    } catch (e) {
      emit(AuthState.error('Failed to sign in with Google: ${e.toString()}'));
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await SupabaseConfig.client.auth.signOut();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error('Failed to sign out: ${e.toString()}'));
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
      emit(
        AuthState.error('Failed to send password reset email: ${e.toString()}'),
      );
    }
  }
}
