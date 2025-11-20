import 'package:get/get.dart';
import 'package:my_events_test_project/app/navigation/navigations/app_routes.dart';
import 'package:my_events_test_project/features/auth/presentation/view/auth_screen.dart';
import 'package:my_events_test_project/features/events/presentation/views/event_detail_screen.dart';
import 'package:my_events_test_project/features/events/presentation/views/event_form_screen.dart';
import 'package:my_events_test_project/features/events/presentation/views/event_list_screen.dart';
import 'package:my_events_test_project/features/splash/presentation/view/splash_screen.dart';

class AppPages {
  static final List<GetPage> routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.auth, page: () => const AuthScreen()),
    GetPage(name: AppRoutes.home, page: () => const EventListScreen()),
    GetPage(
      name: AppRoutes.eventDetails,
      page: () => const EventDetailScreen(),
    ),
    GetPage(name: AppRoutes.eventForm, page: () => const EventFormScreen()),
  ];
}
