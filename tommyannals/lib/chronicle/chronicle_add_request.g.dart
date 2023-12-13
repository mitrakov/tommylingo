// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chronicle_add_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChronicleAddRequestParam _$ChronicleAddRequestParamFromJson(
        Map<String, dynamic> json) =>
    ChronicleAddRequestParam(
      json['name'] as String,
      json['valueStr'] as String?,
      (json['valueNum'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ChronicleAddRequestParamToJson(
        ChronicleAddRequestParam instance) =>
    <String, dynamic>{
      'name': instance.name,
      'valueStr': instance.valueStr,
      'valueNum': instance.valueNum,
    };

Map<String, dynamic> _$ChronicleAddRequestToJson(
        ChronicleAddRequest instance) =>
    <String, dynamic>{
      'date': instance.date,
      'eventName': instance.eventName,
      'params': instance.params,
    };
