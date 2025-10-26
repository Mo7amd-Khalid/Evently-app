import 'package:evently/l10n/generated/app_localizations.dart';
import 'package:evently/provider/app_config_provider.dart';
import 'package:evently/ui/login/login_screen.dart';
import 'package:evently/ui/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../wigdets/language_switch.dart';
import '../wigdets/theme_switch.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});
  static const String routeName = "Setup Screen";

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                    "assets/images/horizontal logo.png",
                  width: MediaQuery.sizeOf(context).width*0.5,
                ),
              ),
              Expanded(child: Image.asset(provider.themeMode == ThemeMode.light? "assets/images/setup.png" : "assets/images/dark_setup.png")),
              Text(
                  AppLocalizations.of(context)!.personalizeYourExperience,
                style: TextTheme.of(context).titleLarge,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                  AppLocalizations.of(context)!.setupMessage,
                style: TextTheme.of(context).bodyLarge,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.language,
                    style: TextTheme.of(context).titleLarge,
                  ),
                  Spacer(),
                  LanguageSwitch(),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.theme,
                    style: TextTheme.of(context).titleLarge,
                  ),
                  Spacer(),
                  ThemeSwitch(),
                ],
              ),
              SizedBox(
                height: 22,
              ),
              FilledButton(onPressed: ()async {
                var pref = await SharedPreferences.getInstance();
                if(pref.getBool("onboarding") == null)
                  {
                    Navigator.pushReplacementNamed(context, OnBoardingScreen.routeName);
                  }
                else
                  {
                    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                  }

              }, child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.letsGo),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
