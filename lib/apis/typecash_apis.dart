import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:typecash_flutter_app/apis/auth_interceptor.dart';
import 'package:typecash_flutter_app/config/environment.dart';
import 'package:typecash_flutter_app/models/gift_type.dart';
import 'package:typecash_flutter_app/providers/auth_provider.dart';

class TypecashApis {
  static final TypecashApis _instance = TypecashApis._internal();
  factory TypecashApis() => _instance;

  // User endpoints
  static const String usersEndpoint = '/user';
  // Authentication endpoints
  static const String authEndpoint = '/auth';
  // Mission endpoints
  static const String missionsEndpoint = '/mission';
  // Ad endpoints
  static const String adsEndpoint = '/ad';
  // Point endpoints
  static const String pointsEndpoint = '/point';

  // * 인증이 필요없는 공개 API용 Dio 인스턴스
  final Dio _publicDio = Dio(
    BaseOptions(
      baseUrl:
          Environment.serverType == ServerType.production
              ? 'https://input-server-dns.com' // 실제 프로덕션 서버 URL
              : 'http://192.168.45.8:3000', //'http://10.0.2.2:3000', // Android 에뮬레이터에서 로컬 서버 접근
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // * 인증이 필요한 보호된 API용 Dio 인스턴스
  final Dio _authDio = Dio(
    BaseOptions(
      baseUrl:
          Environment.serverType == ServerType.production
              ? 'https://input-server-dns.com' // 실제 프로덕션 서버 URL
              : 'http://192.168.45.8:3000', //'http://10.0.2.2:3000', // Android 에뮬레이터에서 로컬 서버 접근
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  TypecashApis._internal() {
    // 공통 인터셉터 설정 (로깅)
    final logInterceptor = LogInterceptor(
      request: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
      error: true,
    );
    
    // 공개 API용 인터셉터 설정
    _publicDio.interceptors.add(logInterceptor);
    
    // 인증 API용 인터셉터 설정 (로그 인터셉터만 추가)
    _authDio.interceptors.add(logInterceptor);
    
    // SSL Pinning 등 기본 보안 설정
    // ...
  }
  
  // 인증 인터셉터 설정 메서드
  void setAuthInterceptor(AuthProvider authProvider) {
    // 기존 인증 인터셉터만 제거 (로그 인터셉터 유지)
    _authDio.interceptors.removeWhere(
      (interceptor) => interceptor is AuthInterceptor,
    );

    // 인증 인터셉터 추가
    debugPrint('auth provider: ${authProvider.toString()}');
    _authDio.interceptors.add(AuthInterceptor(authProvider));
  }

  // * User Apis
  Future<Response> registerUser({
    required String email,
    required String password,
  }) async {
    final data = {'email': email, 'password': password};
    return await _publicDio.post(usersEndpoint, data: data);
  }

  // * Authentication Apis
  Future<Response> loginUser({
    required String email,
    required String password,
  }) async {
    final data = {'email': email, 'password': password};

    debugPrint('로그인 요청: $data');

    return await _publicDio.post('$authEndpoint/login', data: data);
  }

  Future<Response> logoutUser(String userId) async {
    // 로그아웃은 인증이 필요한 API
    return await _authDio.post('$usersEndpoint/$userId/logout');
  }

  Future<Response> refreshToken(String refreshToken) async {
    // 토큰 갱신 로직 구현
    // 토큰 갱신은 인증이 필요 없음(만료된 accessToken)
    return await _publicDio.post(
      '$authEndpoint/refresh-token',
      data: {'refreshToken': refreshToken},
    );
  }

  // todo : 비밀번호를 잊어버린 경우 비밀번호 재설정 요청
  Future<Response> forgotPassword({
    required email,
    required String userId,
    required String newPassword,
  }) async {
    final data = {'newPassword': newPassword};
    return await _publicDio.post(
      '$usersEndpoint/$userId/change-password',
      data: data,
    );
  }

  // 로그인 후 비밀번호 변경
  Future<Response> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    final data = {'oldPassword': oldPassword, 'newPassword': newPassword};
    return await _authDio.post(
      '$usersEndpoint/$userId/change-password',
      data: data,
    );
  }

  Future<Response> getUserProfile(String userId) async {
    // 사용자 프로필 조회는 인증이 필요한 API
    return await _authDio.get('$usersEndpoint/$userId');
  }

  Future<Response> sendEmailVerificationCode({required String email}) async {
    final data = {'email': email};
    // 이메일 인증 코드 발송은 인증이 필요 없는 API
    return await _publicDio.post('$usersEndpoint/send-verification-code', data: data);
  }

  // * Mission Apis
  Future<Response> getDailyMissionSummary() async {
    // 일일 요약 정보는 인증이 필요한 API
    return await _authDio.get('$missionsEndpoint/daily-mission-summary');
  }

  Future<Response> submitMission({
    required int missionId,
    required String answer
  }) async {
    final data = {
      'missionId': missionId,
      'answer': answer,
    };
    return await _authDio.post('$missionsEndpoint/submit', data: data);
  }

  // * Ad Apis
  Future<Response> recordAdWatched({
    required String adId,
    required String userId,
  }) async {
    final data = {
      'adId': adId,
      'userId': userId,
      'watchedAt': DateTime.now().toIso8601String(),
    };
    // 광고 시청 기록은 인증이 필요한 API
    return await _authDio.post('$adsEndpoint/watched', data: data);
  }

  // * Point/Reward Apis
  Future<Response> getUserPoints(String userId) async {
    // 포인트 조회는 인증이 필요한 API
    return await _authDio.get('$pointsEndpoint/$userId');
  }

  Future<Response> updateRewardAmount({
    required int amount,
  }) async {
    final data = {'amount': amount};
    // 포인트 추가는 인증이 필요한 API
    return await _authDio.post('$pointsEndpoint/ad-watch-reward', data: data);
  }

  Future<Response> redeemPoints({
    required int pointsToUse,
    required String giftCardId,
    required String phoneNumber,
  }) async {
    // ! giftCardId, pointsToUse, phoneNumber
    debugPrint('API 포인트 사용 요청: pointsToUse=$pointsToUse, giftCardId=$giftCardId, phoneNumber=$phoneNumber');
    final data = {'pointsToUse': pointsToUse, 'giftCardId': giftCardId, 'phoneNumber': phoneNumber};
    // 포인트 사용은 인증이 필요한 API
    return await _authDio.post('$pointsEndpoint/redeem/giftcard', data: data);
  }

  Future<Response> getRewardHistory(String userId) async {
    // 리워드 내역 조회는 인증이 필요한 API
    return await _authDio.get('$pointsEndpoint/$userId/history');
  }

  // * Etc Apis
  Future<Response> getServerStatus() async {
    // 서버 상태 확인은 인증이 필요 없는 API
    return await _publicDio.get('/status');
  }
}
