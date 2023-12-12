// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyannals/chronicle/schema.dart';
import 'package:tommyannals/model.dart';
import 'package:tommyannals/widgets/trixcontainer.dart';

class NewEventWidget extends StatefulWidget {
  @override
  State<NewEventWidget> createState() => _NewEventWidgetState();
}

class _NewEventWidgetState extends State<NewEventWidget> {
  final TextEditingController eventNameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MyModel>(builder: (context, child, model) {
      return Scaffold(
        appBar: AppBar(title: const Text("Tommy Annals")),
        body: FutureBuilder(future: model.schema, builder: (context, snapshot) {
          if (snapshot.hasError) return Text("ERROR: ${snapshot.error}");
          if (!snapshot.hasData) return const Text("ERROR: No schema found");
          final eventNames = snapshot.data!.map((e) => e.eventName);
          final eventName = eventNameCtrl.text;
          final List<Param> params = eventName.isNotEmpty ? snapshot.data!.firstWhere((schema) => schema.eventName == eventName).params : [];
          final children = [
            const SizedBox(height: 10),
            TypeAheadField<String>(
              textFieldConfiguration: TextFieldConfiguration(controller: eventNameCtrl, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Event name")),
              suggestionsCallback: (prefix) {
                final list = List<String>.from(eventNames);
                list.retainWhere((s) => s.toLowerCase().contains(prefix.toLowerCase()));
                return list;
              },
              itemBuilder: (context, suggestion) => ListTile(title: Text(suggestion)),
              onSuggestionSelected: (newValue) => setState(() {eventNameCtrl.text = newValue;}),
              hideOnEmpty: true,
            ),
            const SizedBox(height: 10),
            ...params.map(_makeParamWidget),
          ];
          return Column(
            children: children,
          );
        }),
      );
    });
  }

  Widget _makeParamWidget(Param p) {
    return TrixContainer(child: Row(children: [
      Text(p.name),
      Text(p.description ?? "–"),
      Text(p.type),
      Text(p.defaultValue ?? "–"),
    ]));
  }
}
