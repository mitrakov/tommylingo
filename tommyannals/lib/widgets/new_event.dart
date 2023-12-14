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
  final Map<String, dynamic> paramNames2Values = {}; // paramName => paramValue for current Event Name

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
                paramNames2Values.clear();
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
    storeParam(String value) {
      switch (p.type) {
        case "S":
          paramNames2Values[p.nameUtf8] = value.trim();
          break;
        case "N":
          paramNames2Values[p.nameUtf8] = int.tryParse(value.trim()) ?? double.tryParse(value.trim().replaceAll(",", "."));
          break;
        case "B":
          paramNames2Values[p.nameUtf8] = value.trim().toLowerCase() == "true";
          break;
        // add other types here
      }
    }

    if (p.defaultValueUtf8 != null) // onChange() is not called on TextFormField when "initialValue" is assigned, so we need to store initial values explicitly
      storeParam(p.defaultValueUtf8!);
    final isNumeric = p.type == "N";
    return TrixContainer(child: ListTile(
      title: Text(p.nameUtf8),
      subtitle: Text(p.descriptionUtf8 ?? "Ninguna descripción"),
      trailing: SizedBox(
        width: 170,
        child: TextFormField(
          initialValue: p.defaultValueUtf8,
          inputFormatters: isNumeric ? [FilteringTextInputFormatter.allow(RegExp(r'[\d.,]'))] : null,  // digits, "." for Android, "," for iOS
          keyboardType: isNumeric ? const TextInputType.numberWithOptions(decimal: true) : null, // TODO: add Boolean type
          decoration: InputDecoration(border: const OutlineInputBorder(), labelText: p.unitUtf8 != null ? "Valor (${p.unitUtf8})" : "Valor"),
          onChanged: (s) {
            if (s.isEmpty) paramNames2Values.remove(p.nameUtf8);
            else storeParam(s);
          },
        )
      ),
    ));
  }

  void _submit(MyModel model) {
    if (paramNames2Values.isNotEmpty) {
      model.addForDate(widget.date, eventNameCtrl.text, paramNames2Values, null);
      Navigator.pop(context);
    } else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Especifique los parámetros")));
  }
}
