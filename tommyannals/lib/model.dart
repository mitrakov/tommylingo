// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:tommyannals/chronicle/chronicle.dart';
import 'package:tommyannals/chronicle/chronicle_request.dart';
import 'package:tommyannals/chronicle/schema.dart';

class MyModel extends Model {
  final Map<DateTime, List<Chronicle>> _date2data = {};
  final List<Schema> _schema = [];

  Future<List<Chronicle>> getForDate(DateTime date) async {
    final data = _date2data[date];
    if (data == null) {
      final newData = await _loadForDate(date);
      _date2data.putIfAbsent(date, () => newData);
      return newData;
    }
    return data;
  }

  Future<List<Schema>> get schema async {
    if (_schema.isEmpty) {
      final schema = await _loadSchema();
      _schema..clear()..addAll(schema);
    }
    return _schema;
  }

  Future<String> addForDate(DateTime date, String eventName, String paramName, String valueStr) {
    return _addForDate(date, ChronicleRequest(_extractDate(date), eventName, paramName, valueStr));
  }

  Future<String> _addForDate(DateTime key, ChronicleRequest request) async {
    final body = json.encode(request.toJson());
    print("POST http://mitrakoff.com:9090/annals: $body");
    final response = await http.post(Uri.parse("http://mitrakoff.com:9090/annals"), headers: {"Authorization": "bearer 555"}, body: body);
    print("> ${response.body}");
    if (response.statusCode == 200) {
      _date2data.remove(key);
      notifyListeners();
      return response.body;
    } else return Future.error("Error: ${response.statusCode}; ${response.body}");
  }

  Future<List<Chronicle>> _loadForDate(DateTime date) async {
    final formatted = _extractDate(date);
    print("GET http://mitrakoff.com:9090/annals/$formatted");
    final response = await http.get(Uri.parse("http://mitrakoff.com:9090/annals/$formatted"), headers: {"Authorization": "bearer 555"});
    print("> ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> chronicleList = json.decode(response.body);
      return chronicleList.map((js) => Chronicle.fromJson(js)).toList();
    } else return Future.error("Error: ${response.statusCode}; ${response.body}");
  }

  Future<List<Schema>> _loadSchema() async {
    print("GET http://mitrakoff.com:9090/annals/schema");
    final response = await http.get(Uri.parse("http://mitrakoff.com:9090/annals/schema"), headers: {"Authorization": "bearer 555"});
    print("> ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> schemaList = json.decode(response.body);
      return schemaList.map((js) => Schema.fromJson(js)).toList();
    } else return Future.error("Error: ${response.statusCode}; ${response.body}");
  }

  String _extractDate(DateTime date) => "$date".split(" ").first; // "2023-12-12 00:00:00.000Z" => "2023-12-12"
}
