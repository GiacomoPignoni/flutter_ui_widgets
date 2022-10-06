import 'package:flutter_ui_widgets/home_screen.dart';
import 'package:flutter_ui_widgets/widgets/cupertino_style_segmented_selector/cupertino_style_segmented_selector_screen.dart';
import 'package:flutter_ui_widgets/widgets/fluid_slider/fluid_slider_screen.dart';
import 'package:flutter_ui_widgets/widgets/line_segmented_selector/line_segmented_selector_screen.dart';
import 'package:flutter_ui_widgets/widgets/minimalist_switch/minimalist_switch_screen.dart';
import 'package:flutter_ui_widgets/widgets/pop_switch/pop_switch_screen.dart';

final routes = {
  HomeScreen.path: (_) => const HomeScreen(),
  LineSegmentedSelectorScreen.path: (_) => const LineSegmentedSelectorScreen(),
  MinimalistSwitchScreen.path: (_) => const MinimalistSwitchScreen(),
  PopSwitchScreen.path: (_) => const PopSwitchScreen(),
  FluidSliderScreen.path: (_) => const FluidSliderScreen(),
  CupertioStyleSegmentedSelectorScreen.path: (_) => const CupertioStyleSegmentedSelectorScreen()
};
