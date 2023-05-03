// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';         TODO
import 'package:scoped_model/scoped_model.dart';
import 'package:tommylingo/model.dart';

void main() {
  final model = MyModel();
  model.loadAll();
  runApp(ScopedModel<MyModel>(model: model, child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TommyLingo",
      theme: ThemeData(primarySwatch: Colors.green),
      home: ScopedModelDescendant<MyModel>(builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(title: const Text("TommyLingo")),
          body: GestureDetector(
            onTap: () {
              if (model.token.item1.isNotEmpty) {
                // Fluttertoast.showToast(msg: model.token.item1, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.grey); TODO
              }
              model.nextToken();
            },
            child: Center(
              child: Text(
                model.token.item2.isNotEmpty ? model.token.item2 : "Press ☰ and choose language...",
                style: Theme.of(context).textTheme.headlineSmall
              ),
            ),
          ),
          drawer: Drawer(
            child: Column(children: [
              SizedBox(
                height: 100,
                width: double.infinity,
                child: DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.lightGreen),
                  child: Text("Languages", style: Theme.of(context).textTheme.headlineMedium)
                ),
              ),
              Expanded(
                child: ListView(children: [
                  ListTile(
                    title: const Text("en-GB"), // https://www.oracle.com/java/technologies/javase/java8locales.html
                    onTap: () {
                      model.currentFile = "en-GB";
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text("es-ES"),
                    onTap: () {
                      model.currentFile = "es-ES";
                      Navigator.pop(context);
                    },
                  ),
                ]),
              ),
            ]),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: "Show hint",
            child: const Icon(Icons.help_rounded),
            onPressed: () {
              model.loadMore("en_US");
              //if (model.token.item1.isNotEmpty) Utils.showMessage(context, model.token.item2, model.token.item1); TODO
            },
          ),
        );
      }),
    );
  }
}
