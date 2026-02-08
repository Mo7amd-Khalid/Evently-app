import 'package:evently/core/di/di.dart';
import 'package:evently/core/l10n/generated/app_localizations.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/constant/app_assets.dart';
import 'package:evently/core/utils/white_spaces.dart';
import 'package:evently/presentation/register/cubit/register_contract.dart';
import 'package:evently/presentation/register/cubit/register_cubit.dart';
import 'package:evently/presentation/setup/cubit/setup_cubit.dart';
import 'package:evently/presentation/widgets/app_dialogs.dart';
import 'package:evently/validation/data_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/language_switch.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController rePasswordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RegisterCubit registerCubit = getIt();
  SetupCubit setupCubit = getIt();

  @override
  void initState() {
    super.initState();
    registerCubit.navigation.listen((navigationState) {
      switch (navigationState) {
        case ShowLoadingDialog():
          {
            AppDialogs.loadingDialog(
              context: context,
              loadingMessage: AppLocalizations.of(context)?.loading ?? "",
              dismissable: false,
            );
          }
        case ShowErrorDialog():
          {
            Navigator.pop(context);
            AppDialogs.actionDialog(
              context: context,
              title: AppLocalizations.of(context)?.registrationFailed ?? "",
              content: navigationState.message,
              posActionTitle: AppLocalizations.of(context)?.tryAgain ?? "",
            );
          }
        case NavigateToLoginScreen():
          {
            Navigator.pushReplacementNamed(context, Routes.login);
          }
        case ShowVerificationDialog():
          {
            Navigator.pop(context);
            AppDialogs.actionDialog(
              context: context,
              title: AppLocalizations.of(context)?.verificationEmail,
              content: AppLocalizations.of(context)?.checkYourMail,
              posActionTitle: AppLocalizations.of(context)?.ok ?? "",
              posAction: (){
                registerCubit.doAction(CheckVerificationUser());
              },
              negActionTitle: AppLocalizations.of(context)?.sendAgain ?? "",
              negAction: (){
                registerCubit.doAction(SendVerificationEmail());
              },
              dismissable: false,
            );
          }

      }
    });

  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: registerCubit),
        BlocProvider.value(value: setupCubit),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(locale.register), centerTitle: true),
        body: BlocBuilder<RegisterCubit, RegisterState>(
          builder:
              (_, state) => Form(
                key: formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Image.asset(
                      AppImages.circleLogo,
                      height: MediaQuery.sizeOf(context).height * 0.25,
                    ),
                    const SizedBox(height: 22),

                    /// name text field
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator:
                          (value) => DataValidation.nameValidation(
                            value ?? "",
                            locale,
                          ),
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
                      validator:
                          (value) => DataValidation.emailValidation(
                            value ?? "",
                            locale,
                          ),
                      decoration: InputDecoration(
                        hintText: locale.email,
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// password text field
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator:
                          (value) => DataValidation.passwordValidation(
                            value ?? "",
                            locale,
                          ),
                      obscureText: state.obscurePassword,
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        hintText: locale.password,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            registerCubit.doAction(ChangeVisibilityOfPassword());
                          },
                          icon:
                              state.obscurePassword
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                    16.verticalSpace,

                    /// re-password text field
                    TextFormField(
                      controller: rePasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator:
                          (value) => DataValidation.rePasswordValidation(
                            value ?? "",
                            passwordController.text,
                            locale,
                          ),
                      obscureText: state.obscureRePassword,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: locale.rePassword,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            registerCubit.doAction(ChangeVisibilityOfRePassword());
                          },
                          icon:
                              state.obscureRePassword
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                    16.verticalSpace,

                    /// create account button
                    FilledButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          registerCubit.doAction(
                            RegisterWithEmailAndPassword(
                              name: nameController.text,
                              email: emailController.text,
                              password: rePasswordController.text,
                            ),
                          );
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
                            registerCubit.doAction(GoToLoginScreen());
                          },
                          child: Text(locale.login),
                        ),
                      ],
                    ),

                    /// language switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [LanguageSwitch(cubit: setupCubit,)],
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
