import 'package:flutter/material.dart';
import 'package:flutter_ui_widgets/widgets/minimalist_switch/minimalist_switch.dart';

class MinimalistSwitchScreen extends StatefulWidget {
  static const path = "minimalist_switch_screen";

  const MinimalistSwitchScreen({Key? key}) : super(key: key);

  @override
  State<MinimalistSwitchScreen> createState() => _MinimalistSwitchScreenState();
}

class _MinimalistSwitchScreenState extends State<MinimalistSwitchScreen> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: MinimalistSwitch(
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
