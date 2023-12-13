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

  @override
  String toString() {
    return 'Param{name: $name, description: $description, type: $type, defaultValue: $defaultValue}';
  }
}

@JsonSerializable()
class Schema {
  final String eventName;
  final String? eventDescription;
  final List<Param> params;

  Schema(this.eventName, this.eventDescription, this.params);

  factory Schema.fromJson(Map<String, dynamic> json) => _$SchemaFromJson(json);

  @override
  String toString() {
    return 'Schema{eventName: $eventName, eventDescription: $eventDescription, params: $params}';
  }
}
