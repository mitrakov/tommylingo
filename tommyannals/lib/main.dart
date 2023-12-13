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
  DateTime _focusedDate = DateTime.now();
  DateTime? _selectedDate;

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
              startingDayOfWeek: StartingDayOfWeek.monday, // Sunday by default
              locale: "es_ES", // make sure to call initializeDateFormatting() from import 'package:intl/date_symbol_data_local.dart';
              firstDay: DateTime.utc(2000),
              lastDay: DateTime.utc(2040),
              focusedDay: _focusedDate,
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day), // https://github.com/aleksanderwozniak/table_calendar/blob/master/example/lib/pages/basics_example.dart
              onPageChanged: (focusedDay) { _focusedDate = focusedDay; },   // no need to "setState()" here
              onDaySelected: (selectedDate, focusedDate) {
                if (!isSameDay(_selectedDate, selectedDate)) {
                  setState(() {
                    _selectedDate = selectedDate;
                    _focusedDate = focusedDate;
                  });
                }
              },
            ),
            const Text("Eventos", textScaleFactor: 1.4),
            Expanded(child: EventsForDateViewer(_focusedDate)),
          ],
        ),
        floatingActionButton: Builder( // to avoid error: "Navigator operation requested with a context that does not include a Navigator."
          builder: (context) {
            return FloatingActionButton(
              tooltip: "Add new event",
              child: const Icon(Icons.add, size: 40),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewEventWidget(_focusedDate))),
            );
          }
        )
      ),
    );
  }
}
