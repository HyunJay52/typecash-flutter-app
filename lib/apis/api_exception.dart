class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic data;

  ApiException({required this.statusCode, required this.message, this.data});

  @override
  String toString() {
    // todo : add error log to console or file
    return 'ApiException(statusCode: $statusCode, message: $message)';
  }
}
