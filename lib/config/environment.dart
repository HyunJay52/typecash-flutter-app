import 'package:flutter/foundation.dart';
import 'package:typecash_flutter_app/config/app_settings.dart';

enum EnvironmentType { production, staging, development, local }

enum ServerType { production, staging, development, local }

class EnvironmentConfig {
  final EnvironmentType environmentType;
  final ServerType serverType;

  EnvironmentConfig({required this.environmentType, required this.serverType});

  /// flavor 문자열로부터 환경 설정 생성
  static EnvironmentConfig fromFlavor(String flavor) {
    switch (flavor) {
      case 'prod':
        return EnvironmentConfig(
          environmentType: EnvironmentType.production,
          serverType: ServerType.production,
        );
      case 'dev':
        return EnvironmentConfig(
          environmentType: EnvironmentType.development,
          serverType: ServerType.development,
        );
      case 'staging':
        return EnvironmentConfig(
          environmentType: EnvironmentType.staging,
          serverType: ServerType.staging,
        );
      default:
        return EnvironmentConfig(
          environmentType: EnvironmentType.local,
          serverType: ServerType.local,
        );
    }
  }
}

class Environment {
  static final Environment _instance = Environment._internal();
  factory Environment() => _instance;

  static late EnvironmentType environmentType;
  static late ServerType serverType;

  static late final String apiUrl;

  bool _isInitialized = false;

  Environment._internal();

  void initialize({
    required EnvironmentType environment,
    required ServerType server,
  }) {
    if (_isInitialized) return;

    environmentType = environment;
    serverType = server;

    // final appSettings = _getAppSettings

    _isInitialized = true;

     debugPrint(
      'Environment initialized: $environmentType, Server: $serverType',
    );
  }

  AppSettings getAppSettings(ServerType type) {
    switch (type) {
      case ServerType.production:
        return ProductionAppSettings();
      case ServerType.staging:
        return StagingAppSettings();
      case ServerType.development:
        return DevelopmentAppSettings();
      case ServerType.local:
        return LocalAppSettings();
    }
  }

  static bool get isProd => environmentType == EnvironmentType.production;
  static bool get isStaging => environmentType == EnvironmentType.staging;
  static bool get isDevelopment =>
      environmentType == EnvironmentType.development;
  static bool get isLocal => environmentType == EnvironmentType.local;
  
}
