import 'dart:async';
import 'package:active_gauges/providers/ble_provider.dart';
import 'package:active_gauges/screens/ride_history_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:active_gauges/models/ride_models.dart';
import 'package:active_gauges/providers/ride_provider.dart';
import 'package:active_gauges/providers/gps_provider.dart';
import 'package:active_gauges/themes/shared_decorations.dart';

class RideRecordPage extends ConsumerStatefulWidget {
  const RideRecordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RideRecordPageState();
}

class _RideRecordPageState extends ConsumerState<RideRecordPage> {
  bool _isDesiredSpeedOutputMPH = true;
  bool _isRecording = false;
  SingleRide? _newRide;

  @override
  void initState() {
    super.initState();
    final ble = ref.read(bleProvider);
    if (ble.connectedDevice == null || !ble.isConnected) {
      ref.read(bleProvider.notifier).startScanAndConnect();
    }
    ref.read(gpsProvider.notifier).startTracking();
  }

  // ==============
  // FOR RECORDING
  // ==============
  // Button Controls
  void _startRecording() {
    setState(() {
      _newRide = SingleRide(title: "title", rideData: []);
      _isRecording = true;
    });
  }

  void _stopRecording() async {
    setState(() => _isRecording = false);
    await _loadTitleDialogAndSave();
    _loadSaveSuccessSnackbar();
  }

  Future<void> _loadTitleDialogAndSave() async {
    String defaultTitle =
        "Ride on ${DateFormat.yMMMd().add_jm().format(DateTime.now())}";
    final rideName = await showRideNameDialog(context, defaultTitle);
    if (rideName == null) return; // user cancelled
    final upperTitle = rideName.toUpperCase();

    _newRide!.updateTitle(upperTitle);
    ref.read(rideListProvider.notifier).addRide(_newRide!);
  }

  // Pop Up Dialogs
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

  void _loadSaveSuccessSnackbar() {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("RIDE SAVED!")));
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (ctx) => RideHistoryPage()));
      }
    });
  }

  @override
  void dispose() {
    ref.read(gpsProvider.notifier).stopTracking();
    super.dispose();
  }

  // ==============
  // ACTUAL WIDGET
  // ==============
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final gps = ref.watch(gpsProvider);

    final ble = ref.watch(bleProvider);
    double? lean = ble.leanAngle;
    double? bikeSpeed = gps.speed;

    if (_isRecording && lean != null) {
      final RideDataPoint data = RideDataPoint(angle: lean, speed: bikeSpeed);
      _newRide!.addDataPoint(data);
    }

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
              Text("units for speed:"),
              ElevatedButton(
                onPressed: () {
                  _isDesiredSpeedOutputMPH
                      ? ref.read(gpsProvider.notifier).switchUnit('kph')
                      : ref.read(gpsProvider.notifier).switchUnit('mph');
                  _isDesiredSpeedOutputMPH = !_isDesiredSpeedOutputMPH;
                },
                child: _isDesiredSpeedOutputMPH ? Text('KPH') : Text("MPH"),
              ),
              ElevatedButton.icon(
                icon: Icon(_isRecording ? Icons.save : Icons.timer),
                onPressed: _isRecording ? _stopRecording : _startRecording,
                label: Text(_isRecording ? 'save' : 'record'),
              ),
              Column(
                children: [
                  if (_isRecording) Text("current angle: $lean"),
                  if (_isRecording) Text("current speed: $bikeSpeed"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
