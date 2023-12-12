import 'package:json_annotation/json_annotation.dart';
part 'schema.g.dart';

@JsonSerializable()
class Param {
  final String  name;
  final String? description;
  final String  type;
  final String? defaultValue;

  Param(this.name, this.description, this.type, this.defaultValue);

  factory Param.fromJson(Map<String, dynamic> json) => _$ParamFromJson(json);
}

@JsonSerializable()
class Schema {
  final String eventName;
  final String? eventDescription;
  final List<Param> params;

  Schema(this.eventName, this.eventDescription, this.params);

  factory Schema.fromJson(Map<String, dynamic> json) => _$SchemaFromJson(json);
}
