import 'package:json_annotation/json_annotation.dart';
part 'passitem.g.dart';

@JsonSerializable()
class PassItem {
  final int id;
  final String resource;
  final String login;
  final String password;
  final String? note;

  PassItem(this.id, this.resource, this.login, this.password, this.note);

  factory PassItem.fromJson(Map<String, dynamic> json) => _$PassItemFromJson(json);
  Map<String, dynamic> toJson() => _$PassItemToJson(this);
}
