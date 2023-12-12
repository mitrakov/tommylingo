import 'package:json_annotation/json_annotation.dart';
part 'chronicle_request.g.dart';

@JsonSerializable()
class ChronicleRequest {
  final String date;
  final String eventName;
  final String paramName;
  final String valueStr;

  ChronicleRequest(this.date, this.eventName, this.paramName, this.valueStr);

  Map<String, dynamic> toJson() => _$ChronicleRequestToJson(this);
}
