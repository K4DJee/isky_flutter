import 'package:isky_new/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

String formatDayEnding(int days, BuildContext context) {
  final loc = AppLocalizations.of(context)!;

  if (days < 0) days = -days;
  int r100 = days % 100;
  if (r100 >= 11 && r100 <= 14) {
    return ' ${loc.days}';
  }

  switch (days % 10) {
    case 1: return ' ${loc.day}';
    case 2:
    case 3:
    case 4: return ' ${loc.daysGenitive}';
    default: return ' ${loc.days}';
  }
}