import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:active_gauges/providers/ride_provider.dart';
import 'package:active_gauges/screens/ride_details_page.dart';
import 'package:active_gauges/themes/shared_decorations.dart';

class RideHistoryPage extends ConsumerWidget {
  const RideHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rides = ref.watch(rideListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: appGradientBackground(isDark: isDark),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(80, 111, 111, 111),
          title: Text("RIDE LIST"),
        ),
        body: ListView.builder(
          itemCount: rides.length,
          itemBuilder: (context, index) {
            final ride = rides[index];
            return ListTile(
              title: Text(DateFormat.yMMMMd().format(ride.date).toLowerCase()),
              subtitle: Text(ride.title),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RideDetailsPage(rideIdx: index),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
