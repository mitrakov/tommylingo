import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:tommypass/item/passitem.dart';
import 'package:tommypass/item/resources.dart';

class PassModel extends Model {
  //final Map<String, PassItem> _data = {};
  final List<String> _data = [];

  Future<Iterable<String>> get resources async {
    if (_data.isEmpty)
      await _loadMore();
    //return _data.keys;
    return _data;
  }

  Future _loadMore() async {
    final response = await http.get(Uri.parse("http://mitrakoff.com:9090/pass/resources"), headers: {"Authorization": "Bearer 555"});
    if (response.statusCode == 200) {
      final resources = Resources.fromJson(json.decode(response.body));
      _data..clear()..addAll(resources.resources);
      print(_data);
    }
  }
}
