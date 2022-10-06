import 'package:flutter/material.dart';
import 'package:flutter_ui_widgets/widgets/constants.dart';
import 'package:flutter_ui_widgets/widgets/cupertino_style_segmented_selector/cupertino_style_segmented_selector.dart';

enum Value {
  light,
  dark,
  auto
}

class CupertioStyleSegmentedSelectorScreen extends StatefulWidget {
  static const path = "cupertino_style_segmented_selector_screen";

  const CupertioStyleSegmentedSelectorScreen({Key? key}) : super(key: key);

  @override
  State<CupertioStyleSegmentedSelectorScreen> createState() => _CupertioStyleSegmentedSelectorScreenState();
}

class _CupertioStyleSegmentedSelectorScreenState extends State<CupertioStyleSegmentedSelectorScreen> {
  final _selectedValue = ValueNotifier<Value>(Value.light);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CupertioStyleSegmentedSelector"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: defaultConstraints,
            child: ValueListenableBuilder<Value>(
              valueListenable: _selectedValue,
              builder: (context, selectedValue, child) {
                return CupertioStyleSegmentedSelector<Value>(
                  selectedValue: selectedValue,
                  buttons: [
                    CupertioStyleSegmentedSelectorButton(
                      value: Value.light,
                      text: "Light",
                      icon: Icons.light_mode_rounded
                    ),
                     CupertioStyleSegmentedSelectorButton(
                      value: Value.dark,
                      text: "Dark",
                      icon: Icons.dark_mode_rounded
                    ),
                     CupertioStyleSegmentedSelectorButton(
                      value: Value.auto,
                      text: "Auto",
                      icon: Icons.auto_mode_rounded
                    )
                  ],
                  onSelectionChanged: (newSelectedValue) {
                    _selectedValue.value = newSelectedValue;
                  },
                );
              },
            ),
          ),
        ),
      )
    );
  }
}
