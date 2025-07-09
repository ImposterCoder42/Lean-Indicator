import 'package:flutter/material.dart';

import 'package:active_gauges/themes/shared_decorations.dart';

class RideRecordPage extends StatelessWidget {
  const RideRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: appGradientBackground(isDark: isDark),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(80, 111, 111, 111),
          title: Text("RECORD RIDE"),
        ),
        body: Text("comming soon..."),
      ),
    );
  }
}
