import 'package:evently/l10n/generated/app_localizations.dart';
import 'package:evently/ui/forget_password/forget_password_screen.dart';
import 'package:evently/ui/home/main_screen.dart';
import 'package:evently/ui/register/register_screen.dart';
import 'package:evently/ui/wigdets/app_dialogs.dart';
import 'package:evently/ui/wigdets/language_switch.dart';
import 'package:flutter/material.dart';

import '../../validation/data_validation.dart';
import '../firebase/firebase_auth_services.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  static const String routeName = "Login Screen";

  final TextEditingController emailController = TextEditingController();


  final ValueNotifier<bool> passwordVisible = ValueNotifier(false);
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
    body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Image.asset(
                "assets/images/Circle Logo.png",
                height: MediaQuery.sizeOf(context).height*0.25,
              ),
              SizedBox(
                height: 22,
              ),
              ///email text field
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
                height: 16,
              ),
              ///password text field
              ValueListenableBuilder(
                valueListenable: passwordVisible,
                builder: (context, value, child) => TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => DataValidation.passwordValidation(value??"", locale),

                  obscureText: !value,
                  decoration: InputDecoration(
                    errorMaxLines: 2,
                    hintText: locale.password,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        passwordVisible.value = !passwordVisible.value;
                      },
                      icon: value
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                  ),
                ),
              ),
              ///forget password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, ForgetPasswordScreen.routeName);
                    },
                    child: Text(
                        locale.forgetPassword,
                    )),
              ),
              ///login
              FilledButton(
                  onPressed: (){
                    if(formKey.currentState!.validate())
                    {
                      AppDialogs.loadingDialog(
                        context: context,
                        loadingMessage: "Loading",
                        dismissable: false,
                      );
                      FirebaseAuthServices.loginUser(emailController.text, passwordController.text).then((e){

                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, MainScreen.routeName);
                      }).onError((error,e){
                        print(error.toString());
                        Navigator.pop(context);
                        AppDialogs.actionDialog(
                          context: context,
                          title: "Login Failed",
                          content: "Please Enter Valid Email and Password",
                          posActionTitle: "Try Again",
                        );
                      });
                    }
                  },
                  child: Text(locale.login,)),
              ///create account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      locale.doNotHaveAccount,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextButton(onPressed: (){
                    Navigator.pushNamed(context, RegisterScreen.routeName);
                  }, child: Text(locale.createAccount))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: [
                  Expanded(
                    child: Divider(
                      color: Theme.of(context).colorScheme.primary,
                      indent: 40,
                    ),
                  ),
                  Text(locale.or),
                  Expanded(
                    child: Divider(
                      color: Theme.of(context).colorScheme.primary,
                      endIndent: 40,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 22,
              ),
              /// login with google
              OutlinedButton(
                  onPressed: (){},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Image.asset("assets/images/google_Logo.png"),
                      Text(locale.loginWithGoogle),
                    ],
                  )),
              SizedBox(
                height: 22,
              ),
              /// language switch
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LanguageSwitch(),
                ],
              ),
            ],
          ),
        )
    ),
    );
  }
}
