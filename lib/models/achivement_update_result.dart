class AchievementUpdateResult {
  final bool success;
  final bool unlocked;
  final String? message;
  final Object? error;

  AchievementUpdateResult.success({
    required this.unlocked,
    this.message = 'Прогресс обновлён',
  })  : success = true,
        error = null;

  AchievementUpdateResult.failure({
    this.message = 'Ошибка обновления',
    this.error,
  })  : success = false,
        unlocked = false;
}