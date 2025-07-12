import 'package:flutter/material.dart';

import 'package:active_gauges/themes/shared_decorations.dart';
import 'package:active_gauges/screens/ride_record_page.dart';
import 'package:active_gauges/screens/ride_history_page.dart';
import 'package:active_gauges/screens/gauge_style_page.dart';
import 'package:active_gauges/screens/gauge_reset_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _changePage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 75),
            child: ListView(
              children: [
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () => _changePage(context, RideRecordPage()),
                  icon: Icon(Icons.motorcycle),
                  style: ButtonStyle(iconAlignment: IconAlignment.end),
                  label: Text("new ride"),
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () => _changePage(context, RideHistoryPage()),
                  icon: Icon(Icons.history),
                  style: ButtonStyle(iconAlignment: IconAlignment.end),
                  label: Text("ride list"),
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () => _changePage(context, GaugeStylePage()),
                  icon: Icon(Icons.settings),
                  style: ButtonStyle(iconAlignment: IconAlignment.end),
                  label: Text("gauge settings"),
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () => _changePage(context, GaugeResetPage()),
                  icon: Icon(Icons.reset_tv_rounded),
                  style: ButtonStyle(iconAlignment: IconAlignment.end),
                  label: Text("reset otions"),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
