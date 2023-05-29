// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:tommypass/item/passitem.dart';
import 'package:tommypass/item/resources.dart';

class PassModel extends Model {
  final String token = "555";
  final List<String> _resources = [];
  String _currentLogin = "";
  String _currentPassword = "";
  String _currentNote = "";

  Iterable<String> get resources {
    if (_resources.isEmpty) _loadMore();
    return _resources;
  }

  String get currentLogin => _currentLogin;
  String get currentPassword => _currentPassword;
  String get currentNote => _currentNote;

  void loadResource(String resource) async {
    final response = await http.get(Uri.parse("http://mitrakoff.com:9090/pass/$resource"), headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      final item = PassItem.fromJson(json.decode(response.body));
      _currentLogin = item.login;
      _currentPassword = item.password;
      _currentNote = item.note ?? "";
      notifyListeners();
    } else print("Error loading a resource: ${response.body}");
  }

  /// return Error message, or empty string if everything is OK
  Future<String> addNewItem(PassItem item) async {
    final response = await http.post(Uri.parse("http://mitrakoff.com:9090/pass"), headers: {"Authorization": "Bearer $token"}, body: json.encode(item.toJson()));
    if (response.statusCode == 200) {
      await _loadMore(); // refresh
      return "";
    } else return "Error adding a new item: ${response.body}";
  }

  Future _loadMore() async {
    final response = await http.get(Uri.parse("http://mitrakoff.com:9090/pass/resources"), headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      final resources = Resources.fromJson(json.decode(response.body));
      _resources..clear()..addAll(resources.resources);
      notifyListeners();
    } else print("Error loading resources: ${response.body}");
  }
}
