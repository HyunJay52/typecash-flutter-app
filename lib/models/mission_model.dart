import 'package:json_annotation/json_annotation.dart';

part 'mission_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MissionStatusItem {
  final int hour;
  final bool available;
  final bool completed;
  final int? missionId; // 이미 nullable로 선언됨

  MissionStatusItem({
    required this.hour,
    required this.available,
    required this.completed,
    this.missionId,
  });

  factory MissionStatusItem.fromJson(Map<String, dynamic> json) {
    return MissionStatusItem(
      hour: json['hour'] ?? 0, // null이면 0 사용
      available: json['available'] ?? false,
      completed: json['completed'] ?? false,
      missionId: json['missionId'], // 이미 nullable이므로 그대로 둠
    );
  }

  Map<String, dynamic> toJson() => _$MissionStatusItemToJson(this);

  @override
  String toString() {
    return 'MissionStatusItem(hour: $hour, available: $available, completed: $completed, missionId: $missionId)';
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CurrentMission {
  final int hour;
  final bool available;
  final String content;
  final int missionId;

  CurrentMission({
    required this.hour,
    required this.available,
    required this.content,
    required this.missionId,
  });

  factory CurrentMission.fromJson(Map<String, dynamic> json) {
    return CurrentMission(
      hour: json['hour'] ?? 0, // null이면 0 사용
      available: json['available'] ?? false,
      content: json['content'] ?? '', // null이면 빈 문자열 사용        
      missionId: json['missionId'] ?? 0, // null이면 0 사용
    );
  }

  Map<String, dynamic> toJson() => _$CurrentMissionToJson(this);

  @override
  String toString() {
    return 'CurrentMission(hour: $hour, available: $available, content: $content, missionId: $missionId)';
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class DailyMissionSummary {
  final int totalMissions;
  final int completedMissions;
  final int pendingMissions;
  final int missedMissions;
  final CurrentMission currentMission;
  final List<MissionStatusItem> missionStatus;

  DailyMissionSummary({
    required this.totalMissions,
    required this.completedMissions,
    required this.pendingMissions,
    required this.missedMissions,
    required this.currentMission,
    required this.missionStatus,
  });

  factory DailyMissionSummary.fromJson(Map<String, dynamic> json) {
    return DailyMissionSummary(
      totalMissions: json['totalMissions'] ?? 0,
      completedMissions: json['completedMissions'] ?? 0,
      pendingMissions: json['pendingMissions'] ?? 0,
      missedMissions: json['missedMissions'] ?? 0,
      currentMission: CurrentMission.fromJson(json['currentMission'] ?? {}), // null이면 빈 맵 사용
      missionStatus: (json['missionStatus'] as List?)
              ?.map((item) => MissionStatusItem.fromJson(item))
              .toList() ??
          [], // null이면 빈 리스트 사용
    );
  }

  Map<String, dynamic> toJson() => _$DailyMissionSummaryToJson(this);

  @override
  String toString() {
    return 'DailyMissionSummary(totalMissions: $totalMissions, completedMissions: $completedMissions, '
        'pendingMissions: $pendingMissions, missedMissions: $missedMissions)';
  }
}
