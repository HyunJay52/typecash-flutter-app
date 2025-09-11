import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:typecash_flutter_app/apis/typecash_apis.dart';
import 'package:typecash_flutter_app/providers/user_provider.dart';

class AuthProvider with ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _autoLogoutTimer;
  // 기존 필드 유지
  BuildContext? _context;
  

  final _secureStorage = const FlutterSecureStorage();

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  // 컨텍스트 설정 메서드
  void setContext(BuildContext context) {
    _context = context;
  }

  // 인터셉터 설정 메서드 추가
  void setupInterceptor() {
    TypecashApis().setAuthInterceptor(this);
  }


  Future<bool> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 저장된 토큰 불러오기
      _accessToken = await _secureStorage.read(key: 'accessToken');
      _refreshToken = await _secureStorage.read(key: 'refreshToken');

      debugPrint('Access Token: $_accessToken');
      debugPrint('Refresh Token: $_refreshToken');

      // 토큰 만료 시간 확인
      final expiryTimeString = await _secureStorage.read(key: 'tokenExpiry');
      debugPrint('Token Expiry Time: $expiryTimeString');

      setupInterceptor();

      if (_accessToken != null && expiryTimeString != null) {
        final expiryTime = DateTime.parse(expiryTimeString);

        // 현재 시간이 만료 시간보다 이전인 경우 (토큰 유효)
        if (expiryTime.isAfter(DateTime.now())) {
          _isAuthenticated = true;
          _setAutoLogoutTimer(expiryTime);
          notifyListeners();
          return true;
        }
        // 토큰 만료된 경우 refresh 토큰으로 갱신 시도
        else if (_refreshToken != null) {
          return await refreshTokens();
        }
      }

      // 저장된 토큰이 없거나 갱신 실패
      _isAuthenticated = false;
      await _clearTokens();
      return false;
    } catch (e) {
      debugPrint('인증 초기화 오류: $e');
      _isAuthenticated = false;
      await _clearTokens();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password, bool keepLoggedIn) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TypecashApis 인스턴스를 사용한 로그인 API 호출
      final response = await TypecashApis().loginUser(
        email: email,
        password: password,
      ); 
      debugPrint('로그인 응답: ${response.data}');

      // 응답에서 토큰 추출
      final data = response.data;
      _accessToken = data['accessToken'];
      _refreshToken = data['refreshToken'];
       // * UserProvider에 사용자 정보 설정
      final userData = data['user'];
      if(userData != null) {
        final userProvider = Provider.of<UserProvider>(_context!, listen: false);
        userProvider.setUserInfo(
          userId: userData['id'],
          email: userData['email'],
          rewardBalance: userData['rewardBalance'],
        );
      }

      // 토큰 만료 시간 계산 (예: 액세스 토큰 만료 시간이 1시간인 경우)
      final expiryTime = DateTime.now().add(Duration(hours: 1));
      
      // 토큰 저장
      if(keepLoggedIn) {
        await _saveTokens(_accessToken!, _refreshToken!, expiryTime);
      } else {
        // 로그인 유지하지 않는 경우, 토큰은 메모리에만 저장
        await _clearTokens();
      }

      _isAuthenticated = true;
      _setAutoLogoutTimer(expiryTime);

      return true;
    } catch (e) {
      print('로그인 오류: $e');

      // DioException 처리
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          switch (statusCode) {
            case 401:
              _errorMessage = '이메일 또는 비밀번호가 올바르지 않습니다.';
              break;
            case 404:
              _errorMessage = '존재하지 않는 사용자입니다.';
              break;
            default:
              _errorMessage = '로그인 중 오류가 발생했습니다. 다시 시도해주세요.';
          }
        } else {
          _errorMessage = '네트워크 연결을 확인해주세요.';
        }
      } else {
        _errorMessage = '로그인 중 오류가 발생했습니다.';
      }

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Example: logout method
  Future<void> logout() async {
    // 자동 로그아웃 타이머 취소
    _autoLogoutTimer?.cancel();

    // 서버에 로그아웃 요청 (선택 사항)
    // try {
    //   await TypecashApis().logoutUser(accessToken: _accessToken!);
    // } catch (e) {
    //   print('로그아웃 API 호출 오류: $e');
    // }

    // // 로컬 상태 및 저장소 초기화
    // _isAuthenticated = false;
    // await _clearTokens();

    notifyListeners();
  }

   Future<bool> refreshTokens() async {
    try {
      final response = await TypecashApis().refreshToken(
        _refreshToken!,
      );

      final data = response.data;
      _accessToken = data['accessToken'];
      _refreshToken = data['refreshToken']; // 새 리프레시 토큰이 제공되는 경우

      // 토큰 만료 시간 계산 (예: 액세스 토큰 만료 시간이 1시간인 경우)
      final expiryTime = DateTime.now().add(Duration(hours: 1));
  
      await _saveTokens(_accessToken!, _refreshToken!, expiryTime);

      _isAuthenticated = true;
      _setAutoLogoutTimer(expiryTime);
      notifyListeners();

      return true;
    } catch (e) {
      print('토큰 갱신 오류: $e');
      _isAuthenticated = false;
      await _clearTokens();
      notifyListeners();
      return false;
    }
  }

  // 토큰 저장 헬퍼 함수
  Future<void> _saveTokens(
    String accessToken,
    String refreshToken,
    DateTime expiryTime,
  ) async {
    await _secureStorage.write(key: 'accessToken', value: accessToken);
    await _secureStorage.write(key: 'refreshToken', value: refreshToken);
    await _secureStorage.write(
      key: 'tokenExpiry',
      value: expiryTime.toIso8601String(),
    );
  }

  // 토큰 삭제 헬퍼 함수
  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: 'accessToken');
    await _secureStorage.delete(key: 'refreshToken');
    await _secureStorage.delete(key: 'tokenExpiry');

    _accessToken = null;
    _refreshToken = null;
  }
  
    // 자동 로그아웃 타이머 설정 함수
  void _setAutoLogoutTimer(DateTime expiryTime) {
    _autoLogoutTimer?.cancel();
    final timeToExpiry = expiryTime.difference(DateTime.now());

    // 토큰 만료 10분 전에 갱신 시도
    final refreshTime = timeToExpiry - Duration(minutes: 10);

    if (refreshTime.isNegative) {
      // 이미 만료 시간이 10분 미만 남았다면 즉시 갱신
      refreshTokens();
    } else {
      _autoLogoutTimer = Timer(refreshTime, () {
        // 토큰 갱신 시도
        refreshTokens();
      });
    }
  }

  // 앱 종료 시 리소스 정리
  @override
  void dispose() {
    _autoLogoutTimer?.cancel();
    super.dispose();
  }
}
