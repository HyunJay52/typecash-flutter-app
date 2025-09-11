// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MissionStatusItem _$MissionStatusItemFromJson(Map<String, dynamic> json) =>
    MissionStatusItem(
      hour: (json['hour'] as num).toInt(),
      available: json['available'] as bool,
      completed: json['completed'] as bool,
      missionId: (json['mission_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MissionStatusItemToJson(MissionStatusItem instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'available': instance.available,
      'completed': instance.completed,
      'mission_id': instance.missionId,
    };

CurrentMission _$CurrentMissionFromJson(Map<String, dynamic> json) =>
    CurrentMission(
      hour: (json['hour'] as num).toInt(),
      available: json['available'] as bool,
      content: json['content'] as String,
      missionId: (json['mission_id'] as num).toInt(),
    );

Map<String, dynamic> _$CurrentMissionToJson(CurrentMission instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'available': instance.available,
      'content': instance.content,
      'mission_id': instance.missionId,
    };

DailyMissionSummary _$DailyMissionSummaryFromJson(Map<String, dynamic> json) =>
    DailyMissionSummary(
      totalMissions: (json['total_missions'] as num).toInt(),
      completedMissions: (json['completed_missions'] as num).toInt(),
      pendingMissions: (json['pending_missions'] as num).toInt(),
      missedMissions: (json['missed_missions'] as num).toInt(),
      currentMission: CurrentMission.fromJson(
        json['current_mission'] as Map<String, dynamic>,
      ),
      missionStatus:
          (json['mission_status'] as List<dynamic>)
              .map((e) => MissionStatusItem.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DailyMissionSummaryToJson(
  DailyMissionSummary instance,
) => <String, dynamic>{
  'total_missions': instance.totalMissions,
  'completed_missions': instance.completedMissions,
  'pending_missions': instance.pendingMissions,
  'missed_missions': instance.missedMissions,
  'current_mission': instance.currentMission.toJson(),
  'mission_status': instance.missionStatus.map((e) => e.toJson()).toList(),
};
