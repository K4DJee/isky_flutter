import 'package:flutter/material.dart';
import 'package:iskai/database/sqfliteDatabase.dart';
import 'package:iskai/helpers/localizations_extension.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/models/achievement.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final SQLiteDatabase _sqfliteDatabase = SQLiteDatabase.instance;
  List<Achievement> achievements = [];
  Future getAllAchievements() async {
    try {
      achievements = await _sqfliteDatabase.getAllAchievements();
      setState(() {
        achievements;
      });
    } catch (e) {
      print('Ошибка: e');
    }
  }

  @override
  void initState() {
    super.initState();
    getAllAchievements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.achievementsPage),
      ),
      body: achievements.isNotEmpty
          ? ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 16),
              padding: EdgeInsets.all(10),
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                return achievementContainer(context, achievements[index]);
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

Widget achievementContainer(BuildContext context, achievement) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      color: Theme.of(context).cardColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: const Offset(0, 2),
          blurRadius: 4.0,
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.achievementName(achievement.id),
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  AppLocalizations.of(context)!.achievementDescription(achievement.id),
                  style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                ),

                if (achievement.unlocked == true)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.unlockedStatus, style: TextStyle(color: Colors.green)),
                        SizedBox(width: 4),
                        Icon(Icons.check, color: Colors.green),//Colors.orange
                      ],
                    ),
                  ),
                if (achievement.goal > 0) ...[
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: achievement.progress / achievement.goal,
                    backgroundColor: Colors.grey[500],
                    valueColor: AlwaysStoppedAnimation(Colors.green),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  SizedBox(height: 4),
                Text(
                  '${achievement.progress} / ${achievement.goal}',
                  style: TextStyle(),
                ),
                ],
              ],
            ),
          ),
          SizedBox(width: 16),
          Image.asset(
            achievement.icon,
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
        ],
      ),
    ),
  );
}
