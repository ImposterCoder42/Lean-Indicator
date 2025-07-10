import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:active_gauges/models/ride_models.dart';

final rideListProvider =
    StateNotifierProvider<RideListNotifier, List<SingleRide>>((ref) {
      return RideListNotifier();
    });

class RideListNotifier extends StateNotifier<List<SingleRide>> {
  RideListNotifier() : super(Hive.box<SingleRide>('rides').values.toList());

  void addRide(SingleRide ride) {
    final box = Hive.box<SingleRide>('rides');
    box.add(ride);
    state = box.values.toList();
  }

  void deleteRide(int idx) {
    final box = Hive.box<SingleRide>("rides");
    box.deleteAt(idx);
    state = box.values.toList();
  }
}
