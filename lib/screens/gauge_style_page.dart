import 'package:flutter/material.dart';

import 'package:active_gauges/themes/shared_decorations.dart';

class GaugeStylePage extends StatelessWidget {
  const GaugeStylePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: appGradientBackground(isDark: isDark),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(80, 111, 111, 111),
          title: Text("GAUGE SETTINGS"),
        ),
        body: Text("comming soon..."),
      ),
    );
  }
}
