import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'core/__core.dart';
import 'themes/__themes.dart';
import 'styles/__styles.dart';
import 'constants/__constants.dart';

class App extends StatelessWidget {
  const App({super.key});

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
        initialRoute: FirebaseService.auth.currentUser != null
            ? RouteNames.mainApp.homePage
            : RouteNames.auth.signInPage,
        getPages: AppRoutes.routes,
        initialBinding: InitialBinding(),
        defaultTransition: Transition.noTransition,
        transitionDuration: const Duration(milliseconds: 400),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeService.theme,
        scrollBehavior:
            const MaterialScrollBehavior().copyWith(scrollbars: false),
      ),
    );
  }
}
