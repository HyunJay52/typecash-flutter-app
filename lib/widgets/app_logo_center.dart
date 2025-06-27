import 'package:flutter/material.dart';

class AppLogoCenter extends StatelessWidget {
  const AppLogoCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo_v2.png',
            height: 60,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
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
    );
  }
}