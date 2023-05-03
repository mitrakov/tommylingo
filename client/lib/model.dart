// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:scoped_model/scoped_model.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

typedef TokenPair = Tuple2<String, String>;

class MyModel extends Model {
  final List<TokenPair> _data = [];
  String _langCode = "en-GB";
  int _currentToken = 0;

  Future<TokenPair> get token async {
    if (_currentToken >= _data.length) { // IF data is empty OR _currentToken is overflown
      _data..clear()..addAll(await _loadMore());
      _currentToken = 0;
    }
    return _data.isEmpty ? const TokenPair("", "") : _data[_currentToken];
  }

  void nextToken() {
    _currentToken++;
    notifyListeners();
  }

  String get langCode => _langCode;

  set langCode(String value) {
    _langCode = value;
    _data.clear();
    notifyListeners();
  }

  Future<Iterable<TokenPair>> _loadMore() async {
    final response = await http.get(Uri.parse("http://mitrakoff.com:9090/lingo/translations/$langCode"));
    if (response.statusCode == 200) {
      return XmlDocument.parse(response.body).findAllElements("item").map((e) => TokenPair(e.getAttribute("key")!, e.text));
    } else return Future.error("Error: $response");
  }
}
