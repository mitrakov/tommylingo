// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:tommypass/model.dart';
import 'package:tommypass/newitem.dart';

void main() {
  runApp(ScopedModel(model: PassModel(), child: TommyPassMain()));
}

class TommyPassMain extends StatefulWidget {
  @override
  State<TommyPassMain> createState() => _TommyPassMainState();
}

class _TommyPassMainState extends State<TommyPassMain> {
  final TextEditingController searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TommyPass",
      theme: ThemeData(primarySwatch: Colors.red),
      builder: BotToastInit(),
      home: Scaffold(
        appBar: AppBar(title: const Text("TommyPass")),
        body: ScopedModelDescendant<PassModel>(builder: (context, child, model) {
          final data = model.resources;
          return Center(
            child: data.isNotEmpty
              ? Column(
                children: [
                  const SizedBox(height: 10),
                  TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: searchCtrl,
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Search")
                    ),
                    suggestionsCallback: (prefix) {
                      final list = data.toList();
                      list.retainWhere((s) => s.toLowerCase().contains(prefix.toLowerCase()));
                      return list;
                    },
                    itemBuilder: (context, suggestion) => ListTile(title: Text(suggestion)),
                    onSuggestionSelected: (s) => setState(() {
                      model.loadResource(s);
                      searchCtrl.text = s;
                    }),
                  ),
                  Text(searchCtrl.text, style: Theme.of(context).textTheme.headlineMedium),
                  Text(model.currentLogin),
                  Text(model.currentPassword),
                  Text(model.currentNote),
                ],
              )
              : const RefreshProgressIndicator()
          );
        }),
        floatingActionButton: Builder(builder: (context) { // Navigator.push(context, ...) should take a separate context
          return FloatingActionButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewItemWidget())),
            tooltip: 'Add new',
            child: const Icon(Icons.add),
          );
        }),
      ),
    );
  }
}
