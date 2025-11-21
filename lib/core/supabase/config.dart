// ignore_for_file: constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

/// Supabase configuration and global instance manager
class SupabaseConfig {
  // Environment variable keys
  static const String SUPABASE_URL_KEY = 'SUPABASE_URL';
  static const String SUPABASE_PUBLISHABLE_KEY = 'SUPABASE_PUBLISHABLE_KEY';

  // Singleton instance
  static SupabaseConfig? _instance;
  static SupabaseClient? _client;

  SupabaseConfig._internal();

  /// Get singleton instance
  static SupabaseConfig get instance {
    if (_instance == null) {
      throw Exception(
        'SupabaseConfig not initialized. Call SupabaseConfig.initialize() first.',
      );
    }
    return _instance!;
  }

  /// Initialize Supabase with environment variables
  static Future<SupabaseConfig> initialize() async {
    if (_instance != null) {
      return _instance!;
    }

    try {
      // Get values from environment variables
      final supabaseUrl = dotenv.get(SUPABASE_URL_KEY);
      final supabaseAnonKey = dotenv.get(SUPABASE_PUBLISHABLE_KEY);

      // Validate that values are not empty
      if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
        throw Exception('Supabase URL or Anon Key is missing in .env file');
      }

      // Initialize Supabase with PKCE auth flow
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
      ); 

      // Get the client instance
      _client = Supabase.instance.client;

      // Create singleton instance
      _instance = SupabaseConfig._internal();

      return _instance!;
    } catch (e) {
      throw Exception('Failed to initialize Supabase: $e');
    }
  }

  /// Get the global Supabase client instance
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception(
        'Supabase client not initialized. Call SupabaseConfig.initialize() first.',
      );
    }
    return _client!;
  }
}
