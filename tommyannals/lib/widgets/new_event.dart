// ignore_for_file: use_key_in_widget_constructors, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyannals/chronicle/chronicle_add_request.dart';
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
  final Map<String, String> paramNamesStrValues = {}; // paramName => string  Value for current Event Name
  final Map<String, double> paramNamesNumValues = {}; // paramName => numeric Value for current Event Name

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MyModel>(builder: (context, child, model) {
      return Scaffold(
        appBar: AppBar(title: const Text("Tommy Annals")),
        body: FutureBuilder(future: model.schema, builder: (context, snapshot) {
          if (snapshot.hasError) return Text("ERROR: ${snapshot.error}");
          if (!snapshot.hasData) return const Text("ERROR: No se encontró esquema");

          final eventNames = snapshot.data!.map((e) => e.eventName);
          final eventName = eventNameCtrl.text;
          final eventDescription   = eventName.isNotEmpty ? snapshot.data!.firstWhere((schema) => schema.eventName == eventName).eventDescription : null;
          final List<Param> params = eventName.isNotEmpty ? snapshot.data!.firstWhere((schema) => schema.eventName == eventName).params : [];
          final children = [
            const SizedBox(height: 10),
            TypeAheadField<String>(
              textFieldConfiguration: TextFieldConfiguration(controller: eventNameCtrl, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Nombre del evento")),
              suggestionsCallback: (prefix) {
                final list = List<String>.from(eventNames);
                list.retainWhere((s) => s.toLowerCase().contains(prefix.toLowerCase()));
                return list;
              },
              itemBuilder: (context, suggestion) => ListTile(title: Text(suggestion)),
              onSuggestionSelected: (newValue) => setState(() {
                eventNameCtrl.text = newValue;
                paramNamesStrValues.clear();
                paramNamesNumValues.clear();
              }),
              hideOnEmpty: true,
            ),
            SizedBox(height: eventDescription != null ? 10 : 0),
            Padding(padding: const EdgeInsets.only(left: 12), child: Text(eventDescription ?? "", textScaleFactor: 0.9)),
            const SizedBox(height: 10),
            ...params.map(_makeParamWidget),
          ];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          );
        }),
        floatingActionButton: FloatingActionButton(
          tooltip: "Enviar",
          child: const Icon(Icons.send_rounded, size: 30),
          onPressed: () => _submit(model),
        ),
      );
    });
  }

  Widget _makeParamWidget(Param p) {
    final isNumeric = p.type == "N"; // "N" or "S" possible

    if (p.defaultValue != null) {
      // onChange() is not called on TextFormField when "initialValue" is assigned, so we need to store initial values explicitly
      isNumeric ? paramNamesNumValues[p.name] = _parseDouble(p.defaultValue!) : paramNamesStrValues[p.name] = p.defaultValue!;
    }

    return TrixContainer(child: ListTile(
      title: Text(p.name),
      subtitle: Text(p.description ?? "Ninguna descripción"),
      trailing: SizedBox(
        width: 170,
        child: TextFormField(
          initialValue: p.defaultValue,
          inputFormatters: isNumeric ? [FilteringTextInputFormatter.allow(RegExp(r'[\d.,]'))] : null,  // digits, "." for Android, "," for iOS
          keyboardType: isNumeric ? const TextInputType.numberWithOptions(decimal: true) : null,
          decoration: InputDecoration(border: const OutlineInputBorder(), labelText: p.unit != null ? "Valor (${p.unit})" : "Valor"),
          onChanged: (s) => isNumeric ? paramNamesNumValues[p.name] = _parseDouble(s) : paramNamesStrValues[p.name] = s,
        )
      ),
    ));
  }

  void _submit(MyModel model) {
    final params = [
    ...paramNamesStrValues.entries.map((e) => ChronicleAddRequestParam(e.key, e.value, null)),
    ...paramNamesNumValues.entries.map((e) => ChronicleAddRequestParam(e.key, null, e.value)),
    ];
    if (params.isNotEmpty) {
      model.addForDate(widget.date, eventNameCtrl.text, params);
      Navigator.pop(context);
    } else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Especifique los parámetros")));
  }

  double _parseDouble(String s) {
    final d = double.tryParse(s);
    if (d == null)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No se puede analizar el número: $s")));
    return d ?? -1;
  }
}
