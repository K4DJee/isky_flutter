import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isky_new/database/sqfliteDatabase.dart';
import 'package:isky_new/l10n/app_localizations.dart';
import 'package:isky_new/models/statistics.dart';

class StatisticsPage extends StatefulWidget {
  final int selectedFolderId;
  const StatisticsPage({super.key, required this.selectedFolderId});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<FlSpot> spots = [];
  List<String> dateLabels = [];
  List<Statistics> stats = [];
  int allWordsLearned = 0;
  double averageAnswersPerDay = 0;
  int allCorrectWords = 0;
  int allIncorrectWords = 0;
  int allAnswers = 0;

  bool _isLoading = true;
  void loadData() async {
    final db = SQLiteDatabase.instance;
    final List<Statistics> stats = await db.getStatistics(widget.selectedFolderId);
    final generatedSpots = stats.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final stat = entry.value;
      final value = stat.wordsLearnedToday?.toDouble() ?? 0;
      return FlSpot(index, value);
    }).toList();
    final generatedLabels = stats.map((stat) {
      final date = DateTime.parse(stat.createdAt!);
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      return '$day.$month';
    }).toList();
    setState(() {
      allWordsLearned = stats
          .map((stat) => stat.wordsLearnedToday!)
          .reduce((value, element) => value + element);
      allAnswers = stats
          .map((stat) => stat.amountAnswersPerDay!)
          .reduce((value, element) => value + element);
      allCorrectWords = stats
          .map((stat) => stat.amountCorrectAnswers!)
          .reduce((value, element) => value + element);
      allIncorrectWords = stats
          .map((stat) => stat.amountIncorrectAnswers!)
          .reduce((value, element) => value + element);
      averageAnswersPerDay = stats.isNotEmpty ? allAnswers / stats.length : 0;
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
    final chartWidth = spots.length * 80.0;
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.statisticsPage)),
      body: Column(
        children: [
          SizedBox(
            height: 175,
            child: _isLoading == false
                ? SizedBox(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: chartWidth,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 45,
                            right: 20,
                            left: 20,
                          ),
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
                                      if (index < 0 ||
                                          index >= dateLabels.length)
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
                                  isCurved: false,
                                  color: Colors.orange,
                                  barWidth: 3,
                                  dotData: FlDotData(
                                    show: true,
                                  ),
                                ),
                              ],
                              lineTouchData: LineTouchData(
                                touchTooltipData: LineTouchTooltipData(
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots.map((spot) {
                                      return LineTooltipItem(
                                        '${spot.y.toInt()}',
                                        const TextStyle(color: Colors.orange),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(title: Text('${AppLocalizations.of(context)!.wordsLearned} $allWordsLearned')),
                const Divider(height: 1, thickness: 1, color: Colors.grey),
                ListTile(title: Text('${AppLocalizations.of(context)!.totalNumberAnswers} $allAnswers')),
                const Divider(height: 1, thickness: 1, color: Colors.grey),
                ListTile(
                  title: Text(
                    '${AppLocalizations.of(context)!.numberCorrectAnswers} $allCorrectWords',
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Colors.grey),
                ListTile(
                  title: Text(
                    '${AppLocalizations.of(context)!.numberIncorrectAnswers} $allIncorrectWords',
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Colors.grey),
                ListTile(
                  title: Text(
                    '${AppLocalizations.of(context)!.averageNumberTitle} ${averageAnswersPerDay.toStringAsFixed(2)}',
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
