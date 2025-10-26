import 'package:evently/l10n/generated/app_localizations.dart';
import 'package:evently/ui/home/main_screen.dart';
import 'package:evently/ui/login/login_screen.dart';
import 'package:evently/ui/wigdets/app_dialogs.dart';
import 'package:evently/validation/data_validation.dart';
import 'package:flutter/material.dart';
import '../firebase/firebase_auth_services.dart';
import '../wigdets/language_switch.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  static const String routeName = "Register Screen";
  final ValueNotifier<bool> passwordVisible = ValueNotifier(false);
  final ValueNotifier<bool> rePasswordVisible = ValueNotifier(false);


  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.register),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Image.asset(
              "assets/images/Circle Logo.png",
              height: MediaQuery.sizeOf(context).height * 0.25,
            ),
            const SizedBox(height: 22),

            /// name text field
            TextFormField(
              controller: nameController,
              keyboardType: TextInputType.name,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => DataValidation.nameValidation(value??"", locale),
              decoration: InputDecoration(
                hintText: locale.name,
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),

            /// email text field
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
            const SizedBox(height: 16),

            /// password text field
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
            const SizedBox(height: 16),

            /// re-password text field
            ValueListenableBuilder(
              valueListenable: rePasswordVisible,
              builder: (context, value, child) => TextFormField(
                controller: rePasswordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => DataValidation.rePasswordValidation(value??"",passwordController.text ,locale),
                obscureText: !value,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: locale.rePassword,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      rePasswordVisible.value = !rePasswordVisible.value;
                    },
                    icon: value
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// create account button
            FilledButton(
              onPressed: () async{
                if (formKey.currentState!.validate()) {
                  AppDialogs.loadingDialog(
                    context: context,
                    loadingMessage: "Loading...",
                    dismissable: false,
                  );
                  FirebaseAuthServices.registerUser(
                      nameController.text,
                      emailController.text,
                      passwordController.text).then((e){
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, MainScreen.routeName);
                  }).onError((error,_){
                    Navigator.pop(context);
                    AppDialogs.actionDialog(
                      context: context,
                      title: "Registration Failed",
                      content: "Please Enter Valid Data",
                      posActionTitle: "Try Again",
                    );
                    print(error.toString());
                  });

                }
              },
              child: Text(locale.createAccount),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  locale.alreadyHaveAccount,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                  child: Text(locale.login),
                ),
              ],
            ),

            /// language switch
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                LanguageSwitch(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
