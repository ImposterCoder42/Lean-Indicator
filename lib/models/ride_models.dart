import 'package:uuid/uuid.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'ride_models.g.dart';

const uuid = Uuid();

@HiveType(typeId: 0)
class RideDataPoint extends HiveObject {
  RideDataPoint({required this.angle, required this.speed});

  @HiveField(0)
  final double angle;
  @HiveField(1)
  final double speed;
}

@HiveType(typeId: 1)
class SingleRide extends HiveObject {
  SingleRide({required this.title, required this.rideData})
    : id = uuid.v4(),
      date = DateTime.now();

  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  String title;
  @HiveField(3)
  final List<RideDataPoint> rideData;

  void addDataPoint(RideDataPoint data) {
    rideData.add(RideDataPoint(angle: data.angle, speed: data.speed));
  }

  void updateTitle(String title) {
    this.title = title;
  }
}
