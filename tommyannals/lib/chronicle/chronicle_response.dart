import 'package:json_annotation/json_annotation.dart';
part 'chronicle_response.g.dart';

@JsonSerializable()
class ChronicleEventParam {
  final String paramName;
  final double? valueNum;
  final String? valueStr;
  final String? comment;

  ChronicleEventParam(this.paramName, this.valueNum, this.valueStr, this.comment);

  factory ChronicleEventParam.fromJson(Map<String, dynamic> json) => _$ChronicleEventParamFromJson(json);

  @override
  String toString() => 'ChronicleEventParam{paramName: $paramName, valueNum: $valueNum, valueStr: $valueStr, comment: $comment}';
}

@JsonSerializable()
class ChronicleEvent {
  final String eventName;
  final List<ChronicleEventParam> params;

  ChronicleEvent(this.eventName, this.params);

  factory ChronicleEvent.fromJson(Map<String, dynamic> json) => _$ChronicleEventFromJson(json);

  @override
  String toString() => 'ChronicleEvent{eventName: $eventName, params: $params}';
}

@JsonSerializable()
class ChronicleResponse {
  final String date;
  final List<ChronicleEvent> events;

  ChronicleResponse(this.date, this.events);

  factory ChronicleResponse.fromJson(Map<String, dynamic> json) => _$ChronicleResponseFromJson(json);

  @override
  String toString() => 'ChronicleResponse{date: $date, events: $events}';
}
