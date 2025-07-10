import 'dart:async';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:active_gauges/models/ride_models.dart';
import 'package:active_gauges/utils/data_processors.dart';
import 'package:active_gauges/themes/shared_decorations.dart';

class RideRecordPage extends StatefulWidget {
  const RideRecordPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return RideRecordPageState();
  }
}

class RideRecordPageState extends State<RideRecordPage> {
  final _leanProcessor = LeanAngleProcessor();
  final _gForceLatProcessor = GForceProcessor();
  final _gForceLongProcessor = GForceProcessor();
  final String _desiredSpeedOutput = 'mph';
  bool _isRecording = false;
  double _bikeSpeed = 0.0;
  SingleRide? _newRide;

  final serviceUuid = Guid("4fafc201-1fb5-459e-8fcc-c5c9c331914b");
  final charUuid = Guid("beb5483e-36e1-4688-b7f5-ea07361b26a8");

  StreamSubscription<Position>? _positionSubscription;
  StreamSubscription<List<int>>? _bleDataSubscription;
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<BluetoothConnectionState>? _deviceStateSubscription;

  @override
  void initState() {
    super.initState();
    _connectToGauge();
    _startSpeedTracking();
  }

  // ==============
  // FOR BLE + GPS
  // ==============
  void _startSpeedTracking() {
    _positionSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
          ),
        ).listen((position) {
          if (!mounted) return;
          final speedMps = position.speed;
          final convertedSpeed = _desiredSpeedOutput == "mph"
              ? speedMps * 2.237
              : speedMps * 3.6;
          setState(() {
            _bikeSpeed = convertedSpeed;
          });
        });
  }

  void _connectToGauge() {
    _scanSubscription = FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult result in results) {
        if (result.advertisementData.advName == "Active-Gauges") {
          print('Found Active-Gauges: ${result.device.remoteId}');
          await FlutterBluePlus.stopScan();
          try {
            await result.device.connect();
            // Cancel previous device state subscription if any
            await _deviceStateSubscription?.cancel();

            _deviceStateSubscription = result.device.connectionState.listen((
              state,
            ) {
              if (state == BluetoothConnectionState.disconnected) {
                print("Device disconnected.");
              }
            });

            await _discoverServices(result.device);
          } catch (e) {
            print("Error connecting: $e");
          }
          break;
        }
      }
    });

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    Future.delayed(const Duration(seconds: 12), () {
      FlutterBluePlus.stopScan();
    });
  }

  Future<void> _discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      if (service.uuid == serviceUuid) {
        for (BluetoothCharacteristic c in service.characteristics) {
          if (c.uuid == charUuid) {
            await c.setNotifyValue(true);
            _bleDataSubscription
                ?.cancel(); // cancel previous subscription if any
            _bleDataSubscription = c.onValueReceived.listen((value) {
              if (!mounted) return; // safety check

              if (value.length >= 10) {
                final byteData = ByteData.sublistView(
                  Uint8List.fromList(value),
                );
                final angle = byteData.getInt16(0, Endian.little);
                final accX = byteData.getFloat32(2, Endian.little);
                final accY = byteData.getFloat32(6, Endian.little);

                final cleanAngle = _leanProcessor.process(angle.toDouble());
                final cleanGLat = _gForceLatProcessor.process(accX);
                final cleanGLong = _gForceLongProcessor.process(accY);

                setState(() {
                  RideDataPoint data = RideDataPoint(
                    angle: cleanAngle,
                    speed: _bikeSpeed,
                    gForceLat: cleanGLat,
                    gForceLong: cleanGLong,
                  );
                  if (_isRecording) _newRide!.addDataPoint(data);
                });
              }
            });
          }
        }
      }
    }
  }

  // ==============
  // FOR RECORDING
  // ==============
  void _startRecording() {
    setState(() {
      _newRide = SingleRide(title: "title", rideData: []);
      _isRecording = true;
    });
  }

  void _stopRecording() async {
    setState(() => _isRecording = false);
    _saveNewRide();

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("RIDE SAVED!")));
    }
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => RideRecordPage()));
  }

  @override
  void dispose() {
    _bleDataSubscription?.cancel();
    _positionSubscription?.cancel();
    _scanSubscription?.cancel();
    _deviceStateSubscription?.cancel();
    super.dispose();
  }

  void _saveNewRide() async {
    String defaultTitle =
        "Ride on ${DateFormat.yMMMd().add_jm().format(DateTime.now())}";
    final rideName = await showRideNameDialog(context, defaultTitle);
    if (rideName == null) return; // user cancelled
    final upperTitle = rideName.toUpperCase();

    _newRide!.updateTitle(upperTitle);
    final box = await Hive.openBox<SingleRide>('rides');
    await box.add(_newRide!);
  }

  Future<String?> showRideNameDialog(BuildContext context, String defaultName) {
    final TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('SAVE RIDE'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'ride name',
            hintText: 'tail of the dragon july 2005',
          ),
        ),
        actions: [
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('USE DEFAULT TITLE'),
            onPressed: () => Navigator.of(ctx).pop(defaultName),
          ),
          TextButton(
            child: const Text('SAVE RIDE'),
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) {
                Navigator.of(ctx).pop(defaultName); // fallback
              } else {
                Navigator.of(ctx).pop(name);
              }
            },
          ),
        ],
      ),
    );
  }

  // ==============
  // ACTUAL WIDGET
  // ==============
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 75),
          child: ListView(
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _isRecording
                      ? ElevatedButton.icon(
                          icon: Icon(Icons.timer),
                          onPressed: _startRecording,
                          label: Text('record'),
                        )
                      : ElevatedButton.icon(
                          icon: Icon(Icons.save),
                          onPressed: _stopRecording,
                          label: Text('save'),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
