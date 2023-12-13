import 'package:json_annotation/json_annotation.dart';
part 'chronicle_add_request.g.dart';

@JsonSerializable()
class ChronicleAddRequestParam {
  final String name;
  final String? valueStr;
  final double? valueNum;

  ChronicleAddRequestParam(this.name, this.valueStr, this.valueNum);

  Map<String, dynamic> toJson() => _$ChronicleAddRequestParamToJson(this);

  @override
  String toString() => 'ChronicleAddRequestParam{name: $name, valueStr: $valueStr, valueNum: $valueNum}';
}

@JsonSerializable(createFactory: false) // "createFactory: false" to skip `.fromJson()` generation
class ChronicleAddRequest {
  final String date;
  final String eventName;
  final List<ChronicleAddRequestParam> params;

  ChronicleAddRequest(this.date, this.eventName, this.params);

  Map<String, dynamic> toJson() => _$ChronicleAddRequestToJson(this);

  @override
  String toString() => 'ChronicleAddRequest{date: $date, eventName: $eventName, params: $params}';
}
