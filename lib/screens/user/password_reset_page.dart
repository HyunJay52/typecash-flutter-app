import 'package:flutter/material.dart';
import 'package:typecash_flutter_app/screens/user/login_page.dart';
import 'package:typecash_flutter_app/widgets/app_logo_center_widget.dart';

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
  bool isEmailValid = false;
  
  // 인증번호 전송 기능
  void sendValidationCode() {
    // 이메일 유효성 검사
    if (isValidEmail(emailController.text)) {
      setState(() {
        isCodeSent = true;
        isEmailValid = true;
      });
      
      // 여기에 실제 인증번호 발송 API 호출 코드 추가
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('인증번호가 발송되었습니다. 이메일을 확인해주세요.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() {
        isEmailValid = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('유효한 이메일 주소를 입력해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  // 인증번호 확인 기능
  void validateCode() {
    // 인증번호 유효성 검사 (여기서는 간단히 비어있지 않은지만 확인)
    if (validationCodeController.text.isNotEmpty) {
      setState(() {
        isCodeValidated = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('인증이 완료되었습니다. 새 비밀번호를 설정해주세요.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('인증번호를 입력해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  // 비밀번호 재설정 기능
  void resetPassword() {
    // 비밀번호 일치 여부 확인
    if (newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('비밀번호를 입력해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('비밀번호가 일치하지 않습니다.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // 비밀번호 재설정 성공 처리
    setState(() {
      isPasswordReset = true;
    });
  }
  
  // 이메일 유효성 검사 함수
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isPasswordReset ? null : Text('비밀번호 재설정'),
        automaticallyImplyLeading: !isPasswordReset,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: isPasswordReset
                ? _buildPasswordResetSuccessView()
                : _buildPasswordResetFormView(),
          ),
        ),
      ),
    );
  }

  // 비밀번호 재설정 성공 화면
  Widget _buildPasswordResetSuccessView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppLogoCenterWidget(),
          SizedBox(height: 50),
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.green,
          ),
          SizedBox(height: 20),
          Text(
            '비밀번호가 성공적으로\n변경되었습니다',
            style: TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 50),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(
                double.infinity,
                50,
              ),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                LoginPage.routeName,
              );
            },
            child: Text(
              '로그인 하러가기',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold, 
                color: Colors.white
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 비밀번호 재설정 폼 화면
  Widget _buildPasswordResetFormView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Center(child: AppLogoCenterWidget()),
        const SizedBox(height: 50),
        
        // 이메일 입력 필드와 인증번호 발송 버튼
        if (!isCodeValidated) ... [
          Text('가입하신 이메일 주소를 입력해주세요', style: TextStyle(fontSize: 17)),
          const SizedBox(height: 8),
          TextField(
            controller: emailController,
            enabled: !isCodeValidated, // 코드 검증 후에는 비활성화
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
              hintText: 'example@email.com',
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              errorText: !isEmailValid && emailController.text.isNotEmpty 
                  ? '유효한 이메일 형식을 입력해주세요' 
                  : null,
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              setState(() {
                isEmailValid = isValidEmail(value);
              });
            },
          ),
          const SizedBox(height: 15),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: sendValidationCode,
                  child: Text(
                    isCodeSent ? '인증번호 재발송' : '인증번호 발송',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          
          // 인증번호 입력 필드
          Text('발송된 인증번호를 입력해주세요', 
            style: TextStyle(
              fontSize: 17,
              color: isCodeSent ? Colors.black : Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: validationCodeController,
            enabled: isCodeSent, // 코드 발송 후에만 활성화
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
              hintText: '인증번호 6자리',
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              prefixIcon: Icon(Icons.vpn_key),
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 15),
          
          // 인증번호 확인 버튼
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isCodeSent ? Theme.of(context).primaryColor : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: isCodeSent ? validateCode : null,
            child: Text(
              '인증번호 확인',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
        
        // 2단계: 비밀번호 변경 섹션
        if (isCodeValidated) ... [
          Text('새로운 비밀번호를 입력해주세요', style: TextStyle(fontSize: 17)),
          const SizedBox(height: 8),
          TextField(
            controller: newPasswordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12, // 약간 줄임
                horizontal: 12,
              ),
              hintText: '숫자 1개, 특수문자(@, !, *, -, _) 1개 이상 포함된 8자 이상',
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            obscureText: true,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 15),
          Text('비밀번호 확인 입력창', style: TextStyle(fontSize: 17)),
          const SizedBox(height: 8),
          TextField(
            controller: confirmPasswordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12, // 약간 줄임
                horizontal: 12,
              ),
              errorText: '비밀번호가 일치하지 않습니다'
            ),
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: resetPassword,
            child: Text(
              '비밀번호 변경하기',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
        
        const SizedBox(height: 30),
      ],
    );
  }
}