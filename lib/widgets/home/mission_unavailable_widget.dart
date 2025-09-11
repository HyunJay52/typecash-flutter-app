import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typecash_flutter_app/providers/mission_provider.dart';
import 'package:typecash_flutter_app/widgets/home/big_hour_timer_widget.dart';

class MissionUnavailableWidget extends StatelessWidget {
  final bool alreadyCompleted;
  // final bool notAvailableTime;

  const MissionUnavailableWidget({
    super.key,
    required this.alreadyCompleted,
    // required this.notAvailableTime,
  });

  @override
  Widget build(BuildContext context) {
    final missionProvider = Provider.of<MissionProvider>(context);

    return Container(
      width: double.infinity,
      height: 300,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            missionProvider.missionSummary != null &&
                   !missionProvider.missionSummary!.currentMission.available
              ? BigHourTimerWidget()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.block,
                      size: 50,
                      color: Colors.green, // : Colors.red,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '미션 수행 가능 시간이 아닙니다\n내일 다시 시도해주세요',
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              ],
        ),
      );
  }
}