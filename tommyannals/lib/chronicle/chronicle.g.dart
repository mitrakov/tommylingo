// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chronicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chronicle _$ChronicleFromJson(Map<String, dynamic> json) => Chronicle(
      json['date'] as String,
      json['eventName'] as String,
      json['params'] as Map<String, dynamic>,
      json['comment'] as String?,
    );

Map<String, dynamic> _$ChronicleToJson(Chronicle instance) => <String, dynamic>{
      'date': instance.date,
      'eventName': instance.eventName,
      'params': instance.params,
      'comment': instance.comment,
    };
