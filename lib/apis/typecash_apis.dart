import 'package:dio/dio.dart';
import 'package:typecash_flutter_app/config/environment.dart';

class TypecashApis {
  static final TypecashApis _instance = TypecashApis._internal();
  factory TypecashApis() => _instance;

  // * Ad endpoints
  static const String adsEndpoint = '/ad';
  // * User endpoints
  static const String usersEndpoint = '/user';
  // * Point endpoints
  static const String pointsEndpoint = '/point';
  
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 
          Environment.serverType == ServerType.production
              ? 'https://input-server-dns.com' // 실제 프로덕션 서버 URL
              : 'http://10.0.2.2:3000', // Android 에뮬레이터에서 로컬 서버 접근
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer YOUR_TOKEN', // 필요시 토큰 추가
      },
    ),
  );

  TypecashApis._internal() {

    _dio.interceptors.add(LogInterceptor(
      request: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
      error: true,
    ));

    // 보안 설정: HTTPS 강제, 인증서 검증 등
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // 예: 동적으로 토큰 추가
        // options.headers['Authorization'] = 'Bearer ${getToken()}';
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // 에러 로깅 또는 처리
        return handler.next(e);
      },
    ));

    // SSL Pinning 등 추가 보안 설정이 필요하다면 여기에 구현
  }

  // * User Apis
  Future<Response> apiTestByUser() async {
    final response = await _dio.get('$usersEndpoint/123');
    
    return response;
  }

  Future<Response> registerUser({
    required String email,
    required String password,
    required String nickname,
  }) async {
    final data = {
      'email': email,
      'password': password,
      'nickname': nickname,
    };
    return await _dio.post('$usersEndpoint/register', data: data);
  }

  Future<Response> loginUser({
    required String email,
    required String password,
  }) async {
    final data = {
      'email': email,
      'password': password,
    };
    return await _dio.post('$usersEndpoint/login', data: data);
  }

  Future<Response> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    final data = {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
    return await _dio.post('$usersEndpoint/$userId/change-password', data: data);
  }

  Future<Response> getUserProfile(String userId) async {
    return await _dio.get('$usersEndpoint/$userId');
  }

  Future<Response> sendEmailVerificationCode({
    required String email,
  }) async {
    final data = {
      'email': email,
    };
    return await _dio.post('$usersEndpoint/send-verification-code', data: data);
  }


  // * Ad Apis
  Future<Response> recordAdWatched({required String adId, required String userId}) async {
    final data = {
      'adId': adId,
      'userId': userId,
      'watchedAt': DateTime.now().toIso8601String(),
    };
    return await _dio.post('$adsEndpoint/watched', data: data);
  }

  // * Point Apis
  Future<Response> getUserPoints(String userId) async {
    return await _dio.get('$pointsEndpoint/$userId');
  }

  Future<Response> addPoints({
    required String userId,
    required int points,
    required String reason,
  }) async {
    final data = {
      'userId': userId,
      'points': points,
      'reason': reason,
    };
    return await _dio.post('$pointsEndpoint/add', data: data);
  }

  Future<Response> redeemPoints({
    required String userId,
    required int points,
    required String rewardId,
  }) async {
    final data = {
      'userId': userId,
      'points': points,
      'rewardId': rewardId,
    };
    return await _dio.post('$pointsEndpoint/redeem', data: data);
  }

  Future<Response> getRewardHistory(String userId) async {
    return await _dio.get('$pointsEndpoint/$userId/history');
  }
}