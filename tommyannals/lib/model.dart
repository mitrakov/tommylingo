// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class MyModel extends Model {
  final Map<DateTime, List<String>> _date2data = {};

  Future<List<String>> getForDate(DateTime date) async {
    final data = _date2data[date];
    if (data == null) {
      final newData = await _loadForDate(date);
      _date2data.putIfAbsent(date, () => newData);
      return newData;
    }
    return data;
  }

  Future<List<String>> _loadForDate(DateTime date) async {
    final formatted = "$date".split(" ").first; // "2023-12-12 00:00:00.000Z" => "2023-12-12"
    final response = await http.get(Uri.parse("http://mitrakoff.com:9090/annals/$formatted"), headers: {"Authorization": "bearer 555"});
    if (response.statusCode == 200) {
      return [response.body];
    } else return Future.error("Error: ${response.statusCode}; ${response.body}");
  }
}
