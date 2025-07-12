import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

const Color linePrimaryColor = Color.fromARGB(255, 163, 39, 31);
const Color lineSecondaryColor = Color.fromARGB(255, 47, 105, 11);

// Add a new data line to chart
LineChartBarData addDataLine(List<FlSpot> data, Color color) {
  return LineChartBarData(
    spots: data,
    isCurved: true,
    barWidth: 3,
    color: color,
    dotData: FlDotData(show: true),
  );
}

// Darkern horzontal 0 line
FlLine buildHorizontalZeroDegreeLine(double value) {
  if (value == 0) {
    return FlLine(color: Colors.black, strokeWidth: 2);
  } else {
    return FlLine(
      color: Colors.grey.withValues(alpha: 0.3),
      strokeWidth: 1,
      dashArray: [5, 5],
    );
  }
}

// Tooltip for speed and angle
List<LineTooltipItem> buildRideTooltipItem(List<LineBarSpot> touchedSpots) {
  return touchedSpots.map((spot) {
    final value = spot.y;
    final barIndex = spot.barIndex;
    String label;

    if (barIndex == 0) {
      // Lean angle line
      if (value > 0) {
        label = 'right lean: ${value.toStringAsFixed(1)}°';
      } else if (value < 0) {
        label = 'left lean: ${value.abs().toStringAsFixed(1)}°';
      } else {
        label = 'upright';
      }
    } else if (barIndex == 1) {
      // Speed line
      label = 'speed: ${value.toStringAsFixed(1)} mph';
    } else {
      label = value.toStringAsFixed(1);
    }

    return LineTooltipItem(
      label,
      const TextStyle(color: Colors.white, fontSize: 20),
    );
  }).toList();
}
