enum GroupMemberRole {
  admin('admin'),
  member('member');

  const GroupMemberRole(this.value);

  final String value;
}

enum GroupCategory {
  food('Food & Restaurants', '🍽️'),
  movies('Movies & TV Shows', '🎬'),
  books('Books & Literature', '📚'),
  music('Music & Albums', '🎵'),
  games('Games & Apps', '🎮'),
  travel('Travel & Places', '✈️'),
  products('Products & Shopping', '🛍️'),
  events('Events & Activities', '🎉'),
  sports('Sports & Fitness', '⚽'),
  technology('Technology & Gadgets', '💻'),
  fashion('Fashion & Style', '👗'),
  beauty('Beauty & Health', '💄'),
  education('Education & Courses', '📖'),
  business('Business & Services', '💼'),
  art('Art & Design', '🎨'),
  photography('Photography', '📸'),
  home('Home & Garden', '🏠'),
  automotive('Automotive', '🚗'),
  pets('Pets & Animals', '🐕'),
  other('Other', '📋');

  const GroupCategory(this.displayName, this.emoji);

  final String displayName;
  final String emoji;

  static List<GroupCategory> get allCategories => GroupCategory.values;
}
