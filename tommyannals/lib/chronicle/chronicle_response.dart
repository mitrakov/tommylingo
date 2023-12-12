import 'package:json_annotation/json_annotation.dart';
part 'chronicle_response.g.dart';

@JsonSerializable()
class ChronicleResponse {
  final String date;
  final String eventName;
  final String paramName;
  final double? valueNum;
  final String? valueStr;
  final String? comment;

  ChronicleResponse(this.date, this.eventName, this.paramName, this.valueNum, this.valueStr, this.comment);

  factory ChronicleResponse.fromJson(Map<String, dynamic> json) => _$ChronicleResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ChronicleResponseToJson(this);
}
