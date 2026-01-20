import 'package:evently/core/di/di.dart';
import 'package:evently/core/l10n/generated/app_localizations.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/data/models/onboarding_dm.dart';
import 'package:evently/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:evently/presentation/onboarding/cubit/onboarding_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  OnboardingCubit cubit = getIt();
  @override
  void initState() {
    super.initState();
    cubit.navigation.listen((navigationState){
      switch (navigationState) {

        case NavigateToLoginScreen():{
          Navigator.pushReplacementNamed(context, Routes.login);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<OnBoardingDM> onboardingData = [
      OnBoardingDM(
        image: "assets/images/onboarding 1.png",
        title: AppLocalizations.of(context)!.onboardingTitle1,
        message: AppLocalizations.of(context)!.onboardingMessage1,
      ),
      OnBoardingDM(
        image: "assets/images/onboarding 2.png",
        title: AppLocalizations.of(context)!.onboardingTitle2,
        message: AppLocalizations.of(context)!.onboardingMessage2,
      ),
      OnBoardingDM(
        image: "assets/images/onboarding 3.png",
        title: AppLocalizations.of(context)!.onboardingTitle3,
        message: AppLocalizations.of(context)!.onboardingMessage3,
      ),
    ];

    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder:
            (_, state) => Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    spacing: 35,
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
                          onboardingData[state.currentIndex].image,
                        ),
                      ),
                      Text(
                        onboardingData[state.currentIndex].title,
                        style: TextTheme.of(context).titleLarge,
                      ),
                      Text(
                        onboardingData[state.currentIndex].message,
                        style: TextTheme.of(context).bodyLarge,
                      ),
                      Row(
                        children: [
                          state.currentIndex == 0
                              ? SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.1,
                              )
                              : InkWell(
                                borderRadius: BorderRadius.circular(500),
                                onTap: () {
                                  cubit.doAction(
                                    ChangeIndex(state.currentIndex - 1),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                          Spacer(),
                          AnimatedSmoothIndicator(
                            activeIndex: state.currentIndex,
                            count: onboardingData.length,
                            effect: ExpandingDotsEffect(
                              expansionFactor: 3,
                              dotHeight: 12,
                              dotWidth: 12,
                              dotColor: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            borderRadius: BorderRadius.circular(500),
                            onTap: () {
                              if (state.currentIndex == 2) {
                                cubit.doAction(GoToLoginScreen());
                              } else {
                                cubit.doAction(
                                  ChangeIndex(state.currentIndex + 1),
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
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
