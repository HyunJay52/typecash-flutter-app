import 'package:flutter/material.dart';

class MissionSuccessDialog extends StatelessWidget {
  final VoidCallback onWatchAdPressed;
  final VoidCallback onClosePressed;

  const MissionSuccessDialog({
    super.key,
    required this.onWatchAdPressed,
    required this.onClosePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Column(
        children: [
          Image.asset(
            'assets/images/congrat.png',
            height: 65,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          const Text(
            '정답입니다!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3745),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          const Text(
            '광고를 시청하시면\n미션 성공 포인트가 적립됩니다.\n광고를 시청하시겠어요?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFEEBA)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFCC8925),
                  size: 18,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    '광고를 끝까지 시청하지 않으면 포인트가 지급되지 않습니다.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFCC8925),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 35,
            child: ElevatedButton(
              onPressed: onWatchAdPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3182F7),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '광고 시청하기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[200],
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: onClosePressed,
            child: const Text(
              '닫기',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3182F7),
              ),
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      titlePadding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
    );
  }
}
