import 'package:flutter/widgets.dart';

class HourTimerWidget extends StatelessWidget {
  const HourTimerWidget({super.key});

  Stream<Duration> _countdownStream() {
    // 다음 정각 시간 계산
    final now = DateTime.now();
    final nextHour = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour + 1, // 다음 시간
      0, // 0분
      0, // 0초
    );

    return Stream.periodic(const Duration(seconds: 1), (_) {
      final currentTime = DateTime.now();
      final remainingTime = nextHour.difference(currentTime);
      return remainingTime.isNegative ? Duration.zero : remainingTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/sand_timer.png',
                width: 25,
                height: 25,
              ),
              const SizedBox(width: 5),
              // ! 미션 수행 전 "이번 미션 남은 시간", 미션 수행 후 "다음 미션 남은 시간"
              const Text('다음 미션까지 남은 시간', style: TextStyle(fontSize: 14)),
            ],
          ),
          StreamBuilder<Duration>(
            stream: _countdownStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final duration = snapshot.data!;
                final hours = duration.inHours.toString().padLeft(2, '0');
                final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
                final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
                return Text(
                  '$hours:$minutes:$seconds',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    // color: Colors.blue,
                  ),
                );
              } else {
                return const Text(
                  '00:00:00',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
