import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'schema.g.dart';

@JsonSerializable()
class Param {
  final String  name;
  final String? description;
  final String  type; // "N", "S", "B", "N[]", "S[]", "B[]"
  final String? unit;
  final String? defaultValue;

  Param(this.name, this.description, this.type, this.unit, this.defaultValue);

  factory Param.fromJson(Map<String, dynamic> json) => _$ParamFromJson(json);

  String  get nameUtf8         => utf8.decode(name.runes.toList());
  String? get descriptionUtf8  => description  != null ? utf8.decode(description!.runes.toList()) : null;
  String? get unitUtf8         => unit         != null ? utf8.decode(unit!.runes.toList()) : null;
  String? get defaultValueUtf8 => defaultValue != null ? utf8.decode(defaultValue!.runes.toList()) : null;

  @override
  String toString() => 'Param{name: $name, description: $description, type: $type, unit: $unit, defaultValue: $defaultValue}';
}

@JsonSerializable()
class Schema {
  final String eventName;
  final String? eventDescription;
  final List<Param> params;

  Schema(this.eventName, this.eventDescription, this.params);

  factory Schema.fromJson(Map<String, dynamic> json) => _$SchemaFromJson(json);

  String  get eventNameUtf8        => utf8.decode(eventName.runes.toList());
  String? get eventDescriptionUtf8 => eventDescription != null ? utf8.decode(eventDescription!.runes.toList()) : null;

  @override
  String toString() => 'Schema{eventName: $eventName, eventDescription: $eventDescription, params: $params}';
}
