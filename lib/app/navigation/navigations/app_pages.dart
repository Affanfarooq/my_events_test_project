import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_events_test_project/app/navigation/navigations/app_routes.dart';
import 'package:my_events_test_project/features/splash/presentation/view/splash_screen.dart';

class AppPages {
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    
    GetPage(
      name: AppRoutes.auth,
      page: () => const Scaffold(body: Center(child: Text('Auth Screen'))),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const Scaffold(body: Center(child: Text('Home Screen'))),
    ),
  ];
}