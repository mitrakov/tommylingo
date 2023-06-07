// ignore_for_file: use_key_in_widget_constructors, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasscodeSetter extends StatelessWidget {
  final TextEditingController ctrl1 = TextEditingController();
  final TextEditingController ctrl2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: ctrl1,
            obscureText: true,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Set your passcode"),
          )
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: ctrl2,
            obscureText: true,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Verify your passcode"),
          )
        ),
        Padding(
          padding: const EdgeInsets.all(40),
          child: Builder(builder: (context1) => ElevatedButton(
            child: const Text("Set passcode", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
            onPressed: () {
              if (ctrl1.text.isEmpty || ctrl2.text.isEmpty)
                ScaffoldMessenger.of(context1).showSnackBar(const SnackBar(content: Text("Empty passcode!")));
              else if (ctrl1.text == ctrl2.text)
                setPasscode(ctrl1.text).then((b) => Navigator.popAndPushNamed(context1, "/main"));
              else ScaffoldMessenger.of(context1).showSnackBar(const SnackBar(content: Text("Passcode fields differ!")));
            },
          )),
        ),
      ],
    )));
  }

  Future<bool> setPasscode(String passcode) async {
    final storage = await SharedPreferences.getInstance();
    return storage.setString("passcode", passcode);
  }
}
