import 'package:flutter/material.dart';
import 'package:flutter_ui_widgets/widgets/pop_switch/pop_switch.dart';

class PopSwitchScreen extends StatefulWidget {
  static const path = "pop_switch_screen";

  const PopSwitchScreen({Key? key}) : super(key: key);

  @override
  State<PopSwitchScreen> createState() => _PopSwitchScreenState();
}

class _PopSwitchScreenState extends State<PopSwitchScreen> {
  final _currentValue = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PopSwitch"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: ValueListenableBuilder<bool>(
            valueListenable: _currentValue,
            builder: (context, currentValue, child) {
              return PopSwitch(
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
