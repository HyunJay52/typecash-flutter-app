import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typecash_flutter_app/providers/ad_provider.dart';
import 'package:typecash_flutter_app/providers/mission_provider.dart';
import 'package:typecash_flutter_app/providers/reward_provider.dart';
import 'package:typecash_flutter_app/providers/user_provider.dart';
import 'package:typecash_flutter_app/widgets/home/mission_success_dialog_widget.dart';
import 'package:typecash_flutter_app/widgets/home/point_rewarded_dialog_widget.dart';

class TypingMissionSectionWidget extends StatelessWidget {
  const TypingMissionSectionWidget({super.key});

  // 에러 스낵바 표시
  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // 미션 성공 다이얼로그 표시
  void showMissionSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => MissionSuccessDialog(
            onWatchAdPressed: () async {
              final adProvider = Provider.of<AdProvider>(
                context,
                listen: false,
              );
              debugPrint('광고 준비 상태: ${adProvider.isAdLoaded}');
              if (adProvider.isAdLoaded) {
                final rewardPoints = await adProvider.showRewardedInterstitialAd();
                // 광고가 성공적으로 시청되었을 때, 유저 데이터 업데이트
                final rewardProvider = Provider.of<RewardProvider>(context, listen: false);
                await rewardProvider.updateRewardAmount(rewardPoints);
                debugPrint('포인트 지급 완료: $rewardPoints');
                // 미션 상태 업데이트
                final missionProvider = Provider.of<MissionProvider>(context, listen: false);
                await missionProvider.fetchDailyMissionSummary();
                debugPrint('미션 상태 업데이트 완료');
                Navigator.pop(context);
                // 포인트 지급 완료 다이얼로그 표시
                showDialog(
                  context: context,
                  builder: (context) => PointRewardedDialog(rewardPoints: rewardPoints),
                );
              } else {
                adProvider.loadRewardedInterstitialAd();
                debugPrint('광고가 준비되지 않았습니다. 다시 시도합니다.');
                Navigator.pop(context); // 다이얼로그 닫기
                showErrorSnackBar(context, '광고가 준비되지 않았습니다. 잠시 후 다시 시도해주세요.');
              }
            },
            onClosePressed: () => Navigator.pop(context),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final missionProvider = Provider.of<MissionProvider>(context);
    // final adProvider = Provider.of<AdProvider>(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Image.asset('assets/images/question.png', width: 50),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                child: Text(
                  missionProvider.currentMissionContent,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: missionProvider.missionInputController,
                builder: (context, value, child) {
                  final isValid =
                      value.text.trim() ==
                      missionProvider.currentMissionContent;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: TextField(
                          controller: missionProvider.missionInputController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color:
                                    isValid || value.text.isEmpty
                                        ? Colors.grey
                                        : Colors.red,
                                width: 2,
                              ),
                            ),
                            hintText: '위 문장을 똑같이 적어 주세요',
                            hintStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      if (!isValid && value.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '오답 입니다. 다시 시도해볼까요?',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 188, 55, 45),
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(130, 40),
                  backgroundColor: const Color(0xFF3182F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  var result = await missionProvider.submitMission(context);
                  debugPrint('Mission submission result: $result');
                  // missionProvider.showMissionSuccessDialog(context);
                  if(result) {
                    // 미션 성공 다이얼로그 표시
                    showMissionSuccessDialog(context);
                  } else {
                    // 에러 스낵바 표시
                    showErrorSnackBar(context, missionProvider.errorMessage); 
                  }
                },
                child: Text(
                  '입력 완료',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[200],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }
}
