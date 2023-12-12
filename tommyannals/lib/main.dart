// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tommyannals/events4date.dart';
import 'package:tommyannals/model.dart';

void main() {
  runApp(ScopedModel(model: MyModel(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tommy Annals",
      theme: ThemeData(primarySwatch: Colors.orange),
      home: Scaffold(
        appBar: AppBar(title: const Text("Tommy Annals")),
        body: Builder(builder: (context) { // wrap into a Builder to avoid "Navigator operation requested with a context" error
          return TableCalendar(focusedDay: DateTime.now(), firstDay: DateTime.utc(2000), lastDay: DateTime.utc(2040), onDaySelected: (selectedDate, focusedDate) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EventsForDateViewer(selectedDate)));
          });
        }),
      ),
    );
  }
}
