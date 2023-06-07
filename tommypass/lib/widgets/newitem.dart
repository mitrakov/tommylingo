// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:tommypass/item/passitem.dart';
import 'package:tommypass/model.dart';

class NewItemWidget extends StatelessWidget {
  final TextEditingController resourceCtrl = TextEditingController();
  final TextEditingController userNameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController optNoteCtrl  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PassModel>(builder: (context, child, model) {
      return Scaffold(
        appBar: AppBar(title: const Text("Add new credentials")),
        body: Center(
          child: Column(
            children: [
              TextField(controller: resourceCtrl, decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Resource")),
              TextField(controller: userNameCtrl, decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Login")),
              TextField(controller: passwordCtrl, decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Password")),
              TextField(controller: optNoteCtrl,  decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: "Note (optional)")),
              ElevatedButton(
                onPressed: () => _onOkPressed(context, model),
                child: const Text("OK")
              ),
            ],
          ),
        ),
      );
    });
  }

  void _onOkPressed(BuildContext context, PassModel model) async {
    final resource = resourceCtrl.text.trim();
    final login = userNameCtrl.text.trim();
    final password = passwordCtrl.text.trim();
    final note = optNoteCtrl.text.isNotEmpty ? optNoteCtrl.text.trim() : null;
    if (resource.isNotEmpty && login.isNotEmpty && password.isNotEmpty) {
      final item = PassItem(0, resource, login, password, note);
      final error = await model.addNewItem(item);
      BotToast.showText(text: error.isEmpty ? "Done!" : error, duration: const Duration(seconds: 3), contentColor: error.isEmpty ? Colors.green[400]! : Colors.red[400]!);
      if (error.isEmpty)
        Navigator.pop(context);
    }
  }
}
