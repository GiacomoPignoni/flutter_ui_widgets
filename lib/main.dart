import 'package:flutter/material.dart';
import 'package:flutter_ui_widgets/home_screen.dart';
import 'package:flutter_ui_widgets/routes.dart';
import 'package:flutter_ui_widgets/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter UI Widgets',
      theme: theme,
      routes: routes,
      initialRoute: HomeScreen.path,
    );
  }
}
