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
  List<Statistics> _stats = [];
  bool _isLoading = true;

  

  Future<void> _loadStatistics() async {
  final db = SQLiteDatabase.instance;
  final stats = await db.getStatistics(widget.selectedFolderId);


  setState(() {
    _stats = stats;
    _isLoading = false;
  });
}

@override
void initState() {
  super.initState();
  _loadStatistics();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.statisticsPage),
      ),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}
