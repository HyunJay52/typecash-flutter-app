import 'package:flutter/material.dart';

class AdPage extends StatefulWidget {
static const routeName = '/ad';
  const AdPage({super.key});

  @override
  State<AdPage> createState() => _AdPagePageState();
}

class _AdPagePageState extends State<AdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('광고'),
      ),
      body: const Center(
        child: Text('여기에 애드몹 광고 페이지 📺'),
      ),
    );
  }
}