// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyannals/model.dart';

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
          final children = snapshot.data!.map((e) => ListTile(title: Text(e))).toList(); // TODO ListTile onTap()
          return ListView(children: children);
        }),
      );
    });
  }
}
