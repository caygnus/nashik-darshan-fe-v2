import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:nashik/core/infrastructure/dio/config.dart';

final locator = GetIt.instance;

Future<void> serviceLocatorInit() async {
  // Initialize encrypted secure storage
  const FlutterSecureStorage secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  locator.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);

  // Register DioClient
  locator.registerLazySingleton<DioClient>(() => DioClient());

  // Register your features' dependencies here following this pattern:
  // 1. Data Sources
  // 2. Repositories
  // 3. Use Cases
  // 4. Blocs
}
