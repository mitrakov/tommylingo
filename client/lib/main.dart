// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommylingo/model.dart';
import 'package:tommylingo/utils.dart';

void main() {
  runApp(ScopedModel(model: MyModel(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tommylingo",
      theme: ThemeData(primarySwatch: Colors.green),
      home: ScopedModelDescendant<MyModel>(builder: (context, child, model) {
        return FutureBuilder(future: model.token, builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(title: const Text("Tommylingo")),
            body: snapshot.hasData
              ? GestureDetector(
                  onTap: () {
                    if (snapshot.data!.item1.isNotEmpty) {
                      Fluttertoast.showToast(msg: snapshot.data!.item1, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.grey);
                    }
                    model.nextToken();
                  },
                  child: Center(
                    child: Text(
                      snapshot.data!.item2.isNotEmpty ? snapshot.data!.item2 : "Press ☰ and choose language...",
                      style: Theme.of(context).textTheme.headlineSmall
                    ),
                  ),
                )
              : const RefreshProgressIndicator(),
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
                        model.langCode = "en-GB";
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text("es-ES"),
                      onTap: () {
                        model.langCode = "es-ES";
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
                if (snapshot.hasData && snapshot.data!.item1.isNotEmpty) {
                  Utils.showMessage(context, snapshot.data!.item2, snapshot.data!.item1);
                }
              },
            ),
          );
        });
      }),
    );
  }
}
