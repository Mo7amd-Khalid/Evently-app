class OnboardingState {
   int currentIndex;
   OnboardingState({this.currentIndex = 0});

   OnboardingState copyWith({int? index})
   {
     return OnboardingState(currentIndex: index??currentIndex);
   }
}

sealed class OnboardingActions{}

class ChangeIndex extends OnboardingActions{
  final int index;
  ChangeIndex(this.index);
}

class GoToLoginScreen extends OnboardingActions{}


sealed class OnboardingNavigation{}

class NavigateToLoginScreen extends OnboardingNavigation{}

