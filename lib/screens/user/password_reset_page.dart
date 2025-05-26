import 'package:flutter/material.dart';
import 'package:typecash_flutter_app/screens/user/login_page.dart';

class PasswordResetPage extends StatefulWidget {
  static const routeName = '/password-reset';
  
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController validationCodeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isCodeSent = false;
  bool isCodeValidated = false;
  bool isPasswordReset = false;

  void sendValidationCode() {
    setState(() {
      isCodeSent = true;
    });
  }

  void validateCode() {
    setState(() {
      isCodeValidated = true;
    });
  }

  void resetPassword() {
    setState(() {
      isPasswordReset = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 재설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: isPasswordReset
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '비밀번호가 성공적으로 재설정되었습니다! 🎉',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, LoginPage.routeName);
                    },
                    child: Text('로그인 하러 가기'),
                  ),
                ],
              )
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!isCodeSent) ...[
                    Text('가입하신 이메일 주소를 입력해주세요 😄', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: '이메일 주소',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: sendValidationCode,
                      child: Text('인증번호 전송'),
                    ),
                  ] else if (!isCodeValidated) ...[
                    TextField(
                      controller: validationCodeController,
                      decoration: InputDecoration(
                        labelText: '인증 번호',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: validateCode,
                      child: Text('인증 번호'),
                    ),
                  ] else ...[
                    TextField(
                      controller: newPasswordController,
                      decoration: InputDecoration(
                        labelText: '새로운 비밀번호',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: '새로운 비밀번호 재확인',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: resetPassword,
                      child: Text('비밀번호 재설정'),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}