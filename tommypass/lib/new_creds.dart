// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommypass/item/passitem.dart';
import 'package:tommypass/model.dart';

class NewCredentials extends StatelessWidget {
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
                onPressed: () async {
                  final resource = resourceCtrl.text;
                  final login = userNameCtrl.text;
                  final password = passwordCtrl.text;
                  final note = optNoteCtrl.text.isNotEmpty ? optNoteCtrl.text : null;
                  if (resource.isNotEmpty && login.isNotEmpty && password.isNotEmpty) {
                    final item = PassItem(0, resource, login, password, note);
                    await model.addNewItem(item);
                    if (Platform.isAndroid || Platform.isIOS) // TODO: check cross-platform plugins!
                      Fluttertoast.showToast(msg: "Done!", gravity: ToastGravity.BOTTOM, backgroundColor: Colors.greenAccent);
                    Navigator.pop(context);
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
