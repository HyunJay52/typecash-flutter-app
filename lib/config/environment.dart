class Environment {
  // static const String apiUrl = 'https://api.example.com';

  static late final String apiUrl;
  
  Environment(String environment, String server) {
    if (environment == 'production') {
      apiUrl = 'https://api.example.com';
    } else if (environment == 'staging') {
      apiUrl = 'https://staging-api.example.com';
    } else if (environment == 'development') {
      apiUrl = 'http://localhost:3000';
    } else {
      throw Exception('Invalid environment: $environment');
    }

    if (server == 'production') {
      apiUrl = 'https://api.example.com';
    } else if (server == 'staging') {
      apiUrl = 'https://staging-api.example.com';
    } else if (server == 'development') {
      apiUrl = 'http://localhost:3000';
    } else {
      throw Exception('Invalid server: $server');
    }
  }
}
