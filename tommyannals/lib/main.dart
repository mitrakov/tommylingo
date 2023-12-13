// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tommyannals/model.dart';
import 'package:tommyannals/widgets/events4date.dart';
import 'package:tommyannals/widgets/new_event.dart';

void main() {
  initializeDateFormatting(); // to load locales for TableCalendar
  runApp(ScopedModel(model: MyModel()..schema, child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tommy Annals",
      theme: ThemeData(primarySwatch: Colors.orange),
      home: Scaffold(
        appBar: AppBar(title: const Text("Tommy Annals")),
        body: Column(
          children: [
            TableCalendar(
              startingDayOfWeek: StartingDayOfWeek.monday,
              locale: "es_ES", // make sure to call initializeDateFormatting() from import 'package:intl/date_symbol_data_local.dart';
              focusedDay: DateTime.now(),
              firstDay: DateTime.utc(2000),
              lastDay: DateTime.utc(2040),
              onDaySelected: (selectedDate, focusedDate) => setState(() { _currentDate = selectedDate; }),
            ),
            const Text("Eventos", textScaleFactor: 1.4),
            Expanded(child: EventsForDateViewer(_currentDate)),
          ],
        ),
        floatingActionButton: Builder( //*
          builder: (context) {
            return FloatingActionButton(
              tooltip: "Add new event",
              child: const Icon(Icons.add, size: 40),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewEventWidget(_currentDate))),
            );
          }
        )
      ),
    );
  }
}

// *) to avoid error: "Navigator operation requested with a context that does not include a Navigator."
