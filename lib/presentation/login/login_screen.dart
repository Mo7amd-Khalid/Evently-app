import 'package:evently/core/di/di.dart';
import 'package:evently/core/l10n/generated/app_localizations.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/utils/app_assets.dart';
import 'package:evently/core/utils/context_func.dart';
import 'package:evently/core/utils/white_spaces.dart';
import 'package:evently/presentation/login/cubit/login_contract.dart';
import 'package:evently/presentation/login/cubit/login_cubit.dart';
import 'package:evently/presentation/setup/cubit/setup_cubit.dart';
import 'package:evently/presentation/widgets/app_dialogs.dart';
import 'package:evently/presentation/widgets/language_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../validation/data_validation.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginCubit loginCubit = getIt();
  SetupCubit setupCubit = getIt();

  @override
  void initState() {
    super.initState();
    loginCubit.navigation.listen((navigationState) {
      switch (navigationState) {

        case ShowLoadingDialog():{
          AppDialogs.loadingDialog(
            context: context,
            loadingMessage: AppLocalizations.of(context)?.loading ?? "",
            dismissable: false,
          );
        }
        case ShowErrorDialog():{
          Navigator.pop(context);
          AppDialogs.actionDialog(
            context: context,
            title: AppLocalizations.of(context)?.loginFailed,
            content: AppLocalizations.of(context)?.invalidCredentials,
            posActionTitle: AppLocalizations.of(context)?.tryAgain,
          );
        }
        case NavigateToHomeScreen():{
          Navigator.pushReplacementNamed(context, Routes.main);
        }
        case NavigateToRegisterScreen():
          {
            Navigator.pushNamed(context, Routes.register);
          }
        case NavigateToForgetPasswordScreen():
          {
            Navigator.pushNamed(context, Routes.forgetPassword);
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: loginCubit),
        BlocProvider.value(value: setupCubit),
      ],
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (_, state) =>
            Scaffold(
              body: SafeArea(
                  child: Form(
                    key: formKey,
                    child: ListView(
                      padding: EdgeInsets.all(16),
                      children: [
                        Image.asset(
                          AppImages.circleLogo,
                          height: context.heightSize * 0.25,
                        ),
                        22.verticalSpace,
                        ///email text field
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              DataValidation.emailValidation(
                                  value ?? "", locale),
                          decoration: InputDecoration(
                            hintText: locale.email,
                            prefixIcon: const Icon(Icons.email),
                          ),
                        ),
                        16.verticalSpace,

                        ///password text field
                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              DataValidation.passwordValidation(
                                  value ?? "", locale),
                          obscureText: state.obscurePassword,
                          decoration: InputDecoration(
                            errorMaxLines: 2,
                            hintText: locale.password,
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                loginCubit.doAction(VisibilityOfPassword());
                              },
                              icon: state.obscurePassword ? const Icon(
                                  Icons.visibility_off) : const Icon(
                                  Icons.visibility),
                            ),
                          ),
                        ),

                        ///forget password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {
                                loginCubit.doAction(GoToForgetPasswordScreen());
                              },
                              child: Text(
                                locale.forgetPassword,
                              )),
                        ),

                        ///login
                        FilledButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                loginCubit.doAction(LoginWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text));
                              }
                            },
                            child: Text(locale.login,)),
                        ///create account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              locale.doNotHaveAccount,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,
                            ),
                            TextButton(onPressed: () {
                              loginCubit.doAction(GoToRegisterScreen());
                            }, child: Text(locale.createAccount))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 15,
                          children: [
                            Expanded(
                              child: Divider(
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
                                indent: 40,
                              ),
                            ),
                            Text(locale.or),
                            Expanded(
                              child: Divider(
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
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
                            onPressed: () {
                              // todo signIn With Google
                            },
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
                            LanguageSwitch(cubit: setupCubit,),
                          ],
                        ),
                      ],
                    ),
                  )
              ),
            ),
      ),
    );
  }
}
