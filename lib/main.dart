import 'package:evently/core/theme/app_theme.dart';
import 'package:evently/provider/app_config_provider.dart';
import 'package:evently/ui/firebase/firebase_auth_services.dart';
import 'package:evently/ui/forget_password/forget_password_screen.dart';
import 'package:evently/ui/home/bottom_nav_bar_tabs/event_management_screen/event_details.dart';
import 'package:evently/ui/home/bottom_nav_bar_tabs/event_management_screen/event_management_screen.dart';
import 'package:evently/ui/home/main_screen.dart';
import 'package:evently/ui/login/login_screen.dart';
import 'package:evently/ui/onboarding/onboarding_screen.dart';
import 'package:evently/ui/register/register_screen.dart';
import 'package:evently/ui/setup/setup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'l10n/generated/app_localizations.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppConfigProvider(),
      builder: (context, child) {
        var provider = Provider.of<AppConfigProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false, 
          localizationsDelegates: AppLocalizations.localizationsDelegates, 
          supportedLocales: AppLocalizations.supportedLocales, 
          locale: Locale(provider.locale),
          theme: AppTheme.lightTheme, 
          darkTheme: AppTheme.darkTheme, 
          themeMode: provider.themeMode, 
          routes: {
            SetupScreen.routeName : (_)=> SetupScreen(),
            OnBoardingScreen.routeName : (_)=> OnBoardingScreen(),
            LoginScreen.routeName : (_) => LoginScreen(),
            RegisterScreen.routeName : (_) => RegisterScreen(),
            MainScreen.routeName : (_) => MainScreen(),
            ForgetPasswordScreen.routeName : (_) => ForgetPasswordScreen(),
            EventManagementScreen.routeName : (_) => EventManagementScreen(),
            EventDetails.routeName : (_) => EventDetails(),
          },
          initialRoute: FirebaseAuthServices.getUserData() == null ? SetupScreen.routeName : MainScreen.routeName,
        );
      }
      );
  }
}

