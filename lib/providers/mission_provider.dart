import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typecash_flutter_app/apis/typecash_apis.dart';
import 'package:typecash_flutter_app/models/mission_model.dart';
import 'package:typecash_flutter_app/widgets/home/mission_success_dialog_widget.dart';

import 'ad_provider.dart';

class MissionProvider with ChangeNotifier {
  final TypecashApis _api = TypecashApis();
  DailyMissionSummary? _missionSummary;
  bool _isLoading = false;
  String _errorMessage = '';
  // bool _isValid = false;
  final TextEditingController missionInputController = TextEditingController();

  // * Getter
  DailyMissionSummary? get missionSummary => _missionSummary;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  // bool get isValid => _isValid;

  String get currentMissionContent =>
      _missionSummary?.currentMission.content ?? '미션 준비 중';
  int? get currentMissionId => _missionSummary?.currentMission.missionId;
  bool get isMissionAvailable =>
      _missionSummary?.currentMission.available ?? false;
  int get totalMissions => _missionSummary?.totalMissions ?? 0;
  int get completedMissions => _missionSummary?.completedMissions ?? 0;
  int get pendingMissions => _missionSummary?.pendingMissions ?? 0;
  int get missedMissions => _missionSummary?.missedMissions ?? 0;
  List<MissionStatusItem> get missionStatusItems =>
      _missionSummary?.missionStatus ?? [];
  bool get outOfMissions =>
      totalMissions == (completedMissions + pendingMissions + missedMissions) ||
      totalMissions < (completedMissions + pendingMissions + missedMissions);

  MissionProvider() {
    debugPrint('MissionProvider 생성됨');
  }

  set missionSummary(DailyMissionSummary? summary) {
    _missionSummary = null;
    notifyListeners();
  }

  // 데일리 써머리 가져오기
  Future<void> fetchDailyMissionSummary() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _api.getDailyMissionSummary();
      // 원본 응답 로깅 (어떤 필드가 null인지 확인)
      debugPrint('Raw Daily Summary Response: ${response.data}');

      // null 필드 확인
      if (response.data is Map) {
        Map<String, dynamic> data = response.data;
        data.forEach((key, value) {
          if (value == null) {
            debugPrint('Null field detected: $key');
          } else if (key == 'currentMission' && value is Map) {
            value.forEach((k, v) {
              if (v == null) {
                debugPrint('Null field detected in currentMission: $k');
              }
            });
          }
        });
      }

      _missionSummary = DailyMissionSummary.fromJson(response.data);
      debugPrint('Daily Mission Summary fetched successfully: $_missionSummary'); 
      // _missionSummary = null;
      _errorMessage = '';
    } catch (e, stackTrace) {
      // 오류 정보와 스택 트레이스 로깅
      debugPrint('Error fetching daily mission summary: $e');
      debugPrint('Stack trace: $stackTrace');
      _errorMessage = '미션 정보를 가져오는 중 오류가 발생했습니다. ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 미션 제출
  Future<bool> submitMission(BuildContext context) async {
    debugPrint('daily mission summary: $_missionSummary');

    if (_missionSummary == null || !isMissionAvailable) {
      _errorMessage = '제출 가능한 미션이 없습니다.';
      return false;
    }

    final missionId = currentMissionId;
    if (missionId == null) {
      _errorMessage = '미션 ID를 찾을 수 없습니다.';
      return false;
    }

    _isLoading = true;

    try {
      final response = await _api.submitMission(
        missionId: missionId,
        answer: missionInputController.text.trim(),
      );
      // 성공적으로 제출된 경우 처리
      debugPrint('Mission Submitted: ${response.data}');

      // 미션 요약 정보 갱신
      await fetchDailyMissionSummary();
      missionInputController.clear();
      return true;
    } catch (e) {
      _errorMessage = '미션 제출에 실패했습니다: ${e.toString()}';
      debugPrint(_errorMessage);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool validateMissionAnswer(String answer) {
    return answer.trim() == currentMissionContent.trim();
  }

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
            onWatchAdPressed: () {
              // Navigator.pop(context);
              // Navigator.pushNamed(context, AdPage.routeName);

              final adProvider = Provider.of<AdProvider>(
                context,
                listen: false,
              );
              debugPrint('광고 준비 상태: ${adProvider.isAdLoaded}');

              if (adProvider.isAdLoaded) {
                adProvider.showRewardedInterstitialAd();
              } else {
                showErrorSnackBar(context, '광고가 준비되지 않았습니다. 잠시 후 다시 시도해주세요.');
              }
            },
            onClosePressed: () => Navigator.pop(context),
          ),
    );
  }

  @override
  void dispose() {
    debugPrint('MissionProvider 제거됨');
    missionInputController.dispose();
    super.dispose();
  }
}
