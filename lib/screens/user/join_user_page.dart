import 'package:flutter/material.dart';

class JoinUserPage extends StatefulWidget {
  static const routeName = '/join-user';

  const JoinUserPage({super.key});

  @override
  State<JoinUserPage> createState() => _JoinUserPageState();
}

class _JoinUserPageState extends State<JoinUserPage> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? _email;
    String? _password;
    String? _confirmPassword;
    bool _agreeToTerms = false;
    bool _agreeToPrivacy = false;

    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: 
        // ? gesture detector || Form 차이
        // ? GestureDetector는 사용자가 화면을 터치했을 때 특정 동작을 수행할 수 있도록 하는 위젯입니다.
        // ? Form은 사용자가 입력한 데이터를 검증하고 저장하는 데 사용되는 위젯입니다.
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: '이메일'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력해주세요';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return '유효하지 않은 이메일 주소입니다, 다시 입력해주세요';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: '비밀번호'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요';
                    }
                    if (value.length < 8 ||
                        !RegExp(r'[A-Za-z]').hasMatch(value) ||
                        !RegExp(r'[0-9]').hasMatch(value)) {
                      return '8글자 이상 영문과 숫자를 포함해야 합니다';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: '비밀번호 재입력'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _password) {
                      return '비밀번호가 일치하지 않습니다';
                    }
                    return null;
                  },
                  onSaved: (value) => _confirmPassword = value,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('이용약관에 동의합니다.'),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder:
                              (context) => const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Terms and conditions content goes here.',
                                ),
                              ),
                        );
                      },
                      child: const Text('내용보기'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                    ),
                    const Text('개인정보 수집에 동의'),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder:
                              (context) => const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Privacy policy content goes here.',
                                ),
                              ),
                        );
                      },
                      child: const Text('내용보기'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      if (_agreeToTerms && _agreeToPrivacy) {
                        Navigator.of(
                          context,
                        ).pop(); // Navigate back to login page
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please agree to the terms and privacy policy',
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('가입하기'),
                ),
              ],
            ),
          ),
        )
        
              ),
    );
  }
}
