import 'package:flutter/material.dart';

class AppPushWidget extends StatefulWidget {
  const AppPushWidget({super.key});

  @override
  State<AppPushWidget> createState() => _AppPushWidgetState();
}

class _AppPushWidgetState extends State<AppPushWidget> {
  bool isNotificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/notification.png',
                    width: 25,
                    height: 25,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    '받아쓰기 알림을 받으시겠어요?',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Transform.scale(
                scale: 0.7, // Adjust the scale to match the text size
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Switch(
                      value: isNotificationEnabled,
                      activeColor: const Color(0xFF3182F7),
                      inactiveTrackColor: Colors.grey[300],
                      inactiveThumbColor: Colors.grey[600],
                      onChanged: (value) {
                        setState(() {
                          isNotificationEnabled = value;
                        });
                        debugPrint('Notification enabled: $value');
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              '매 시 정각에 새로운 받아쓰기 문장이 열릴 때 알려드릴게요,\n포인트 적립 순간을 놓치지 마세요.',
              style: TextStyle(
                fontSize: 13,
                color: Color.fromARGB(255, 134, 134, 134),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
