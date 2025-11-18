import 'package:flutter/material.dart';
import 'package:iskai/l10n/app_localizations.dart';

class IncompletePage extends StatefulWidget{
  const IncompletePage({super.key});

  @override
  State<IncompletePage> createState() => _IncompletePageState();
}

class _IncompletePageState extends State<IncompletePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.incompletePage),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.stillInDevelopment, style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16
            ),)
          ],
        ),
      ),
    );
  }
}