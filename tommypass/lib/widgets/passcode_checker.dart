// ignore_for_file: use_key_in_widget_constructors, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasscodeChecker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PasscodeCheckerState();
}

class PasscodeCheckerState extends State<PasscodeChecker> {
  final TextEditingController curPasscodeCtrl = TextEditingController();
  final TextEditingController myPasscodeCtrl = TextEditingController();

  @override
  void initState() {
    // checking if the local storage has a passcode. If not, the app is open for the first time => move to login screen
    super.initState();
    SharedPreferences.getInstance().then((storage) {
      if (storage.containsKey("passcode"))
        curPasscodeCtrl.text = storage.getString("passcode") ?? "";
      else Navigator.popAndPushNamed(context, "/setPasscode");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          obscureText: true,
          controller: myPasscodeCtrl,
          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Input a passcode"),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          child: const Text("Verify", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
          onPressed: () {
            if (myPasscodeCtrl.text == curPasscodeCtrl.text)
              Navigator.popAndPushNamed(context, "/main");
            else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Incorrect passcode")));
          },
        ),
      ],
    )));
  }
}
