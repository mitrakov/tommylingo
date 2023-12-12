// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Param _$ParamFromJson(Map<String, dynamic> json) => Param(
      json['name'] as String,
      json['description'] as String?,
      json['type'] as String,
      json['defaultValue'] as String?,
    );

Map<String, dynamic> _$ParamToJson(Param instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'type': instance.type,
      'defaultValue': instance.defaultValue,
    };

Schema _$SchemaFromJson(Map<String, dynamic> json) => Schema(
      json['eventName'] as String,
      json['eventDescription'] as String?,
      (json['params'] as List<dynamic>)
          .map((e) => Param.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SchemaToJson(Schema instance) => <String, dynamic>{
      'eventName': instance.eventName,
      'eventDescription': instance.eventDescription,
      'params': instance.params,
    };
