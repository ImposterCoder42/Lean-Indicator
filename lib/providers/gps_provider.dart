import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GpsState {
  final double speed;
  final String speedUnit;

  const GpsState({this.speed = 0, this.speedUnit = 'mph'});
}

class GpsNotifier extends StateNotifier<GpsState> {
  StreamSubscription<Position>? _subscription;

  GpsNotifier() : super(const GpsState());

  void startTracking() {
    if (_subscription != null) return;

    _subscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
          ),
        ).listen((position) {
          final speedMps = position.speed;
          final convertedSpeed = state.speedUnit == 'mph'
              ? speedMps * 2.237
              : speedMps * 3.6;

          state = GpsState(
            speed: convertedSpeed.roundToDouble(),
            speedUnit: state.speedUnit,
          );
        });
  }

  void switchUnit(String unit) {
    if (unit != 'mph' && unit != 'kph') return;
    state = GpsState(speed: state.speed, speedUnit: unit);
  }

  void stopTracking() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}

final gpsProvider = StateNotifierProvider<GpsNotifier, GpsState>(
  (ref) => GpsNotifier(),
);
