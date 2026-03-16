import 'dart:async';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
//import 'package:window_manager/window_manager.dart';

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}
class LineChartSample10 extends StatefulWidget {
  const LineChartSample10({
      super.key,
      this.lineColor = AppColors.contentColorBlue,
      this.func = defaultFunc,
  });

  final Color lineColor;
  final double Function(double) func;
  static double defaultFunc(double x) => 0;

  @override
  State<LineChartSample10> createState() => _LineChartSample10State();
}

class _LineChartSample10State extends State<LineChartSample10> {
  final limitCount = 100;
  var leftPoints = <FlSpot>[];
  var rightPoints = <FlSpot>[];

  double xValue = 0;
  double step = 0.05;
  int index = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        if (index == 0) {
          var temp = leftPoints;
          leftPoints = rightPoints;
          rightPoints = temp;
        }
        
        leftPoints.add(FlSpot(index * step, widget.func(xValue)));
        if (rightPoints.isNotEmpty) {
          rightPoints.removeAt(0);
        }
      });
      index = (index + 1) % limitCount;
      xValue += step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return leftPoints.isNotEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 4,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: LineChart(
                    LineChartData(
                      minY: -1.1,
                      maxY: 1.1,
                      minX: 0,
                      maxX: (limitCount - 1) * step,
                      lineTouchData: const LineTouchData(enabled: false),
                      clipData: const FlClipData.all(),
                      gridData: const FlGridData(
                        show: true,
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        line(leftPoints),
                        line(rightPoints),
                      ],
                      titlesData: const FlTitlesData(
                        show: false,
                      ),
                    ),
                    duration: Duration(),
                  ),
                ),
              )
            ],
          )
        : Container();
  }

  LineChartBarData line(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: const FlDotData(
        show: false,
      ),
      barWidth: 4,
      isCurved: false,
      color: widget.lineColor,
    );
  }


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await windowManager.ensureInitialized();
  //WindowManager.instance.setFullScreen(true);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static double _sin(double x) => math.sin(x);
  static double _cos(double x) => math.cos(5 * x);
  static double _saw(double x) => x % 2 - 1;
  static double _sqr(double x) => (x % 2 < 1) ? 1 : -1;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: LineChartSample10(lineColor: AppColors.contentColorBlue,   func: _sin,)),
              Expanded(child: LineChartSample10(lineColor: AppColors.contentColorCyan,   func: _cos,)),
              Expanded(child: LineChartSample10(lineColor: AppColors.contentColorGreen,  func: _saw,)),
              Expanded(child: LineChartSample10(lineColor: AppColors.contentColorOrange, func: _sqr,)),
            ],
          ),
        ),
      ),
    );
  }
}
