class Routes {
  Routes._();

  static const String home = '/';
  static const String explore = '/explore';
  static const String topicFeed = '/explore/topic/:topicId';
  static const String saved = '/saved';
  static const String profile = '/profile';

  static String topicFeedPath(String topicId) => '/explore/topic/$topicId';
}
