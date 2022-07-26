import 'package:flutter/material.dart';
import 'package:flutter_ui_widgets/widgets/line_segmented_selector/line_segmented_selector_screen.dart';

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
            child: Center(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shrinkWrap: true,
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                ), 
                itemBuilder: (context, index) {
                  return HomePageItem(
                    model: items[index]
                  );
                }
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  model.icon,
                  size: 50,
                ),
                const SizedBox(height: 20),
                Text(
                  model.title,
                  style: theme.textTheme.headline3,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
