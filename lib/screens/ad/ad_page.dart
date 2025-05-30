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
      appBar: AppBar(title: const Text('광고')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('여기에 애드몹 광고 페이지 📺'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('리워드 적립 🪙'),
                      content: const Text('3포인트의 리워드가 적립되었습니다'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.of(context).pop(); // Navigate back
                          },
                          child: const Text('확인'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('리워드 받기'),
            ),
          ],
        ),
      ),
    );
  }
}
