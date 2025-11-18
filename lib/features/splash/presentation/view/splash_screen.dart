import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_events_test_project/features/splash/presentation/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/animations/logo_animation.json', 
          width: 200,
          height: 200,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}