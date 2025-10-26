import 'package:evently/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../validation/data_validation.dart';
import '../firebase/firebase_auth_services.dart';

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
                if(await FirebaseAuthServices.resetPassword(emailController.text))
                  {
                    print("reset password done ");
                  }
                else
                  {
                    print("not done");
                  }
              }
      
          }, child: Text(locale.resetPassword))
        ],
      ),
    );
  }
}
