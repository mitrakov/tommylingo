import 'package:json_annotation/json_annotation.dart';
part 'chronicle.g.dart';

@JsonSerializable()
class Chronicle {
  final String date;
  final String eventName;
  final String paramName;
  final double? valueNum;
  final String? valueStr;
  final String? comment;

  Chronicle(this.date, this.eventName, this.paramName, this.valueNum, this.valueStr, this.comment);

  factory Chronicle.fromJson(Map<String, dynamic> json) => _$ChronicleFromJson(json);
}
