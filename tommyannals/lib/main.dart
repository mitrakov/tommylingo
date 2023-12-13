// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tommyannals/widgets/events4date.dart';
import 'package:tommyannals/model.dart';

void main() {
  initializeDateFormatting(); // to load locales for TableCalendar
  runApp(ScopedModel(model: MyModel()..schema, child: MyApp()));
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
          return TableCalendar(
            startingDayOfWeek: StartingDayOfWeek.monday,
            locale: "es_ES", // make sure to call initializeDateFormatting() from import 'package:intl/date_symbol_data_local.dart';
            focusedDay: DateTime.now(),
            firstDay: DateTime.utc(2000),
            lastDay: DateTime.utc(2040),
            onDaySelected: (selectedDate, focusedDate) => Navigator.push(context, MaterialPageRoute(builder: (_) => EventsForDateViewer(selectedDate)))
          );
        }),
      ),
    );
  }
}
