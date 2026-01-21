import 'package:evently/core/di/di.dart';
import 'package:evently/core/l10n/generated/app_localizations.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/presentation/forget_password/cubit/forget_password_contract.dart';
import 'package:evently/presentation/forget_password/cubit/forget_password_cubit.dart';
import 'package:evently/presentation/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../validation/data_validation.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  ForgetPasswordCubit cubit = getIt();

  @override
  void initState() {
    super.initState();
    cubit.navigation.listen((navigationState) {
      switch (navigationState) {
        case ShowDialogLoadingNavigation():
          AppDialogs.loadingDialog(
            context: context,
            loadingMessage: AppLocalizations.of(context)!.loading,
          );
        case ShowDialogSuccessNavigation():
          {
            Navigator.pop(context);
            AppDialogs.actionDialog(
              context: context,
              title: AppLocalizations.of(context)?.resetPasswordDone ?? "",
              content:
                  AppLocalizations.of(context)?.checkYourMailToResetPassword ??
                  "",
              posActionTitle: AppLocalizations.of(context)?.ok ?? "",
              posAction: () {
                Navigator.pushReplacementNamed(context, Routes.login);
              },
              dismissable: false,
            );
          }
        case ShowDialogFailedNavigation():
          {
            Navigator.pop(context);
            AppDialogs.actionDialog(
              context: context,
              title: AppLocalizations.of(context)?.resetPasswordFailed ?? "",
              content: navigationState.message,
            );
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
        builder:
            (_, state) => Scaffold(
              appBar: AppBar(
                title: Text(locale.forgetPassword),
                centerTitle: true,
              ),
              body: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Image.asset("assets/images/forget password.png"),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator:
                        (value) =>
                            DataValidation.emailValidation(value ?? "", locale),
                    decoration: InputDecoration(
                      hintText: locale.email,
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      if (DataValidation.emailValidation(
                            emailController.text,
                            locale,
                          ) ==
                          null) {
                        cubit.doAction(
                          SendPasswordResetEmailAction(emailController.text),
                        );
                      }
                    },
                    child: Text(locale.resetPassword),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
