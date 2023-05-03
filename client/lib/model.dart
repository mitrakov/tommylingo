// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print
import 'dart:math';
import 'package:scoped_model/scoped_model.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

typedef TokenPair = Tuple2<String, String>;

class MyModel extends Model {
  // vals
  final String _URL = "http://mitrakoff.com:9090/lingo";
  final Set<String> _stopKeywords = {"RUS"};              // TODO
  final Random _random = Random(DateTime.now().millisecondsSinceEpoch);
  final Map<String, List<TokenPair>> _data = {}; // files -> tokens

  // vars
  String _currentFile = "";
  int _currentToken = 0;

  // getters and setters
  List<String> get files {
    final list = _data.keys.toList();
    list.sort();
    return list;
  }
  TokenPair get token {
    final list = _data[_currentFile] ?? [];
    if (_currentToken >= list.length)
      _currentToken = 0;
    return list.isEmpty ? const Tuple2("", "") : list[_currentToken];
  }
  set currentFile(String s) {
    _currentFile = s;
    _currentToken = 0;
    _data[s]?.shuffle(_random);
    notifyListeners();
  }

  // functions
  void nextToken() {
    _currentToken++;
    notifyListeners();
  }

  void loadAll() async {
    loadMore("en_US");
    // final response = await http.get(Uri.parse(_URL));
    // if (response.statusCode == 200) {
    //   final htmlDoc = parse(response.body);
    //   final elements = htmlDoc.getElementsByTagName("a");
    //   for (final element in elements) {
    //     _loadFile(element.text);
    //   }
    // } else throw Exception("Cannot load files from $_URL");
  }

  void _loadFile(String fileName) async {
    final response = await http.get(Uri.parse("$_URL/$fileName"));
    if (response.statusCode == 200) {
      _data.putIfAbsent(fileName, () => []);
      final body = response.body;
      final lines = body.split("\n");
      for (final line in lines) {
        final tokens = line.split("|");
        if (tokens.length > 2) {
          final token1 = tokens[1].trim();
          final token2 = tokens[2].trim();
          if (token1.isNotEmpty && token2.isNotEmpty) {
            if (!token1.contains("---") && !token2.contains("---")) {
              if (!_stopKeywords.contains(token2)) {
                _data[fileName]?.add(Tuple2(token1, token2));
              }
            }
          }
        }
      }
    } else throw Exception("Cannot load file $_URL/$fileName");
  }

  void loadMore(String langCode) async {
    final response = await http.get(Uri.parse("$_URL/translations/$langCode"));
    if (response.statusCode == 200) {
      final all = XmlDocument.parse(response.body).findAllElements("item").map((e) => "${e.getAttribute("key")} -> ${e.text}");
      print(all);
    }
  }
}
