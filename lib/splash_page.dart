import 'package:flutter/material.dart';
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
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      body: Center(
        child: 
        Column(
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