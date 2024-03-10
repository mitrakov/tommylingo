// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:tommylingo/settings.dart';

class TotalProgressWidget extends StatefulWidget {
  final _QUESTIONS = 25;

  const TotalProgressWidget({super.key});

  @override
  State<TotalProgressWidget> createState() => TotalProgressWidgetState();
}

class TotalProgressWidgetState extends State<TotalProgressWidget> {
  DateTime _firstDay = DateTime.now();
  DateTime _lastDay = DateTime.now();
  int _questionsDone = 0;

  @override
  void initState() {
    super.initState();
    final firstDay = Settings.instance.getFirstDate();
    final lastDay = Settings.instance.getLastDate();
    final now = DateTime.now();
    if (now.difference(lastDay).inDays > 1) {
      final text = "Sorry, your progress with ${lastDay.difference(firstDay).inDays} days has been reset!";
      Settings.instance.setFirstDateAsToday();
      Settings.instance.setLastDateAsToday();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), duration: const Duration(seconds: 5)));
    }
    _firstDay = Settings.instance.getFirstDate();
    _lastDay = Settings.instance.getLastDate();
  }

  @override
  Widget build(BuildContext context) {
    final isOkToday = _questionsDone >= widget._QUESTIONS;
    final totalDays = _lastDay.difference(_firstDay).inDays + (isOkToday ? 1 : 0);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("$_questionsDone/${widget._QUESTIONS}", style: TextStyle(color: isOkToday ? Colors.green : Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Text("Total days: $totalDays"),
        ],
      ),
    );
  }

  void addOne() {
    setState(() {
      _questionsDone++;
      if (_questionsDone == widget._QUESTIONS) // level up!
        Settings.instance.setLastDateAsToday();
    });
  }
}
