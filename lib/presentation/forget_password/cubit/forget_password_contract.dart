class ForgetPasswordState {}


sealed class ForgetPasswordAction{}

class SendPasswordResetEmailAction extends ForgetPasswordAction{
  final String email;
  SendPasswordResetEmailAction(this.email);
}



sealed class ForgetPasswordNavigation{}

class ShowDialogLoadingNavigation extends ForgetPasswordNavigation{}
class ShowDialogSuccessNavigation extends ForgetPasswordNavigation{}
class ShowDialogFailedNavigation extends ForgetPasswordNavigation{
  final String message;
  ShowDialogFailedNavigation(this.message);
}

