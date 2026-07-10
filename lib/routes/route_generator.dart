import 'package:flutter/material.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/home/domain/entities/home_item.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/job_details/presentation/pages/job_details_page.dart';
import '../features/notifications/presentation/pages/notifications_page.dart';
import '../features/onboarding/presentation/pages/role_selection_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case AppRoutes.roleSelection:
        return MaterialPageRoute(builder: (_) => const RoleSelectionPage());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case AppRoutes.notifications:
        return MaterialPageRoute(
            builder: (_) => const NotificationsPage());

      case AppRoutes.jobDetails:
        final job = settings.arguments as HomeItem;
        return MaterialPageRoute(
            builder: (_) => JobDetailsPage(job: job));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
