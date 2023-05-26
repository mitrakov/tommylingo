// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passitem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PassItem _$PassItemFromJson(Map<String, dynamic> json) => PassItem(
      json['id'] as int,
      json['resource'] as String,
      json['login'] as String,
      json['password'] as String,
      json['note'] as String?,
    );

Map<String, dynamic> _$PassItemToJson(PassItem instance) => <String, dynamic>{
      'id': instance.id,
      'resource': instance.resource,
      'login': instance.login,
      'password': instance.password,
      'note': instance.note,
    };
