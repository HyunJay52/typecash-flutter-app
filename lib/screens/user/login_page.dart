import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
        appBar: AppBar(title: const Text('로그인')),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            spacing: 10,
            children: [
              const Text('TypeCash', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
              const Text(
                '한 줄로 쌓는 작은 보상',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '이메일',
                  hintText: '이메일 주소를 입력해주세요 (예: honggildong@naver.com)',
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '비밀번호',
                  hintText: '비밀번호를 입력해주세요',
                ),
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
                  // Handle login action
                  // Navigator.pushNamed(context, '/password-reset');
                  Navigator.pushNamed(context, PasswordResetPage.routeName);
                },
                child: const Text('비밀번호 찾기'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle login action
                  Navigator.pushNamed(context, JoinUserPage.routeName);
                },
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
}
