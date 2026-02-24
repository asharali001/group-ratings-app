import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/__core.dart';
import 'themes/__themes.dart';
import 'styles/__styles.dart';
import 'constants/__constants.dart';

class App extends StatelessWidget {
  const App({super.key});

  String _getInitialRoute() {
    if (Firebase.apps.isEmpty) {
      return RouteNames.auth.signInPage;
    }
    final currentUser = FirebaseService.auth.currentUser;
    return currentUser != null
        ? RouteNames.mainApp.mainLayout
        : RouteNames.auth.signInPage;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: GetMaterialApp(
        title: AppStrings.appName,
        initialRoute: _getInitialRoute(),
        getPages: AppRoutes.routes,
        initialBinding: InitialBinding(),
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 100),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeService.theme,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          scrollbars: false,
        ),
      ),
    );
  }
}
