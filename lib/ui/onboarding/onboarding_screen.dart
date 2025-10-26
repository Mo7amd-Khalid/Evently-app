import 'package:evently/l10n/generated/app_localizations.dart';
import 'package:evently/modules/onboarding_dm.dart';
import 'package:evently/provider/app_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../login/login_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const String routeName = "OnBoarding Screen";

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    List<OnBoardingDM> onboardingData = [
      OnBoardingDM(
          image: "assets/images/onboarding 1.png",
          title: AppLocalizations.of(context)!.onboardingTitle1,
          message: AppLocalizations.of(context)!.onboardingMessage1),
      OnBoardingDM(
          image: provider.isDark() ? "assets/images/dark onboarding 2.png":"assets/images/onboarding 2.png",
          title: AppLocalizations.of(context)!.onboardingTitle2,
          message: AppLocalizations.of(context)!.onboardingMessage2),
      OnBoardingDM(
          image: provider.isDark() ? "assets/images/dark onboarding 3.png" : "assets/images/onboarding 3.png",
          title: AppLocalizations.of(context)!.onboardingTitle3,
          message: AppLocalizations.of(context)!.onboardingMessage3
      )];

    return Scaffold(
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
                  width: MediaQuery.sizeOf(context).width*0.5,
                ),
              ),
              Expanded(child:
              Image.asset(onboardingData[currentIndex].image)),
              Text(
                onboardingData[currentIndex].title,
                style: TextTheme.of(context).titleLarge,
              ),
              Text(
                onboardingData[currentIndex].message,
                style: TextTheme.of(context).bodyLarge,
              ),
              Row(
                children: [
                  currentIndex == 0 ? SizedBox(width: MediaQuery.sizeOf(context).width*0.1,):Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary
                        )
                    ),
                    width: MediaQuery.sizeOf(context).width*0.1,
                    height: MediaQuery.sizeOf(context).height*0.046,
                    child: IconButton(
                      onPressed: (){
                        currentIndex--;
                        setState(() {});
                      },
                      icon: Icon(Icons.arrow_back,
                        color: Theme.of(context).colorScheme.primary,),
                    ),
                  ),
                  Spacer(),
                  AnimatedSmoothIndicator(
                      activeIndex: currentIndex,
                      count: onboardingData.length,
                    effect: ExpandingDotsEffect(
                      expansionFactor: 3,
                      dotHeight: 12,
                      dotWidth: 12,
                      dotColor: Theme.of(context).colorScheme.secondary,

                    ),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary
                      )
                    ),
                      width: MediaQuery.sizeOf(context).width*0.1,
                      height: MediaQuery.sizeOf(context).height*0.046,
                      child: IconButton(
                        onPressed: ()async{
                          if(currentIndex == 2) {
                            var pref = await SharedPreferences.getInstance();
                            pref.setBool("onboarding", true);
                            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                          }
                          else {
                            currentIndex++;
                            setState(() {});
                          }
                        },
                        icon: Icon(Icons.arrow_forward,
                          color: Theme.of(context).colorScheme.primary,),
                      ),
                                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
