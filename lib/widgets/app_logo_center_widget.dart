import 'package:flutter/material.dart';

class AppLogoCenterWidget extends StatelessWidget {
  final double imageHeight;
  final double widgetMargin;
  final double fontSize;

  const AppLogoCenterWidget({super.key, this.imageHeight = 60, this.widgetMargin = 12, this.fontSize = 17});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo_v2.png',
            height: imageHeight,
            fit: BoxFit.contain,
          ),
          SizedBox(height: widgetMargin),
          Text(
            '한 줄로 쌓는 작은 보상',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3745),
            ),
          ),
        ],
      ),
    );
  }
}
