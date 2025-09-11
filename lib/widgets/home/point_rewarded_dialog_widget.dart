import 'package:flutter/material.dart';

class PointRewardedDialog extends StatelessWidget {
  final int rewardPoints;

  const PointRewardedDialog({super.key, required this.rewardPoints});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Image.asset(
            'assets/images/reward.png',
            height: 120,
            fit: BoxFit.contain,
          ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$rewardPoints 포인트 지급 완료 !',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 19, 22, 26),
            ),
          ),
          const SizedBox(height: 15),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(100, 40),
              backgroundColor: const Color(0xFF3182F7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '확인',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFfafafa)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      titlePadding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
    );
  }
}
