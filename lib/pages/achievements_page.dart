import 'package:flutter/material.dart';
import 'package:iskai/l10n/app_localizations.dart';

class AchievementsPage extends StatefulWidget{
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}


class _AchievementsPageState extends State<AchievementsPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.achievementsPage),
      ),
    );
  }
}