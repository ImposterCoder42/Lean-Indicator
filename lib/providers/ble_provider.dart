import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../utils/data_processors.dart';

final bleProvider = StateNotifierProvider<BleController, BleState>(
  (ref) => BleController(),
);

class BleState {
  final BluetoothDevice? connectedDevice;
  final bool isConnected;
  final double? leanAngle;

  BleState({this.connectedDevice, this.isConnected = false, this.leanAngle});

  BleState copyWith({
    BluetoothDevice? connectedDevice,
    bool? isConnected,
    double? leanAngle,
  }) {
    return BleState(
      connectedDevice: connectedDevice ?? this.connectedDevice,
      isConnected: isConnected ?? this.isConnected,
      leanAngle: leanAngle ?? this.leanAngle,
    );
  }
}

class BleController extends StateNotifier<BleState> {
  BleController() : super(BleState()) {
    _leanProcessor = LeanAngleProcessor();
  }

  final serviceUuid = Guid("4fafc201-1fb5-459e-8fcc-c5c9c331914b");
  final charUuid = Guid("beb5483e-36e1-4688-b7f5-ea07361b26a8");

  StreamSubscription<List<int>>? _bleDataSub;
  StreamSubscription<BluetoothConnectionState>? _deviceStateSub;

  late LeanAngleProcessor _leanProcessor;

  Future<void> startScanAndConnect() async {
    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult result in results) {
        if (result.advertisementData.advName == "Active-Gauges") {
          await FlutterBluePlus.stopScan();
          try {
            await result.device.connect();
            _deviceStateSub = result.device.connectionState.listen((state) {
              state = state;
            });

            state = state.copyWith(
              connectedDevice: result.device,
              isConnected: true,
            );

            await _discoverServices(result.device);
          } catch (e) {
            print("BLE connect error: $e");
          }
          break;
        }
      }
    });

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
  }

  Future<void> _discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      if (service.uuid == serviceUuid) {
        for (BluetoothCharacteristic c in service.characteristics) {
          if (c.uuid == charUuid) {
            await c.setNotifyValue(true);
            _bleDataSub = c.onValueReceived.listen(_onDataReceived);
          }
        }
      }
    }
  }

  void _onDataReceived(List<int> value) {
    if (value.length >= 2) {
      final byteData = ByteData.sublistView(Uint8List.fromList(value));
      final angle = byteData.getInt16(0, Endian.little);
      print(angle);
      final cleanAngle = _leanProcessor.process(angle.toDouble());
      if (!mounted) return;
      state = state.copyWith(leanAngle: cleanAngle);
    }
  }

  Future<void> disconnect() async {
    if (state.connectedDevice != null) {
      await state.connectedDevice!.disconnect();
    }
    _bleDataSub?.cancel();
    _deviceStateSub?.cancel();
    state = BleState(); // reset state
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
