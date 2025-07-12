import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:active_gauges/utils/chart_utils.dart';
import 'package:active_gauges/models/ride_models.dart';
import 'package:active_gauges/providers/ride_provider.dart';

class RideDetailsChart extends ConsumerStatefulWidget {
  const RideDetailsChart({super.key, required this.rideIdx});

  final int rideIdx;

  @override
  ConsumerState<RideDetailsChart> createState() => _RideDetailsChartState();
}

class _RideDetailsChartState extends ConsumerState<RideDetailsChart> {
  final ScrollController _scrollController = ScrollController();
  SingleRide? ride;
  int currentStartIdx = 0;
  final int batchSize = 1000;
  final bool isChartAngleAndSpeed = true;
  List<RideDataPoint> currentDataPoints = [];

  void _getSelectedRideData(int start, int length) {
    final points = ride!.rideData;
    int end = start + length;
    if (end > points.length) end = points.length;
    currentDataPoints.clear();
    currentDataPoints = points.sublist(start, end);
  }

  @override
  void initState() {
    super.initState();
    ride = ref.read(rideListProvider)[widget.rideIdx];
    _getSelectedRideData(currentStartIdx, batchSize);

    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      // Load Next Batch
      if (currentScroll >= maxScroll - 100) {
        int nextStartIdx = currentStartIdx + batchSize;
        if (nextStartIdx < ride!.rideData.length) {
          setState(() {
            currentStartIdx = nextStartIdx;
            _getSelectedRideData(currentStartIdx, batchSize);
          });
        } else if (currentStartIdx < ride!.rideData.length - 1) {
          setState(() {
            currentStartIdx = ride!.rideData.length - batchSize;
            if (currentStartIdx < 0) currentStartIdx = 0;
            _getSelectedRideData(currentStartIdx, batchSize);
          });
        }
      }
      // Load Previous Batch
      if (currentScroll <= 100 && currentStartIdx > 0) {
        int prevStartIdx = currentStartIdx - batchSize;
        if (prevStartIdx < 0) prevStartIdx = 0;
        setState(() {
          currentStartIdx = prevStartIdx;
          _getSelectedRideData(currentStartIdx, batchSize);
        });
      }
    });
  }

  List<FlSpot> generateRideSpots(
    List<RideDataPoint> points,
    double Function(RideDataPoint) selector,
  ) {
    return List.generate(
      points.length,
      (index) => FlSpot(index.toDouble(), selector(points[index])),
    );
  }

  @override
  Widget build(BuildContext context) {
    ride = ref.watch(rideListProvider)[widget.rideIdx];
    _getSelectedRideData(currentStartIdx, batchSize);

    final angleLineData = generateRideSpots(
      currentDataPoints,
      (dp) => dp.angle,
    );
    final speedLineData = generateRideSpots(
      currentDataPoints,
      (dp) => dp.speed,
    );

    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(.8),
          child: SizedBox(
            height: 300,
            width: angleLineData.length.toDouble() * 20,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        fitInsideHorizontally: true,
                        fitInsideVertically: true,
                        tooltipMargin: 12,
                        getTooltipItems: buildRideTooltipItem,
                      ),
                    ),
                    lineBarsData: [
                      addDataLine(angleLineData, linePrimaryColor),
                      addDataLine(speedLineData, lineSecondaryColor),
                    ],
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      getDrawingHorizontalLine: buildHorizontalZeroDegreeLine,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
