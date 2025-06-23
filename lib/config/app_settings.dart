// Typecase app settings
abstract class AppSettings {
  String get apiBaseUrl;
  // String get adminBaseUrl;
  // String get serviceBaseUrl;

  // String get awsS3ApiBaseUrl;
  // String get awsAccessKey;
  // String get awsSecretKey;

  // String get firebaseAppId;
  // String get firebaseApiKey;
  // String get firebaseProjectId;
  // String get firebaseMessagingSenderId;
  // String get firebaseDynamicLinkUrl;
}

class ProductionAppSettings implements AppSettings {
  @override
  String get apiBaseUrl => 'https://prod-api.yourdomain.com/v1';
}

class StagingAppSettings implements AppSettings {
  @override
  String get apiBaseUrl => 'https://staging-api.yourdomain.com/v1';
}

class DevelopmentAppSettings implements AppSettings {
  @override
  String get apiBaseUrl => 'http://dev-api.yourdomain.com/v1';
}

class LocalAppSettings implements AppSettings {
  @override
  String get apiBaseUrl => 'http://localhost:3000/'; // android 에뮬레이터에서 로컬 서버 접근
}