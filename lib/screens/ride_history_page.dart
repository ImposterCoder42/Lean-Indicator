import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:active_gauges/models/ride_models.dart';
import 'package:active_gauges/providers/ride_provider.dart';
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
              title: Text(ride.title),
              subtitle: Text('${ride.rideData.length} data points'),
            );
          },
        ),
      ),
    );
  }
}
