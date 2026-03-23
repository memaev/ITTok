class AppConstants {
  AppConstants._();

  static const String appName = 'ITiktok';
  static const String tagline = 'TikTok for IT';

  // Feed
  static const int feedPreloadPages = 1;
  static const Duration cardAnimationDuration = Duration(milliseconds: 300);
  static const Duration interactionAnimationDuration = Duration(milliseconds: 200);

  // Daily goal
  static const int defaultDailyGoal = 10;

  // Streak
  static const String streakKey = 'streak_count';
  static const String lastLearnDateKey = 'last_learn_date';
  static const String cardsLearnedKey = 'cards_learned_total';
  static const String dailyCardsKey = 'daily_cards_count';
}
