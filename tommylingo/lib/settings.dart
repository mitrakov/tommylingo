// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  Settings._();

  static const String _firstDate  = "_FIRST_DATE";
  static const String _lastDate  = "_LAST_DATE";

  static final Settings _instance = Settings._();

  static Settings get instance => _instance;

  SharedPreferences? _storage; // don't mark as "late final"!

  Future<void> init() async {
    _storage ??= await SharedPreferences.getInstance();
  }

  DateTime getFirstDate() {
    _check();
    final day = _storage!.getString(_firstDate);
    return day != null ? DateTime.parse(day) : DateTime.now();
  }

  DateTime getLastDate() {
    _check();
    final day = _storage!.getString(_lastDate);
    return day != null ? DateTime.parse(day) : DateTime.now();
  }

  Future<bool> setFirstDateAsToday() {
    _check();
    return _storage!.setString(_firstDate, DateTime.now().toString());
  }

  Future<bool> setLastDateAsToday() {
    _check();
    return _storage!.setString(_lastDate, DateTime.now().toString());
  }

  void _check() {
    if (_storage == null) throw Exception("Call Settings.init() in main app widget");
  }
}
