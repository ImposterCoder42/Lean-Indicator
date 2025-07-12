import 'package:flutter/material.dart';

class GaugeSettingsModel {
  Color backgroundNormalColor;
  Color backgroundWarningColor;
  Color arcMainColor;
  Color arcIndicatorColor;
  Color fontColor;
  String currentFont;
  String currentBike;
  double maxiumSafeAngle;

  GaugeSettingsModel({
    required this.backgroundNormalColor,
    required this.backgroundWarningColor,
    required this.arcMainColor,
    required this.arcIndicatorColor,
    required this.fontColor,
    required this.currentFont,
    required this.currentBike,
    required this.maxiumSafeAngle,
  });

  void printSettings() {
    print(backgroundNormalColor);
    print(backgroundWarningColor);
    print(arcMainColor);
    print(arcIndicatorColor);
    print(fontColor);
    print(currentFont);
    print(currentBike);
    print(maxiumSafeAngle);
  }
}

const preLoadedFonts = ["marty", "arial", "script", "text 4", "text 5"];
const preLoadedBikes = [
  "21 INDIAN SCOUT",
  "RED-BLUE SPORT",
  "GREEN SPORT",
  "BLUE SPORT",
  "RED BAGGER",
];
