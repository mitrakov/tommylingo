// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chronicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chronicle _$ChronicleFromJson(Map<String, dynamic> json) => Chronicle(
      json['date'] as String,
      json['eventName'] as String,
      json['paramName'] as String,
      (json['valueNum'] as num?)?.toDouble(),
      json['valueStr'] as String?,
      json['comment'] as String?,
    );

Map<String, dynamic> _$ChronicleToJson(Chronicle instance) => <String, dynamic>{
      'date': instance.date,
      'eventName': instance.eventName,
      'paramName': instance.paramName,
      'valueNum': instance.valueNum,
      'valueStr': instance.valueStr,
      'comment': instance.comment,
    };
