import 'package:flutter/material.dart';
import 'package:flutter_ui_widgets/widgets/minimalist_switch/minimalist_switch.dart';

class MinimalistSwitchScreen extends StatefulWidget {
  static const path = "minimalist_switch_screen";

  const MinimalistSwitchScreen({Key? key}) : super(key: key);

  @override
  State<MinimalistSwitchScreen> createState() => _MinimalistSwitchScreenState();
}

class _MinimalistSwitchScreenState extends State<MinimalistSwitchScreen> {
  final _currentValue = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MinimalistSwitch"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: ValueListenableBuilder<bool>(
            valueListenable: _currentValue,
            builder: (context, currentValue, child) {
              return MinimalistSwitch(
                checked: currentValue,
                onCheckedChange: (newValue) {
                  setState(() {
                    _currentValue.value = newValue;
                  });
                },
              );
            }
          )
        ),
      )
    );
  }
}
