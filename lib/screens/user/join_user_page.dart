import 'package:flutter/material.dart';

class JoinUserPage extends StatefulWidget {
  static const routeName = '/join-user';

  const JoinUserPage({super.key});

  @override
  State<JoinUserPage> createState() => _JoinUserPageState();
}

class _JoinUserPageState extends State<JoinUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  String? email;
  String? password;
  String? _confirmPassword;
  bool _agreeToTerms = false;
  bool _agreeToPrivacy = false;

  @override
  void dispose() {
    _passwordController.dispose(); 
    super.dispose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return '유효한 이메일 주소를 입력해주세요';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    final passwordRegex = RegExp(r'^(?=.*[0-9])(?=.*[@!*_-]).{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return '숫자 1개, 특수문자(@, !, *, -, _) 1개 이상 포함된 8자 이상이어야 합니다';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 재입력해주세요';
    }
    if (value != _passwordController.text) {
      return '비밀번호가 일치하지 않습니다';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
                  decoration: InputDecoration(labelText: '이메일', errorText: _emailError, 
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {
                      _emailError = validateEmail(value);
                      email = value;
                    });
                  },
                  validator: validateEmail,
                  onSaved: (value) => email = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: '비밀번호', errorText: _passwordError,
                  hintText: '숫자 1개, 특수문자(@, !, *, -, _) 1개 이상 포함된 8자 이상이어야 합니다.',
                  hintStyle: const TextStyle(
                      fontSize: 12, // 원하는 크기로 조절
                      color: Colors.grey, // 원하는 색상 지정
                    ),
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      _passwordError = validatePassword(value);
                      password = value;

                      if (_confirmPassword != null &&
                          _confirmPassword!.isNotEmpty) {
                        _confirmPasswordError = validateConfirmPassword(
                          _confirmPassword,
                        );
                      }
                    });
                  },
                  validator: validatePassword,
                  onSaved: (value) => password = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: '비밀번호 재입력', errorText: _confirmPasswordError, 
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      _confirmPasswordError = validateConfirmPassword(value);
                      _confirmPassword = value;
                    });
                  },
                  validator: validateConfirmPassword,
                  onSaved: (value) => _confirmPassword = value,
                ),
                const SizedBox(height: 16),
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
                  const Text('이용약관에 동의합니다.'),
                  TextButton(
                    onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: const Text(
                        '이용약관 내용이 여기에 표시됩니다. '
                        '이용약관의 내용이 길 경우 스크롤하여 확인할 수 있습니다.',
                        ),
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
                    value: _agreeToPrivacy,
                    onChanged: (value) {
                    setState(() {
                      _agreeToPrivacy = value ?? false;
                    });
                    },
                  ),
                  const Text('개인정보 수집에 동의'),
                  TextButton(
                    onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: const Text(
                        '개인정보 수집 및 이용 동의 내용이 여기에 표시됩니다.',
                        ),
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
                              '이용약관과 개인정보 수집에 동의해주세요',
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
