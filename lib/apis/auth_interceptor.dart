import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:typecash_flutter_app/providers/auth_provider.dart';

class AuthInterceptor extends Interceptor {
  // BuildContext 대신 AuthProvider 직접 참조
  final AuthProvider authProvider;
  
  // 토큰이 필요하지 않은 공개 API 경로 목록
  final List<String> _publicPaths = [
    '/auth/login',
    '/auth/register',
    '/user', // 회원가입 엔드포인트
    '/user/change-password', // 비밀번호 변경
    '/user/forgot-password', // 비밀번호 재설정 요청
    '/user/verify-email', // 이메일 인증
    '/user/verify-email/resend', // 이메일 인증 재전송
    '/user/verify-email/check', // 이메일 인증 확인
    '/user/check-email', // 이메일 중복 확인
    '/user/send-verification-code', // 이메일 인증 코드 발송
    '/auth/forgot-password',
    '/auth/refresh-token', // 토큰 갱신
    '/status', // 서버 상태 확인
  ];

  AuthInterceptor(this.authProvider);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 요청 경로가 공개 API 경로인지 확인
    final isPublicPath = _publicPaths.any(
      (path) => options.path.contains(path),
    );

    if (!isPublicPath) {
      if (authProvider.isAuthenticated && authProvider.accessToken != null) {
        options.headers['Authorization'] = 'Bearer ${authProvider.accessToken}';
        debugPrint('토큰 헤더 추가: ${options.path}');
      } else {
        debugPrint('인증 필요 API 호출이지만 토큰이 없음: ${options.path}');
      }
    } else {
      debugPrint('공개 API 경로: ${options.path}');
    }
    return super.onRequest(options, handler); 
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 오류(Unauthorized) 발생 시 토큰 갱신 시도
    if (err.response?.statusCode == 401) {
      // 토큰 갱신 시도
      final refreshed = await authProvider.refreshTokens();

      if (refreshed) {
        // 원래 요청 재시도
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer ${authProvider.accessToken}';

        try {
          final response = await Dio().fetch(options);
          return handler.resolve(response);
        } catch (e) {
          debugPrint('재시도 실패: $e');
          // 재시도 실패 시 원래 에러 처리로 돌아감
        }
      } else {
        // 토큰 갱신 실패 시 로그아웃 처리
        await authProvider.logout();
        // 로그아웃 이후 처리는 AuthProvider에서 처리
      }
    }

    return super.onError(err, handler);
  }
}
