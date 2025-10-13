import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isky_new/database/sqfliteDatabase.dart';
import 'package:isky_new/models/statistics.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<FlSpot> spots = [];
  List<String> dateLabels = [];
  List<Statistics> stats = [];
  bool _isLoading = true;
  void loadData() async {
    await Future.delayed(Duration(seconds: 1));
    final db = SQLiteDatabase.instance;
    final List<Statistics> stats = await db.getStatistics(3);
    final generatedSpots = stats.asMap().entries.map((entry) {
      final index = entry.key.toDouble(); // индекс = X
      final stat = entry.value;
      final value = stat.wordsLearnedToday?.toDouble() ?? 0; // любое поле для Y
      return FlSpot(index, value);
    }).toList();
    final generatedLabels = stats.map((stat) {
      final date = DateTime.parse(stat.createdAt!);
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      return '$day.$month';
    }).toList();
    setState(() {
      spots = generatedSpots;
      dateLabels = generatedLabels;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Тест')),
      body: Column(
        children: [
          SizedBox(
            height: 175,
            child: _isLoading == false
                ? Padding(
                    padding: EdgeInsets.only(top: 45, right: 20, left: 20),
                    child: LineChart(
                      LineChartData(
                        titlesData: FlTitlesData(
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index < 0 || index >= dateLabels.length)
                                  return const SizedBox();
                                return Text(
                                  dateLabels[index],
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: false, // сглаживание
                            color: Colors.orange,
                            barWidth: 3,
                            dotData: FlDotData(show: true), // скрыть точки
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((spot) {
                                return LineTooltipItem(
                                  '${spot.y.toInt()}',
                                  const TextStyle(
                                    color: Colors.orange,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
