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
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
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
          Navigator.pushReplacementNamed(context, TypecashHomePage.routeName);
              });
              return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
              );
            }
            // 로그인 필요: 기존 로그인 화면 노출
            return Scaffold(
              appBar: AppBar(title: const Text('로그인')),
              body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const Text('TypeCash', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
              const Text(
                '한 줄로 쌓는 작은 보상',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<String?>(
                valueListenable: _emailError,
                builder: (context, error, child) {
            return TextField(
              controller: _emailController,
              onChanged: validateEmail,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '이메일',
                hintText: '이메일 주소를 입력해주세요 (예: honggildong@naver.com)',
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                errorText: error,
              ),
            );
                },
              ),
              const SizedBox(height: 5),
              ValueListenableBuilder<String?>(
                valueListenable: _passwordError,
                builder: (context, error, child) {
            return TextField(
              controller: _passwordController,
              obscureText: true,
              onChanged: validatePassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '비밀번호',
                hintText: '숫자 1개, 특수문자(@, !, *, -, _) 1개 이상 포함된 8자 이상이어야 합니다.',
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                errorText: error,
              ),
            );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
            // Handle login action
            Navigator.pushNamed(context, TypecashHomePage.routeName);
                },
                child: const Text('로그인'),
              ),
              ElevatedButton(
                onPressed: () {
            Navigator.pushNamed(context, PasswordResetPage.routeName);
                },
                child: const Text('비밀번호 찾기'),
              ),
              ElevatedButton(
                onPressed: () {
            Navigator.pushNamed(context, JoinUserPage.routeName);
                },
                child: const Text('회원가입'),
              ),
              ElevatedButton(
                onPressed: () {
            Navigator.pushNamed(context, AdPage.routeName);
                },
                child: const Text('광고 페이지 (개발 중)'),
              ),
            ],
          ),
              ),
            );
          },
        ),
    )
    );
  }
}
