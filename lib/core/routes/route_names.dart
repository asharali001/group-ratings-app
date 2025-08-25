class RouteNames {
  static final auth = _AuthRoutes();
  static final mainApp = _MainAppRoutes();
  static final other = _OtherRoutes();
  static final groups = _GroupRoutes();
}

class _AuthRoutes {
  final String signInPage = '/signin';
  final String signUpPage = '/signup';
}

class _MainAppRoutes {
  final String homePage = '/home';
  final String groupsPage = '/groups';
}

class _OtherRoutes {
  final String pageNoFound = '/page_not_found';
}

class _GroupRoutes {
  final String createGroupPage = '/groups/create';
  final String joinGroupPage = '/groups/join';
  final String ratingsPage = '/groups/ratings';
  final String editGroupPage = '/groups/edit';
}
