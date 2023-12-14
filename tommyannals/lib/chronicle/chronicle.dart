import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'chronicle.g.dart';

@JsonSerializable()
class Chronicle {
  final String date; // 2012-12-12 format
  final String eventName;
  final Map<String, dynamic> params;
  final String? comment;

  Chronicle(this.date, this.eventName, this.params, this.comment);

  Map<String, dynamic> toJson() => _$ChronicleToJson(this);
  factory Chronicle.fromJson(Map<String, dynamic> json) => _$ChronicleFromJson(json);

  String  get eventNameUtf8 => utf8.decode(eventName.runes.toList());
  Map<String, dynamic> get paramsUtf8 => params.map((k, v) => MapEntry(utf8.decode(k.runes.toList()), v is String ? utf8.decode(v.runes.toList()) : v));
  String? get commentUtf8 => comment != null ? utf8.decode(comment!.runes.toList()) : null;

  @override
  String toString() => 'Chronicle{date: $date, eventName: $eventName, params: $params, comment: $comment}';
}
