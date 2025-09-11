import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Base Page'),
      ),
      body: const Center(
        child: Text('This is the base page'),
      ),
    );
  }
}