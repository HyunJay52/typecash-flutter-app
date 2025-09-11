import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typecash_flutter_app/apis/typecash_apis.dart';
import 'package:typecash_flutter_app/providers/auth_provider.dart';
import 'package:typecash_flutter_app/screens/home/typecash_home_page.dart';
import 'package:typecash_flutter_app/widgets/animated_wave_text_v1.dart';
// import 'package:typecash_flutter_app/widgets/amimated_wave_text_v2.dart';
import 'screens/user/login_page.dart'; // Replace with the actual path to your login page

class SplashPage extends StatefulWidget {
  static const routeName = '/splash';

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () async {
      if (mounted) {
        // 인증 상태 초기화
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        // context 대신 authProvider 직접 전달
        await authProvider.initialize();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
    // _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate a network call or some processing

    if(!mounted) return; // Check if the widget is still mounted before proceeding
    if (mounted) {
      // 인증 상태 초기화
      // Check login status
       // 인증 상태 초기화
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setContext(context);
      await authProvider.initialize();
      
      if (authProvider.isAuthenticated) {
         // todo User 최신 정보 가져오기 (리워드 밸런스 등)
        Navigator.of(context).pushReplacementNamed(TypecashHomePage.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 150),
            Image.asset(
              'assets/images/logo_v2.png', // Replace with your splash logo path
              height: 100, // Adjust the height as needed
              fit: BoxFit.cover, // Adjust the fit as needed
            ),
            SizedBox(height: 50),
            AnimatedWaveText(
              text: '한 줄로 쌓는 작은 보상',
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3745),
              ),
              waveDelay: Duration(milliseconds: 80),
              waveHeight: 6, // 웨이브 높이 조정 (더 부드러운 효과를 위해 조금 낮춤)
              waveDuration: Duration(milliseconds: 1500), // 파도 한 주기 지속 시간
            ),
          ],
        ),
      ),
    );
  }
}
