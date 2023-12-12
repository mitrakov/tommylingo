// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chronicle_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChronicleRequest _$ChronicleRequestFromJson(Map<String, dynamic> json) =>
    ChronicleRequest(
      json['date'] as String,
      json['eventName'] as String,
      json['paramName'] as String,
      json['valueStr'] as String,
    );

Map<String, dynamic> _$ChronicleRequestToJson(ChronicleRequest instance) =>
    <String, dynamic>{
      'date': instance.date,
      'eventName': instance.eventName,
      'paramName': instance.paramName,
      'valueStr': instance.valueStr,
    };
