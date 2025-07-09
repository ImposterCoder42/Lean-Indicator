import 'package:flutter/material.dart';

import 'package:active_gauges/themes/shared_decorations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void changePage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => page));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: appGradientBackground(isDark: isDark),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(80, 111, 111, 111),
          title: Text("ACTIVE GAUGES"),
        ),
        body: Text("HELP"),
      ),
    );
  }
}
