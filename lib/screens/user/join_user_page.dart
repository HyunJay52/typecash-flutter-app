import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typecash_flutter_app/providers/join_user_provider.dart';
import 'package:typecash_flutter_app/widgets/app_logo_center.dart';

class JoinUserPage extends StatefulWidget {
  static const routeName = '/join-user';

  const JoinUserPage({super.key});

  @override
  State<JoinUserPage> createState() => _JoinUserPageState();
}

class _JoinUserPageState extends State<JoinUserPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final joinUserProvider = context.read<JoinUserProvider>();
      joinUserProvider.resetForm();
    });
  }

  // 모달 표시 함수 (UI 관련 로직은 페이지에 유지)
  void _showTermsModal(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: SingleChildScrollView(child: Text(content)),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('확인'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JoinUserProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('회원가입')),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: provider.formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 16.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 15),
                      AppLogoCenter(),
                      const SizedBox(height: 28),
                      // 이메일 필드
                      const Text(
                        '이메일',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3745),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FocusScope(child: Focus(
                        onFocusChange: (hasFocus) {
                            if (!hasFocus) {
                              // 포커스를 잃으면 유효성 검사 수행
                              provider.onUnfocusEmailTextField();
                            }
                          },
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                              hintText: 'honggildong@naver.com',
                              hintStyle: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                              errorText: provider.emailError,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            controller: provider.emailController,
                            textInputAction: TextInputAction.next,
                          ),

                        ),
                      ),
                      const SizedBox(height: 18),

                      // 비밀번호 필드
                      const Text(
                        '비밀번호',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3745),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FocusScope(child: Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) {
                            // 포커스를 잃으면 유효성 검사 수행
                            provider.onUnfocusPasswordTextField();
                          }
                        },
                        child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                              errorText: provider.passwordError,
                              hintText:
                                  '숫자 1개, 특수문자(@, !, *, -, _) 1개 이상 포함된 8자 이상',
                              hintStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              isDense: true,
                              alignLabelWithHint: true,
                            ),
                            obscureText: true,
                            controller: provider.passwordController,
                            textInputAction: TextInputAction.next,
                          ),
                      )),
                      const SizedBox(height: 13),
                      FocusScope(child: Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) {
                            // 포커스를 잃으면 유효성 검사 수행
                            provider.onUnfocusConfirmPasswordTextField();
                          }
                        },
                        child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                              hintText: '비밀번호를 다시 입력해주세요',
                              hintStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              errorText: provider.confirmPasswordError,
                            ),
                            obscureText: true,
                            controller: provider.confirmPasswordController,
                            textInputAction: TextInputAction.done,
                          )
                      )),
                      const SizedBox(height: 24),

                      // 약관 동의 섹션
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            value: provider.agreeToTerms,
                            onChanged: (_) => provider.toggleAgreeToTerms(),
                          ),
                          const Text('이용약관에 동의합니다.'),
                          TextButton(
                            onPressed: () => _showTermsModal(
                                  context,
                                  '이용약관',
                                  '이용약관 내용이 여기에 표시됩니다. '
                                  '이용약관의 내용이 길 경우 스크롤하여 확인할 수 있습니다.',
                                ),
                            child: const Text('[내용보기]'),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            value: provider.agreeToPrivacy,
                            onChanged: (_) => provider.toggleAgreeToPrivacy()
                          ),
                          const Text('개인정보 수집에 동의'),
                          TextButton(
                            onPressed: () => _showTermsModal(
                                  context,
                                  '개인정보 수집 및 이용',
                                  '개인정보 수집 및 이용 동의 내용이 여기에 표시됩니다.',
                                ),
                            child: const Text('[내용보기]'),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          '﹡ 모든 항목은 필수 동의입니다.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed:
                    provider.isLoading
                      ? null
                      : () async {
                        final result = await provider.handleSubmit();
                        if (!mounted) return;
                        if (result) {
                          ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('회원가입이 완료되었습니다.'),
                            backgroundColor: Colors.blue[300],
                          ),
                          );
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(provider.errorMessage ?? '오류가 발생했습니다.'),
                            backgroundColor: Colors.red[300],
                          ),
                          );
                        }
                        },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child:
                    provider.isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Text(
                          '가입하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ),
        );
      },
    );
  }
}
