import 'package:json_annotation/json_annotation.dart';
part 'resources.g.dart';

@JsonSerializable()
class Resources {
  final List<String> resources;
  Resources(this.resources);

  factory Resources.fromJson(Map<String, dynamic> json) => _$ResourcesFromJson(json);
  Map<String, dynamic> toJson() => _$ResourcesToJson(this);
}
