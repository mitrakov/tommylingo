// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model.dart';

class NewKey extends StatelessWidget {
  final TextEditingController keyController = TextEditingController();
  final TextEditingController translationController = TextEditingController();
  final TokenPair? token;

  NewKey({this.token}) {
    final token = this.token;
    if (token != null) {
      keyController.text = token.item1;
      translationController.text = token.item2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MyModel>(builder: (context, child, model) {
      return Scaffold(
        appBar: AppBar(title: Text(token != null ? 'Edit "${token!.item1}" for ${model.langCode}' : "New translation for ${model.langCode}")),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              TypeAheadField<String>(
                controller: keyController,
                builder: (c, t, f) => TextField(
                  controller: keyController,
                  focusNode: f,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Key"),
                ),
                suggestionsCallback: (prefix) {
                  final list = List<String>.from(model.keys);
                  list.retainWhere((s) => s.toLowerCase().contains(prefix.toLowerCase()));
                  return list;
                },
                itemBuilder: (context, suggestion) => ListTile(title: Text(suggestion)),
                onSelected: (newValue) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(model.getValue(newValue)), duration: const Duration(seconds: 1)));
                  keyController.text = newValue;
                },
                hideOnEmpty: true,
              ),
              const SizedBox(height: 20),
              TextField(controller: translationController, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Translation")),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final key = keyController.text;
                  final translation = translationController.text;
                  if (key.isNotEmpty && translation.isNotEmpty) {
                    final error = await model.upsertTranslation(key, translation);
                    final bar = SnackBar(content: Text(error.isEmpty ? "Success!" : error), duration: const Duration(seconds: 3), backgroundColor: error.isEmpty ? Colors.green : Colors.red);
                    ScaffoldMessenger.of(context).showSnackBar(bar);
                    if (error.isEmpty) Navigator.pop(context);
                  }
                },
                child: const Text("OK")
              ),
            ],
          ),
        ),
      );
    });
  }
}
