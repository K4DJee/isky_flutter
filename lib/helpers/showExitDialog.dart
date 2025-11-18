import 'package:flutter/material.dart';
import 'package:iskai/l10n/app_localizations.dart';

Future<bool> showExitDialog(BuildContext context)async{
  return await showDialog(context: context, builder: (context)=>AlertDialog(
    title:Text(AppLocalizations.of(context)!.showExitDialogTitle, style: TextStyle(fontSize: 16),),
    actions: [
      TextButton(
      onPressed: (){
        Navigator.pop(context, false);
      },
      child: Text(AppLocalizations.of(context)!.noAction)
      ),
      TextButton(
      onPressed: (){
        Navigator.pop(context, true);
      },
      child: Text(AppLocalizations.of(context)!.yesAction)
      ),
    ],
  )) ?? false;//if dialog closed without user choice
}