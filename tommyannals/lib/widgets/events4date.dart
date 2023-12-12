// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyannals/chronicle/chronicle.dart';
import 'package:tommyannals/model.dart';
import 'package:tommyannals/widgets/new_event.dart';
import 'package:tommyannals/widgets/trixcontainer.dart';

class EventsForDateViewer extends StatelessWidget {
  final DateTime date;

  const EventsForDateViewer(this.date);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MyModel>(builder: (context, child, model) {
      return Scaffold(
        appBar: AppBar(title: const Text("Tommy Annals")),
        body: FutureBuilder(future: model.getForDate(date), builder: (context, snapshot) {
          if (snapshot.hasError) return Text("ERROR: ${snapshot.error}");
          if (!snapshot.hasData) return Text("No data for $date");
          final children = snapshot.data!.map(_createTile).toList();
          return ListView(children: children);
        }),
        floatingActionButton: FloatingActionButton(
          tooltip: "Add new event",
          child: const Icon(Icons.add, size: 40),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewEventWidget())),
        ),
      );
    });
  }

  Widget _createTile(Chronicle chronicle) {
    return TrixContainer(child: ListTile(
      title: Text(chronicle.eventName, textScaleFactor: 1.5),
      trailing: Text(chronicle.valueStr ?? "–"),
    ));
  }
}
