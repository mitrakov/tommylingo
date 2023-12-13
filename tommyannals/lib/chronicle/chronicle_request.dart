import 'package:json_annotation/json_annotation.dart';
part 'chronicle_request.g.dart';

@JsonSerializable()
class ChronicleRequest {
  final String date;
  final String eventName;
  final String paramName;
  final String? valueStr;
  final double? valueNum;

  ChronicleRequest(this.date, this.eventName, this.paramName, this.valueStr, this.valueNum);

  Map<String, dynamic> toJson() => _$ChronicleRequestToJson(this);

  @override
  String toString() => 'ChronicleRequest{date: $date, eventName: $eventName, paramName: $paramName, valueStr: $valueStr, valueNum: $valueNum}';
}
