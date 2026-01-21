import 'package:evently/core/routes/routes.dart';
import 'package:evently/presentation/forget_password/forget_password_screen.dart';
import 'package:evently/presentation/setup/setup_screen.dart';
import 'package:evently/presentation/login/login_screen.dart';
import 'package:evently/presentation/onboarding/onboarding_screen.dart';
import 'package:evently/presentation/register/register_screen.dart';
import 'package:evently/ui/home/main_screen.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

abstract class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    if (kDebugMode) {
      print('Navigating to: ${settings.name}');
    }

    final uri = Uri.parse(settings.name ?? '/');

    switch (uri.path) {
      case Routes.setup:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SetupScreen(),
        );
      case Routes.onboarding:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => OnBoardingScreen(),
        );
      case Routes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LoginScreen(),
        );
      case Routes.forgetPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ForgetPasswordScreen(),
        );
      case Routes.register:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => RegisterScreen(),
        );

      case Routes.main:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MainScreen(),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('404 - Page Not Found')),
              ),
        );
    }
  }
}
