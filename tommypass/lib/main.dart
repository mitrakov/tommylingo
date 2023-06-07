// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommypass/model.dart';
import 'package:tommypass/widgets/newitem.dart';
import 'package:tommypass/widgets/passcode_checker.dart';
import 'package:tommypass/widgets/passcode_setter.dart';
import 'package:tommypass/widgets/primary.dart';

void main() {
  runApp(ScopedModel(model: PassModel(), child: TommyPassMain()));
}

class TommyPassMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TommyPass",
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: "/checkPasscode",
      routes: {
        "/checkPasscode": (c) => PasscodeChecker(),
        "/setPasscode": (c) => PasscodeSetter(),
        "/main": (c) => PrimaryWidget(),
        "/newItem": (c) => NewItemWidget(),
      },
    );
  }
}
