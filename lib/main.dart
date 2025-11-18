import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_events_test_project/app/core/theme/app_theme.dart';
import 'package:my_events_test_project/app/navigation/navigations/app_pages.dart';
import 'package:my_events_test_project/app/navigation/navigations/app_routes.dart';
import 'di_container.dart' as di; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // Initialize Hive (for Caching)
  await Hive.initFlutter();
  // Initialize Dependencies (Services, Repos, etc.)
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MyEvents',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, 
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}