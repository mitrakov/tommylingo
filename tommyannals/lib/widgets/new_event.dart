// ignore_for_file: use_key_in_widget_constructors, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyannals/chronicle/schema.dart';
import 'package:tommyannals/model.dart';
import 'package:tommyannals/widgets/trixcontainer.dart';

class NewEventWidget extends StatefulWidget {
  final DateTime date;

  const NewEventWidget(this.date);

  @override
  State<NewEventWidget> createState() => _NewEventWidgetState();
}

class _NewEventWidgetState extends State<NewEventWidget> {
  final TextEditingController eventNameCtrl = TextEditingController();
  final Map<String, String> paramNamesValues = {}; // paramName => paramValue (only for current Event Name)

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
              onSuggestionSelected: (newValue) => setState(() {
                eventNameCtrl.text = newValue;
                paramNamesValues.clear();
              }),
              hideOnEmpty: true,
            ),
            const SizedBox(height: 10),
            ...params.map(_makeParamWidget),
          ];
          return Column(
            children: children,
          );
        }),
        floatingActionButton: FloatingActionButton(
          tooltip: "Submit",
          child: const Icon(Icons.send_rounded, size: 30),
          onPressed: () {
            paramNamesValues.forEach((paramName, paramValue) => model.addForDate(widget.date, eventNameCtrl.text, paramName, paramValue));
            Navigator.pop(context);
          },
        ),
      );
    });
  }

  Widget _makeParamWidget(Param p) {
    if (p.defaultValue != null)
      paramNamesValues[p.name] = p.defaultValue!;
    return TrixContainer(child: ListTile(
      title: Text(p.name),
      subtitle: Text(p.description ?? "no description"),
      trailing: SizedBox(
        width: 180,
        child: TextFormField(
          initialValue: p.defaultValue,
          inputFormatters: p.type == "N" ? [FilteringTextInputFormatter.allow(RegExp(r'[\d.,]'))] : null,  // digits, "." for Android, "," for iOS
          keyboardType: p.type == "N" ? const TextInputType.numberWithOptions(decimal: true) : null,
          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Value"),
          onChanged: (s) => paramNamesValues[p.name] = s,
        )
      ),
    ));
  }
}
