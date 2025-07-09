// import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

// import 'package:hive/hive.dart';
// import 'package:active_gauges/models/ride_models.dart';
import 'package:active_gauges/themes/shared_decorations.dart';

class RideRecordPage extends StatefulWidget {
  const RideRecordPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return RideRecordPageState();
  }
}

class RideRecordPageState extends State<RideRecordPage> {
  // final bool _isRecording = false;
  // SingleRide? _newRide;

  // ==============
  // FOR BLE + GPS
  // ==============

  // ==============
  // FOR RECORDING
  // ==============
  // void _saveNewRide() async {
  //   String defaultTitle =
  //       "Ride on ${DateFormat.yMMMd().add_jm().format(DateTime.now())}";

  //   final rideName = await showRideNameDialog(context, defaultTitle);
  //   if (rideName == null) return; // user cancelled

  //   final upperTitle = rideName.toUpperCase();

  //   _newRide!.updateTitle(upperTitle);
  //   final box = await Hive.openBox<SingleRide>('rides');
  //   await box.add(_newRide!);
  // }

  // Future<String?> showRideNameDialog(BuildContext context, String defaultName) {
  //   final TextEditingController controller = TextEditingController();

  //   return showDialog<String>(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text('SAVE RIDE'),
  //       content: TextField(
  //         controller: controller,
  //         decoration: InputDecoration(
  //           labelText: 'ride name',
  //           hintText: 'tail of the dragon july 2005',
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           child: const Text('CANCEL'),
  //           onPressed: () => Navigator.of(ctx).pop(),
  //         ),
  //         TextButton(
  //           child: const Text('USE DEFAULT TITLE'),
  //           onPressed: () => Navigator.of(ctx).pop(defaultName),
  //         ),
  //         TextButton(
  //           child: const Text('SAVE RIDE'),
  //           onPressed: () {
  //             final name = controller.text.trim();
  //             if (name.isEmpty) {
  //               Navigator.of(ctx).pop(defaultName); // fallback
  //             } else {
  //               Navigator.of(ctx).pop(name);
  //             }
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
        body: Text("comming soon..."),
      ),
    );
  }
}
