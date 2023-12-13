// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chronicle_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChronicleEventParam _$ChronicleEventParamFromJson(Map<String, dynamic> json) =>
    ChronicleEventParam(
      json['paramName'] as String,
      (json['valueNum'] as num?)?.toDouble(),
      json['valueStr'] as String?,
      json['comment'] as String?,
    );

Map<String, dynamic> _$ChronicleEventParamToJson(
        ChronicleEventParam instance) =>
    <String, dynamic>{
      'paramName': instance.paramName,
      'valueNum': instance.valueNum,
      'valueStr': instance.valueStr,
      'comment': instance.comment,
    };

ChronicleEvent _$ChronicleEventFromJson(Map<String, dynamic> json) =>
    ChronicleEvent(
      json['eventName'] as String,
      (json['params'] as List<dynamic>)
          .map((e) => ChronicleEventParam.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChronicleEventToJson(ChronicleEvent instance) =>
    <String, dynamic>{
      'eventName': instance.eventName,
      'params': instance.params,
    };

ChronicleResponse _$ChronicleResponseFromJson(Map<String, dynamic> json) =>
    ChronicleResponse(
      json['date'] as String,
      (json['events'] as List<dynamic>)
          .map((e) => ChronicleEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChronicleResponseToJson(ChronicleResponse instance) =>
    <String, dynamic>{
      'date': instance.date,
      'events': instance.events,
    };
