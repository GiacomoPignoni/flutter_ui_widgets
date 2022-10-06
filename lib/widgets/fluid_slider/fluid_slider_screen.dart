import 'package:flutter/material.dart';
import 'package:flutter_ui_widgets/widgets/constants.dart';
import 'package:flutter_ui_widgets/widgets/fluid_slider/fluid_slider.dart';

enum Value {
  first,
  second,
  third
}

class FluidSliderScreen extends StatefulWidget {
  static const path = "fluid_slider_screen";

  const FluidSliderScreen({Key? key}) : super(key: key);

  @override
  State<FluidSliderScreen> createState() => _FluidSliderScreenState();
}

class _FluidSliderScreenState extends State<FluidSliderScreen> {
  final _currentValue = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FluidSlider"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: defaultConstraints,
            child: ValueListenableBuilder<int>(
              valueListenable: _currentValue,
              builder: (context, currentValue, child) {
                return FluidSlider(
                  maxValue: 100,
                  minValue: 100,
                  value: currentValue,
                );
              },
            ),
          ),
        ),
      )
    );
  }
}
