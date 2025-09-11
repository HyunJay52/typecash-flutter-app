import 'package:flutter/material.dart';

class AppLogoWideWidget extends StatelessWidget {
  final double imageHeight;

  const AppLogoWideWidget({
    super.key,
    this.imageHeight = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/logo_v1.png',
        height: imageHeight,
        fit: BoxFit.contain,
      ),
    );
  }
}