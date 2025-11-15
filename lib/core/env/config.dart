// ignore_for_file: constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  // Keys (constants)
  static const API_BASE_URL = 'API_BASE_URL';

  // Internal singleton fields
  static Future<Config>? _loader;
  static Config? _instance;

  Config._internal();

  // This allows: await Config.instance;
  static Future<Config> get instance {
    _loader ??= _load();
    return _loader!;
  }

  static Future<Config> _load() async {
    await dotenv.load(fileName: '.env');
    _instance = Config._internal();
    return _instance!;
  }

  // Sync accessor after initialization
  static Config get I {
    if (_instance == null) {
      throw Exception('Config not initialized. Await Config.instance first.');
    }
    return _instance!;
  }

  // Internal method to get values from dotenv
  String _get(String key) {
    return dotenv.get(key);
  }

  // Typed getters
  String get baseUrl => _get(API_BASE_URL);
}
