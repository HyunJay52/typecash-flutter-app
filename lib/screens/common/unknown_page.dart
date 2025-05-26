import 'package:flutter/material.dart';

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('알 수 없는 페이지')),
      body: const Center(child: Text('unknown', style: TextStyle(fontSize: 18))),
    );
  }
}
