import 'package:flutter/material.dart';

BoxDecoration appGradientBackground({required bool isDark}) {
  return BoxDecoration(
    gradient: isDark
        ? const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.black, Color.fromARGB(255, 26, 10, 51)],
          )
        : const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.white, Colors.blueGrey],
          ),
  );
}
