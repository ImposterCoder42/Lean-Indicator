import 'package:hive_flutter/adapters.dart';

import 'package:active_gauges/models/ride_models.dart';

class RideStorageUtils {
  static const String _boxName = 'rides';

  static Future<void> saveRide(SingleRide ride) async {
    final box = Hive.box<SingleRide>(_boxName);
    await box.add(ride);
  }

  static List<SingleRide> getAllRides() {
    final box = Hive.box<SingleRide>(_boxName);
    return box.values.toList();
  }

  static Future<void> deleteRideAt(int index) async {
    final box = Hive.box<SingleRide>(_boxName);
    await box.deleteAt(index);
  }

  static int getRideCount() {
    final box = Hive.box<SingleRide>(_boxName);
    return box.length;
  }
}
