import 'package:flutter/material.dart';

import 'package:active_gauges/themes/shared_decorations.dart';

class RideDetailsPage extends StatelessWidget {
  const RideDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: appGradientBackground(isDark: isDark),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(80, 111, 111, 111),
          title: Text("RIDE TITLE HERE"),
        ),
        body: Text("comming soon..."),
      ),
    );
  }
}
