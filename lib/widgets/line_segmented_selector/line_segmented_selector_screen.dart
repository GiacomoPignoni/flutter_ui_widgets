import 'package:flutter/material.dart';
import 'package:flutter_ui_widgets/widgets/constants.dart';
import 'package:flutter_ui_widgets/widgets/line_segmented_selector/line_segmented_selector.dart';

enum Value {
  first,
  second,
  third
}

class LineSegmentedSelectorScreen extends StatefulWidget {
  static const path = "line_segmented_selector_screen";

  const LineSegmentedSelectorScreen({Key? key}) : super(key: key);

  @override
  State<LineSegmentedSelectorScreen> createState() => _LineSegmentedSelectorScreenState();
}

class _LineSegmentedSelectorScreenState extends State<LineSegmentedSelectorScreen> {
  final _selectedValue = ValueNotifier<Value>(Value.first);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LineSegmentedSelector")
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: defaultConstraints,
            child: ValueListenableBuilder<Value>(
              valueListenable: _selectedValue,
              builder: (context, selectedValue, child) {
                return LineSegmentedSelector<Value>(
                  selectedValue: selectedValue,
                  buttons: [
                    LineSegmentedSelectorButton<Value>(
                      text: "First",
                      value: Value.first
                    ),
                    LineSegmentedSelectorButton<Value>(
                      text: "Second",
                      value: Value.second
                    ),
                    LineSegmentedSelectorButton<Value>(
                      text: "Third",
                      value: Value.third
                    )
                  ],
                  onSelectionChanged: (newValue) => _selectedValue.value = newValue
                );
              },
            ),
          ),
        ),
      )
    );
  }
}
