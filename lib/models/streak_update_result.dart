class StreakUpdateResult {
  final bool success;
  final String? message;
  final int streak;

  StreakUpdateResult.success({
    this.message,
    required this.streak
  }): success = true;

  StreakUpdateResult.failure({
    required this.message,
  }): success = false,
      streak = 0;
}