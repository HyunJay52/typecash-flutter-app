import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typecash_flutter_app/providers/mission_provider.dart';

class TimerProvider with ChangeNotifier {
  // 타이머 상태
  Duration _remainingTime = Duration.zero;
  Timer? _timer;
  bool _isActive = false;
  DateTime? _nextHour;

  // Getters
  Duration get remainingTime => _remainingTime;
  bool get isActive => _isActive;
  String get formattedTime {
    final hours = _remainingTime.inHours.toString().padLeft(2, '0');
    final minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  // 초기화 및 시작
  void startTimer() {
    // 이미 활성화된 타이머가 있다면 중지
    _timer?.cancel();

    // 다음 정각 시간 계산
    _calculateNextHour();

    // 타이머 시작
    _isActive = true;
    _updateRemainingTime();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemainingTime();

      // 시간이 0이 되면 미션 새로고침 필요
      if (_remainingTime.inSeconds <= 0) {
        _calculateNextHour(); // 다음 시간으로 업데이트
        notifyListeners(); // UI 업데이트 알림
      } else {
        notifyListeners(); // 일반 타이머 업데이트
      }
    });
  }

  // 타이머 정지
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _isActive = false;
    notifyListeners();
  }

  // 다음 정각 시간 계산
  void _calculateNextHour() {
    final now = DateTime.now();
    _nextHour = DateTime(now.year, now.month, now.day, now.hour + 1, 0, 0);
    _updateRemainingTime();
  }

  // 남은 시간 업데이트
  void _updateRemainingTime() {
    if (_nextHour == null) return;

    final now = DateTime.now();
    final diff = _nextHour!.difference(now);

    if (diff.isNegative) {
      _remainingTime = Duration.zero;
    } else {
      _remainingTime = diff;
    }
  }

  // 타이머가 0이 되었을 때 미션 새로고침
  void refreshMissionIfNeeded(BuildContext context) {
    if (_remainingTime.inSeconds <= 0) {
      debugPrint('타이머 종료: 새 미션 데이터 가져오기 요청됨');
      final missionProvider = Provider.of<MissionProvider>(
        context,
        listen: false,
      );
      missionProvider.fetchDailyMissionSummary();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
