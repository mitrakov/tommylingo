// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:scoped_model/scoped_model.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

typedef TokenPair = Tuple2<String, String>;

class MyModel extends Model {
  final List<TokenPair> _data = [];
  final List<String> _keys = [];
  String _langCode = "en-GB";
  int _currentToken = 0;

  Future<TokenPair> get token async {
    if (_currentToken >= _data.length) { // IF data is empty OR _currentToken is overflown
      _data..clear()..addAll(await _loadMore());
      _keys..clear()..addAll(await _loadKeys());
      _currentToken = 0;
    }
    return _data.isEmpty ? const TokenPair("", "") : _data[_currentToken];
  }

  void nextToken() {
    _currentToken++;
    notifyListeners();
  }

  String get langCode => _langCode;
  List<String> get keys => _keys;

  set langCode(String value) {
    _langCode = value;
    _data.clear();
    _keys.clear();
    notifyListeners();
  }

  Future<Iterable<TokenPair>> _loadMore() async {
    final response = await http.get(Uri.parse("http://mitrakoff.com:9090/lingo/translations/$langCode"));
    if (response.statusCode == 200)
      return XmlDocument.parse(response.body).findAllElements("item").map((e) => TokenPair(e.getAttribute("key")!, e.text));
    else return Future.error("Error: ${response.statusCode}; ${response.body}");
  }

  Future<Iterable<String>> _loadKeys() async {
    final response = await http.get(Uri.parse("http://mitrakoff.com:9090/lingo/keys/$langCode"));
    if (response.statusCode == 200)
      return XmlDocument.parse(response.body).findAllElements("key").map((e) => e.text);
    else return Future.error("Error: ${response.statusCode}; ${response.body}");
  }

  /// returns empty string if OK, or error message in case of failure
  Future<String> upsertTranslation(String key, String translation) async {
    final xml = XmlDocument([XmlElement(XmlName("a"), [], [
      XmlElement(XmlName("langCode"), [], [XmlText(_langCode)]),
      XmlElement(XmlName("key"), [], [XmlText(key)]),
      XmlElement(XmlName("translation"), [], [XmlText(translation)]),
    ])]);

    final response = await http.post(Uri.parse("http://mitrakoff.com:9090/lingo"), body: xml.toXmlString());
    if (response.statusCode == 200) return "";
    else return "Error: ${response.statusCode}; ${response.body}";
  }

  /// returns empty string if OK, or error message in case of failure
  Future<String> deleteTranslation(String key) async {
    final xml = XmlDocument([XmlElement(XmlName("a"), [], [
      XmlElement(XmlName("langCode"), [], [XmlText(_langCode)]),
      XmlElement(XmlName("key"), [], [XmlText(key)]),
    ])]);

    final response = await http.delete(Uri.parse("http://mitrakoff.com:9090/lingo"), body: xml.toXmlString());
    if (response.statusCode == 200) return "";
    else return "Error: ${response.statusCode}; ${response.body}";
  }
}
