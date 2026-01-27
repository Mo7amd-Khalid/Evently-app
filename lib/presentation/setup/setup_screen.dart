import 'package:evently/core/di/di.dart';
import 'package:evently/core/l10n/generated/app_localizations.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/utils/app_assets.dart';
import 'package:evently/presentation/setup/cubit/setup_cubit.dart';
import 'package:evently/presentation/setup/cubit/setup_state.dart';
import 'package:evently/presentation/widgets/language_switch.dart';
import 'package:evently/presentation/widgets/theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SetupScreen extends StatefulWidget {
  SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final SetupCubit cubit = getIt();

  @override
  void initState() {
    super.initState();
    cubit.navigation.listen((navigationState){
      switch (navigationState) {
        case NavigateToOnboardingScreen():{
          Navigator.pushReplacementNamed(context, Routes.onboarding);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<SetupCubit, SetupState>(
        builder:
            (_, state) => Scaffold(
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
                          width: MediaQuery.sizeOf(context).width * 0.5,
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          state.mode == ThemeMode.light
                              ? AppImages.setupImageLightMode
                              : AppImages.setupImageDarkMode,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.personalizeYourExperience,
                        style: TextTheme.of(context).titleLarge,
                      ),
                      SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.setupMessage,
                        style: TextTheme.of(context).bodyLarge,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.language,
                            style: TextTheme.of(context).titleLarge,
                          ),
                          Spacer(),
                          LanguageSwitch(cubit: cubit),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.theme,
                            style: TextTheme.of(context).titleLarge,
                          ),
                          Spacer(),
                          ThemeSwitch(cubit: cubit),
                        ],
                      ),
                      SizedBox(height: 22),
                      FilledButton(
                        onPressed: () {
                        cubit.doAction(GoToOnboardingScreen());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context)!.letsGo),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
