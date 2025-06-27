import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:typecash_flutter_app/apis/typecash_apis.dart';
import 'package:typecash_flutter_app/utils/string_format_util.dart';

class JoinUserProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordController = TextEditingController();

  // 에러 메시지 상태
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  // 약관 동의 상태
  bool _agreeToTerms = false;
  bool _agreeToPrivacy = false;

  // API 호출 상태
  bool _isLoading = false;
  String? _errorMessage;

  JoinUserProvider() {
    // 초기화 작업이 필요하다면 여기에 작성
    // 컨트롤러 변경 리스너 설정
  }

  // Getters
  bool get agreeToTerms => _agreeToTerms;
  bool get agreeToPrivacy => _agreeToPrivacy;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 약관 동의 토글 메서드
  void toggleAgreeToTerms() {
    _agreeToTerms = !_agreeToTerms;
    notifyListeners();
  }

  void toggleAgreeToPrivacy() {
    _agreeToPrivacy = !_agreeToPrivacy;
    notifyListeners();
  }

  String onUnfocusEmailTextField() {
    final inputEmail = emailController.text;
    if (!StringFormatUtil.isValidEmailFormat(inputEmail)) {
      emailError = '유효한 이메일 형식을 입력해주세요.';
    } else {
      emailError = null;
    }
    notifyListeners();
    return emailError ?? inputEmail;
  }

  String onUnfocusPasswordTextField() {
    final inputPassword = passwordController.text;
    if (!StringFormatUtil.isValidPasswordFormat(inputPassword)) {
      passwordError = '숫자 1개, 특수문자(@, !, *, -, _) 1개 이상 포함된 8자 이상이어야 합니다';
    } else {
      passwordError = null;
    }
    notifyListeners();
    return passwordError ?? inputPassword;
  }

  String onUnfocusConfirmPasswordTextField() {
    final inputConfirmPassword = confirmPasswordController.text;
    if (!StringFormatUtil.areStringsEqual(
      inputConfirmPassword,
      passwordController.text,
    )) {
      confirmPasswordError = '비밀번호가 일치하지 않습니다';
    } else {
      confirmPasswordError = null;
    }
    notifyListeners();
    return confirmPasswordError ?? inputConfirmPassword;
  }

  Future<bool> handleSubmit() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      // 마지막 유효성 검사
      final emailValid = StringFormatUtil.isValidEmailFormat(emailController.text);
      final passwordValid = StringFormatUtil.isValidPasswordFormat(passwordController.text);
      final passwordsMatch = StringFormatUtil.areStringsEqual(
        passwordController.text,
        confirmPasswordController.text,
      );

      if (!emailValid || !passwordValid || !passwordsMatch) {
        _errorMessage = '입력한 정보가 올바르지 않습니다. 다시 확인해주세요.';
        notifyListeners();
        return false;
      }

      if (!_agreeToTerms || !_agreeToPrivacy) {
        _errorMessage = '이용약관과 개인정보 수집에 동의해주세요';
        notifyListeners();
        return false;
      }

      _isLoading = true; // 로딩 상태 시작
      _errorMessage = null; // 이전 에러 메시지 초기화
      notifyListeners();

      final result = await submitJoinRequest();
      print('가입 요청 결과: $result');
      return result;
    } else {
      // 폼이 유효하지 않은 경우 에러 메시지 표시
      _errorMessage = '입력한 정보가 올바르지 않습니다. 다시 확인해주세요.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitJoinRequest() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await TypecashApis().registerUser(
        email: emailController.text,
        password: passwordController.text,
      );

      print('회원가입 성공: $response');
      return true;
    } catch (e) {
      print('가입 요청 실패: $e');
      
      // DioException 처리
      if (e is DioException) {
        // 서버 응답이 있는 경우
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          
          switch (statusCode) {
            case 409:
              _errorMessage = '이미 사용 중인 이메일입니다. 다른 이메일을 사용해주세요.';
              break;
            case 400:
              // 서버에서 보낸 에러 메시지가 있으면 사용
              try {
                final serverMessage = e.response!.data['message'];
                if (serverMessage is String && serverMessage.isNotEmpty) {
                  _errorMessage = serverMessage;
                } else {
                  _errorMessage = '입력 정보가 올바르지 않습니다. 다시 확인해주세요.';
                }
              } catch (_) {
                _errorMessage = '입력 정보가 올바르지 않습니다. 다시 확인해주세요.';
              }
              break;
            case 500:
              _errorMessage = '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
              break;
            default:
              _errorMessage = '회원가입 중 오류가 발생했습니다. (상태 코드: $statusCode)';
          }
        } 
        // 요청 자체가 실패한 경우 (응답이 없음)
        else {
          switch (e.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.receiveTimeout:
            case DioExceptionType.sendTimeout:
              _errorMessage = '서버 응답 시간이 초과되었습니다. 네트워크 상태를 확인해주세요.';
              break;
            case DioExceptionType.badCertificate:
              _errorMessage = '보안 연결에 문제가 있습니다. 네트워크 설정을 확인해주세요.';
              break;
            case DioExceptionType.connectionError:
              _errorMessage = '네트워크 연결을 확인해주세요.';
              break;
            default:
              _errorMessage = '회원가입 중 오류가 발생했습니다. 다시 시도해주세요.';
          }
        }
      } 
      // 기타 예외 처리
      else if (e is TimeoutException) {
        _errorMessage = '서버 응답 시간이 초과되었습니다. 네트워크 상태를 확인해주세요.';
      } else if (e is SocketException) {
        _errorMessage = '네트워크 연결을 확인해주세요.';
      } else {
        _errorMessage = '회원가입 중 오류가 발생했습니다: ${e.toString()}';
      }
      
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetForm() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    emailError = null;
    passwordError = null;
    confirmPasswordError = null;
    _agreeToTerms = false;
    _agreeToPrivacy = false;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // 리소스 해제
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
