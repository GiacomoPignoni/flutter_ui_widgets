import 'package:flutter/material.dart';
import 'package:flutter_ui_widgets/widgets/pop_switch/pop_switch.dart';

class PopSwitchScreen extends StatefulWidget {
  static const path = "pop_switch_screen";

  const PopSwitchScreen({Key? key}) : super(key: key);

  @override
  State<PopSwitchScreen> createState() => _PopSwitchScreenState();
}

class _PopSwitchScreenState extends State<PopSwitchScreen> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: PopSwitch(
            checked: value,
            onCheckedChange: (newValue) {
              setState(() {
                value = newValue;
              });
            },
          )
        ),
      )
    );
  }
}
