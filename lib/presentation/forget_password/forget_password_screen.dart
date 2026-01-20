import 'package:evently/core/l10n/generated/app_localizations.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/presentation/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import '../../validation/data_validation.dart';
import '../../ui/firebase/firebase_auth_services.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});
  static const String routeName = "Forget Password Screen";

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.forgetPassword),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Image.asset("assets/images/forget password.png"),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => DataValidation.emailValidation(value??"", locale),
            decoration: InputDecoration(
              hintText: locale.email,
              prefixIcon: const Icon(Icons.email),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FilledButton(onPressed: () async{
            if(DataValidation.emailValidation(emailController.text, locale) == null)
              {
                AppDialogs.loadingDialog(context: context, loadingMessage: locale.loading);

                FirebaseAuthServices.resetPassword(emailController.text).then((e){
                  Navigator.pop(context);
                  AppDialogs.actionDialog(
                    context: context,
                    title: locale.resetPasswordDone,
                    content: locale.checkYourMailToResetPassword,
                    posActionTitle: locale.ok,
                    posAction: (){
                      Navigator.pushReplacementNamed(context, Routes.login);
                    }
                  );
                }).onError((error,e){
                  Navigator.pop(context);
                  AppDialogs.actionDialog(
                      context: context,
                      title: locale.resetPasswordFailed,
                      content: error.toString(),
                      posActionTitle: locale.tryAgain,
                  );
                });
              }
      
          }, child: Text(locale.resetPassword))
        ],
      ),
    );
  }
}
