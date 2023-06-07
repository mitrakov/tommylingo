// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommypass/model.dart';

class PrimaryWidget extends StatefulWidget {
  @override
  State<PrimaryWidget> createState() => _PrimaryWidgetState();
}

class _PrimaryWidgetState extends State<PrimaryWidget> {
  final TextEditingController searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TommyPass")),
      body: ScopedModelDescendant<PassModel>(builder: (context, child, model) {
        final data = model.resources;
        return Center(
          child: data.isNotEmpty
            ? Column(
              children: [
                const SizedBox(height: 10),
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(controller: searchCtrl, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Search")),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/newItem"),
        tooltip: 'Add new',
        child: const Icon(Icons.add),
      ),
    );
  }
}
