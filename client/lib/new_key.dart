// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        appBar: AppBar(title: Text(token != null ? 'Edit "${token!.item1}" for ${model.langCode}' : "Add new translation for ${model.langCode}")),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextField(controller: keyController, decoration: const InputDecoration(labelText: "Key")),
              const SizedBox(height: 10),
              TextField(controller: translationController, decoration: const InputDecoration(labelText: "Translation")),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final key = keyController.text;
                  final translation = translationController.text;
                  if (key.isNotEmpty && translation.isNotEmpty) {
                    final error = await model.upsertTranslation(key, translation);
                    Fluttertoast.showToast(msg: error.isEmpty ? "Success!" : error, gravity: ToastGravity.BOTTOM, backgroundColor: error.isEmpty ? Colors.green : Colors.red);
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
