import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final spots = [
      FlSpot(DateTime(2023, 11, 20).millisecondsSinceEpoch.toDouble(), 20),
      FlSpot(DateTime(2023, 10, 26).millisecondsSinceEpoch.toDouble(), 18),
      FlSpot(DateTime(2023, 9, 15).millisecondsSinceEpoch.toDouble(), 15),
      FlSpot(DateTime(2023, 8, 30).millisecondsSinceEpoch.toDouble(), 13),
      FlSpot(DateTime(2023, 8, 30).millisecondsSinceEpoch.toDouble(), 13),
      FlSpot(DateTime(2023, 8, 10).millisecondsSinceEpoch.toDouble(), 12),
      FlSpot(DateTime(2023, 8).millisecondsSinceEpoch.toDouble(), 11),
      FlSpot(DateTime(2023, 7, 25).millisecondsSinceEpoch.toDouble(), 12),
      FlSpot(DateTime(2023, 7, 11).millisecondsSinceEpoch.toDouble(), 11),
      FlSpot(DateTime(2023, 3, 25).millisecondsSinceEpoch.toDouble(), 5),
    ];

    final maxY = spots.map((spot) => spot.y).reduce(max);

    final maxX = spots.map((spot) => spot.x).reduce(max).toInt();
    final minX = spots.map((spot) => spot.x).reduce(min).toInt();
    final maxDate = DateTime.fromMillisecondsSinceEpoch(maxX);
    final minDate = DateTime.fromMillisecondsSinceEpoch(minX);

    intl.DateFormat dateFormat;
    if (minDate.daysUntil(maxDate) < 14) {
      dateFormat = intl.DateFormat.E();
    } else if (minDate.daysUntil(maxDate) < 60) {
      dateFormat = intl.DateFormat.MMMd();
    } else if (minDate.daysUntil(maxDate) < 730) {
      dateFormat = intl.DateFormat.MMM();
    } else {
      dateFormat = intl.DateFormat.yMMM();
    }

    const padding = 10.0;
    const titleStyle = TextStyle(fontSize: 14, color: Colors.grey);
    final titleSize = textSize(maxY.toString(), titleStyle);
    final titleHeight = titleSize.height + padding;
    final titleWidth = titleSize.width + padding;

    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 1.7,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 10,
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  getDrawingHorizontalLine: (value) => const FlLine(color: Colors.grey, strokeWidth: 1),
                  drawVerticalLine: false,
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    // axisNameSize: titleWidth,
                    sideTitles: SideTitles(
                      // reservedSize: titleWidth,
                      getTitlesWidget: (value, _) => Padding(
                        padding: const EdgeInsets.only(right: padding),
                        child: Text("${value.toInt()}", maxLines: 1, style: titleStyle),
                      ),
                      showTitles: true,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    // axisNameSize: titleHeight,
                    sideTitles: SideTitles(
                      // reservedSize: titleHeight,
                      getTitlesWidget: (value, meta) {
                        if (value == meta.max || value == meta.min) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: padding),
                          child: Text(
                            dateFormat.format(DateTime.fromMillisecondsSinceEpoch(value.toInt())),
                            style: titleStyle,
                          ),
                        );
                      },
                      showTitles: true,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    color: Colors.orange,
                    isCurved: true,
                    dotData: FlDotData(
                      getDotPainter: (p0, p1, p2, p3) {
                        return FlDotCirclePainter(
                          color: Colors.orange,
                          radius: 4.0,
                          strokeWidth: 0,
                          strokeColor: Colors.orange,
                        );
                      },
                    ),
                    spots: spots,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  /// Returns the difference in days between [this] at midnight and [date] at midnight.
  int daysUntil(DateTime date) {
    final fromAtMidnight = DateTime(year, month, day);
    final toAtMidnight = DateTime(date.year, date.month, date.day);
    return (toAtMidnight.difference(fromAtMidnight).inHours / 24).round();
  }
}

Size textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)..layout();
  return textPainter.size;
}
