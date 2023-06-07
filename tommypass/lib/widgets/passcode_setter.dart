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
        TextField(
          controller: ctrl1,
          obscureText: true,
          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Set your passcode"),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: ctrl2,
          obscureText: true,
          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Verify your passcode"),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          child: const Text("Set passcode", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
          onPressed: () async {
            if (ctrl1.text.isEmpty || ctrl2.text.isEmpty)
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Empty passcode!")));
            else if (ctrl1.text == ctrl2.text) {
              final storage = await SharedPreferences.getInstance();
              storage.setString("passcode", ctrl1.text).then((value) => Navigator.popAndPushNamed(context, "/main"));
            } else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passcode fields differ!")));
          },
        ),
      ],
    )));
  }
}
