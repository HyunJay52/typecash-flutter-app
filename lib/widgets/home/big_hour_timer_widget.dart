import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:typecash_flutter_app/providers/mission_provider.dart';

class BigHourTimerWidget extends StatefulWidget {
  const BigHourTimerWidget({super.key});

  @override
  State<BigHourTimerWidget> createState() => _BigHourTimerWidgetState();
}

class _BigHourTimerWidgetState extends State<BigHourTimerWidget> {
  late Stream<Duration> _timerStream;

  @override
  void initState() {
    super.initState();
    _timerStream = _createCountdownStream();
  }

  Stream<Duration> _createCountdownStream() {
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
    final missionProvider = Provider.of<MissionProvider>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/sand_timer.png',
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 10), // width → height로 수정
          // ! 미션 수행 전 "이번 미션 남은 시간", 미션 수행 후 "다음 미션 남은 시간"
          const Text('다음 미션까지 남은 시간', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10), // width → height로 수정
          StreamBuilder<Duration>(
            stream: _timerStream,
            builder: (context, snapshot) {
                if (snapshot.hasData) {
                final duration = snapshot.data!;
                if (duration == Duration.zero) {
                  // 카운트다운이 끝났으면 스트림을 다시 생성하여 재시작
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _timerStream = _createCountdownStream();
                  });
                  });
                }
                final hours = duration.inHours.toString().padLeft(2, '0');
                final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
                final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
                return Text(
                  '$hours:$minutes:$seconds',
                  style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
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
