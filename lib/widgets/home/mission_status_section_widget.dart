import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typecash_flutter_app/models/mission_model.dart';
import 'package:typecash_flutter_app/providers/mission_provider.dart';

class MissionStatusSectionWidget extends StatelessWidget {
  const MissionStatusSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final missionProvider = Provider.of<MissionProvider>(context);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset('assets/images/speaker.png', width: 40),
              const SizedBox(width: 5),
              const Text('오늘 총 ', style: TextStyle(fontSize: 17)),
              Text(
                missionProvider.totalMissions.toString(),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3182F7),
                ),
              ),
              const Text('문제 중 ', style: TextStyle(fontSize: 17)),
              Text(
                (missionProvider.completedMissions + 1).toString(),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3182F7),
                ),
              ),
              const Text('번째 문장입니다', style: TextStyle(fontSize: 17)),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset('assets/images/participation.png', width: 40),
                  const Text('오늘 참여 현황', style: TextStyle(fontSize: 17)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.center,
            child: Wrap(
              spacing: 2,
              runSpacing: 2,
              children: List.generate(missionProvider.totalMissions, (index) {
                if (index >= missionProvider.missionStatusItems.length) {
                  return const SizedBox(width: 18, height: 18);
                }

                final MissionStatusItem status =
                    missionProvider.missionStatusItems[index];

                if (status.completed) {
                  return Image.asset(
                    'assets/images/o.png',
                    width: 18,
                    height: 18,
                  );
                } else if (!status.available && !status.completed) {
                  return Image.asset(
                    'assets/images/x.png',
                    width: 18,
                    height: 18,
                  );
                } else {
                  return Image.asset(
                    'assets/images/e.png',
                    width: 18,
                    height: 18,
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
