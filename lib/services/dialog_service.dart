import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typecash_flutter_app/providers/ad_provider.dart';
import 'package:typecash_flutter_app/providers/mission_provider.dart';
import 'package:typecash_flutter_app/widgets/home/mission_success_dialog_widget.dart';
import 'package:typecash_flutter_app/widgets/home/point_rewarded_dialog_widget.dart';

class DialogService {
  // 미션 성공 다이얼로그 표시
  static void showMissionSuccessDialog(BuildContext context) {
    // 현재 컨텍스트가 유효한지 확인
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => MissionSuccessDialog(
            onWatchAdPressed: () {
              // 현재 다이얼로그 닫기
              Navigator.pop(dialogContext);

              // 메인 컨텍스트가 여전히 유효한지 확인
              if (!context.mounted) return;

              // 광고 처리 메서드 호출
              _handleAdWatching(context);
            },
            onClosePressed: () => Navigator.pop(dialogContext),
          ),
    );
  }

  // 포인트 보상 다이얼로그 표시
  static void showPointRewardedDialog(BuildContext context, int points) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PointRewardedDialog(rewardPoints: points),
    );
  }

  // 에러 스낵바 표시
  static void showErrorSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // 광고 시청 및 보상 처리
  static void _handleAdWatching(BuildContext context) async {
    final adProvider = Provider.of<AdProvider>(context, listen: false);

    // 로딩 표시
    if (!context.mounted) return;
    final loadingDialogController = _showLoadingDialog(context);

    try {
      // 광고가 로드되어 있는지 확인
      if (!adProvider.isAdLoaded) {
        // 광고 로드
        await adProvider.loadRewardedInterstitialAd();
      }

      // 로딩 다이얼로그 닫기
      if (context.mounted) {
        loadingDialogController.dismiss();
      }

      // 광고가 로드되었는지 다시 확인
      if (!adProvider.isAdLoaded) {
        if (context.mounted) {
          showErrorSnackBar(context, '광고를 불러올 수 없습니다. 잠시 후 다시 시도해주세요.');
        }
        return;
      }

      // 광고 시청 완료 콜백 설정
      // async/await 대신 콜백 패턴 사용
      // adProvider.showRewardedInterstitialAdWithCallback(
      //   onAdClosed: (bool wasWatched) async {
      //     // 광고가 성공적으로 시청되었는지 확인
      //     if (wasWatched) {
      //       if (context.mounted) {
      //         // 여기서 리워드 포인트 서버 전송 로직이 들어갈 예정
      //         // await missionProvider.claimMissionReward();

      //         // UI 표시는 서버 응답 이후에 진행
      //         showPointRewardedDialog(context, 3);
      //       }
      //     } else if (context.mounted) {
      //       showErrorSnackBar(context, '광고를 끝까지 시청하지 않아 보상을 받을 수 없습니다.');
      //     }
      //   },
      //   onAdFailedToShow: () {
      //     if (context.mounted) {
      //       showErrorSnackBar(context, '광고 표시 중 오류가 발생했습니다.');
      //     }
      //   },
      // );
    } catch (e) {
      // 오류 처리
      if (context.mounted) {
        loadingDialogController.dismiss();
        showErrorSnackBar(context, '광고 준비 중 오류가 발생했습니다: $e');
      }
    }
  }

  // 로딩 다이얼로그 표시
  static LoadingDialogController _showLoadingDialog(BuildContext context) {
    final controller = LoadingDialogController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        // 컨트롤러에 dismiss 함수 할당
        controller.dismiss = () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }
        };

        return const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('광고를 준비 중입니다...'),
            ],
          ),
        );
      },
    );

    return controller;
  }
}

// 로딩 다이얼로그 컨트롤러
class LoadingDialogController {
  VoidCallback dismiss = () {};
}
