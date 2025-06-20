import 'package:flutter/material.dart';
import 'package:typecash_flutter_app/screens/ad/ad_page.dart';
import 'package:typecash_flutter_app/screens/user/join_user_page.dart';

import '../home/typecash_home_page.dart';
import 'password_reset_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _emailError = ValueNotifier<String?>(null);

  final _passwordController = TextEditingController();
  final _passwordError = ValueNotifier<String?>(null);

  @override
  void dispose() {
    _emailController.dispose();
    _emailError.dispose();
    _passwordController.dispose();
    _passwordError.dispose();
    super.dispose();
  }

  void validateEmail(String email) {
    const emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (RegExp(emailRegex).hasMatch(email)) {
      _emailError.value = null;
    } else {
      _emailError.value = '유효한 이메일 주소를 입력해주세요.';
    }
  }

  void validatePassword(String password) {
    const passwordRegex = r'^(?=.*[0-9])(?=.*[@!*_-]).{8,}$';
    if (RegExp(passwordRegex).hasMatch(password)) {
      _passwordError.value = null;
    } else {
      _passwordError.value =
          '숫자 1개, 특수문자(@, !, *, -, _) 1개 이상 포함된 8자 이상이어야 합니다.';
    }
  }

  Future<bool> _checkLoginStatus() async {
    // 여기에 로그인 상태를 확인하는 로직을 추가합니다.
    // 예시로, 로그인 상태가 아니라고 가정합니다.
    return false; // 로그인 상태가 아니라고 가정
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data == true) {
            // 이미 로그인 상태면 메인화면으로 이동
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(
                context,
                TypecashHomePage.routeName,
              );
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // 로그인 화면 - GestureDetector 위치 변경 및 구성 수정
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    // 이미 포커스가 있는 위젯이 있을 때만 unfocus 실행
                    if (!FocusScope.of(context).hasPrimaryFocus) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 로고 및 슬로건
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 70),
                          Image.asset(
                            'assets/images/logo_v2.png',
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '한 줄로 쌓는 작은 보상',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3745),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 70),

                      // 이메일 입력
                      const Text(
                        '이메일',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3745),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ValueListenableBuilder<String?>(
                        valueListenable: _emailError,
                        builder: (context, error, child) {
                          return TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: validateEmail,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, // 약간 줄임
                                horizontal: 12,
                              ),
                              hintText: 'honggildong@naver.com',
                              hintStyle: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                              errorText: error,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 15),

                      // 비밀번호 입력 (수정: valueListenable 오류 수정)
                      const Text(
                        '비밀번호',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3745),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ValueListenableBuilder<String?>(
                        valueListenable: _passwordError, // 수정: 올바른 리스너 사용
                        builder: (context, error, child) {
                          return TextField(
                            controller: _passwordController,
                            obscureText: true, // 추가: 비밀번호 숨김
                            onChanged: validatePassword,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, // 약간 줄임
                                horizontal: 12,
                              ),
                              errorText: error,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // * 버튼들
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Color(0xFF3182F7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            TypecashHomePage.routeName,
                          );
                        },
                        child: const Text(
                          '로그인',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 기타 버튼을 Row로 배치하여 공간 절약
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                PasswordResetPage.routeName,
                              );
                            },
                            child: const Text(
                              '[ 비밀번호를 잊으셨나요? ]',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF3182F7),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                JoinUserPage.routeName,
                              );
                            },
                            child: const Text(
                              '[ 처음이신가요? 회원가입 ]',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF3182F7),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // 개발용 버튼은 하단에 배치
                      // const SizedBox(height: 16),
                      // OutlinedButton(
                      //   onPressed: () {
                      //     Navigator.pushNamed(context, AdPage.routeName);
                      //   },
                      //   child: const Text('광고 페이지 (개발 중)'),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
