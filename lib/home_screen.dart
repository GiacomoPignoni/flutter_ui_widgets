import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_widgets/widgets/cupertino_style_segmented_selector/cupertino_style_segmented_selector.dart';
import 'package:flutter_ui_widgets/widgets/cupertino_style_segmented_selector/cupertino_style_segmented_selector_screen.dart';
import 'package:flutter_ui_widgets/widgets/fluid_slider/fluid_slider_screen.dart';
import 'package:flutter_ui_widgets/widgets/line_segmented_selector/line_segmented_selector_screen.dart';
import 'package:flutter_ui_widgets/widgets/minimalist_switch/minimalist_switch_screen.dart';
import 'package:flutter_ui_widgets/widgets/pop_switch/pop_switch_screen.dart';

class HomeScreen extends StatefulWidget {
  static const path = "home_screen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<HomePageItemModel> items = [
    HomePageItemModel(
      title: "LineSegmentedSelector",
      path: LineSegmentedSelectorScreen.path,
      icon: Icons.settings_input_component_rounded
    ),
    HomePageItemModel(
      title: "CupertioStyleSegmentedSelector",
      path: CupertioStyleSegmentedSelectorScreen.path,
      icon: Icons.settings_input_component_rounded
    ),
    HomePageItemModel(
      title: "MinimalistSwitch",
      path: MinimalistSwitchScreen.path,
      icon: Icons.toggle_off_rounded
    ),
    HomePageItemModel(
      title: "PopSwitch",
      path: PopSwitchScreen.path,
      icon: Icons.toggle_off_rounded
    ),
    HomePageItemModel(
      title: "FluidSlider",
      path: FluidSliderScreen.path,
      icon: Icons.linear_scale_rounded
    ),
    HomePageItemModel(
      title: "CupertioStyleSegmentedSelector",
      path: FluidSliderScreen.path,
      icon: Icons.settings_input_component_rounded
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Center(
              child: Text(
                "Select a widget to see it on work"
              ),
            ),
          ),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500
              ),
              child: Center(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shrinkWrap: true,
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ), 
                  itemBuilder: (context, index) {
                    return HomePageItem(
                      model: items[index]
                    );
                  }
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePageItemModel {
  final String title;
  final String path;
  final IconData icon;

  HomePageItemModel({
    required this.title,
    required this.path,
    required this.icon
  });
}

class HomePageItem extends StatelessWidget {
  final HomePageItemModel model;

  const HomePageItem({
    required this.model,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(model.path),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  model.icon,
                  size: 30,
                ),
                const SizedBox(height: 20),
                AutoSizeText(
                  model.title,
                  style: theme.textTheme.headline3,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
