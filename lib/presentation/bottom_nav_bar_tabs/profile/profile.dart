import 'dart:io';

import 'package:evently/core/di/di.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/core/constant/app_assets.dart';
import 'package:evently/core/utils/context_func.dart';
import 'package:evently/core/utils/padding.dart';
import 'package:evently/core/utils/white_spaces.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/home/cubit/home_contract.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/home/cubit/home_cubit.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/profile/cubit/profile_contract.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/profile/cubit/profile_cubit.dart';
import 'package:evently/presentation/select_location/cubit/google_map_cubit.dart';
import 'package:evently/presentation/setup/cubit/setup_cubit.dart';
import 'package:evently/presentation/setup/cubit/setup_state.dart';
import 'package:evently/presentation/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GoogleMapCubit googleMapCubit = getIt();

  final HomeCubit homeCubit = getIt();

  final SetupCubit setupCubit = getIt();

  final ProfileCubit profileCubit = getIt();

  @override
  void initState() {
    super.initState();
    profileCubit.navigation.listen((navigationState) {
      switch (navigationState) {
        case ShowLoadingDialog():
          AppDialogs.loadingDialog(
            context: context,
            loadingMessage: context.locale!.loading,
          );
        case ShowUpdatedDialog():
          Navigator.pop(context);
          AppDialogs.actionDialog(
            context: context,
            title: context.locale!.updateProfileImage,
            content: navigationState.message,
            posActionTitle: context.locale!.ok,
            posAction: () {
              homeCubit.doAction(GetUserData());
            },
          );
        case ShowLogoutConfirmationDialog():
          AppDialogs.actionDialog(
            context: context,
            title: context.locale!.logout,
            content: navigationState.message,
            posActionTitle: context.locale!.ok,
            posAction: (){
              profileCubit.doAction(Logout());
            },
            negActionTitle: context.locale!.no
          );
        case NavigateToLoginScreen():
          Navigator.pushReplacementNamed(context, Routes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: setupCubit),
        BlocProvider.value(value: profileCubit),
        BlocProvider.value(value: homeCubit),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              height: context.heightSize * 0.26,
              decoration: BoxDecoration(
                color: AppColors.purple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                ),
              ),
              child: SafeArea(
                child: Row(
                  spacing: 15,
                  children: [
                    BlocBuilder<HomeCubit, HomeState>(
                      builder:
                          (_, state) => Container(
                            width: context.widthSize * 0.35,
                            height: context.heightSize * 0.17,
                            decoration: BoxDecoration(
                              color: AppColors.lightBlue,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(70),
                                bottomLeft: Radius.circular(70),
                                bottomRight: Radius.circular(70),
                              ), // round
                              image: DecorationImage(
                                image:
                                    state.userData.data!.photoURL == null
                                        ? AssetImage(AppImages.userImage)
                                        : FileImage(
                                          File(state.userData.data!.photoURL!),
                                        ),
                              ), // ed square shape
                            ),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.gray,
                                  child: IconButton(
                                    onPressed: () {
                                      profileCubit.doAction(
                                        ChangeProfilePicture(context),
                                      );
                                    },
                                    icon: Icon(Icons.camera_alt_outlined),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ),
                    Expanded(
                      child: Column(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            homeCubit.state.userData.data?.displayName ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textStyle.headlineSmall!.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            homeCubit.state.userData.data?.email ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textStyle.bodyLarge!.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: AppColors.white,
                              ),
                              Text(
                                googleMapCubit.state.theCountryAndCity ?? "",
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(color: AppColors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ).horizontalPadding(16),
              ),
            ),
          ),
          BlocBuilder<SetupCubit, SetupState>(
            builder:
                (_, state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      context.locale!.language,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    10.verticalSpace,
                    // language drop down
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppColors.purple),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppColors.purple),
                        ),
                      ),
                      initialValue: context.locale!.en,
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      focusColor: Theme.of(context).colorScheme.primary,
                      items:
                          [context.locale!.en, context.locale!.ar]
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setupCubit.doAction(
                          ChangeLanguage(
                            value == context.locale!.en ? "en" : "ar",
                          ),
                        );
                      },
                    ),
                    20.verticalSpace,
                    // theme drop down
                    Text(
                      context.locale!.theme,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    // theme drop down
                    DropdownButtonFormField<ThemeMode>(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppColors.purple),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppColors.purple),
                        ),
                      ),
                      initialValue: ThemeMode.light,
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      focusColor: Theme.of(context).colorScheme.primary,
                      items:
                          [ThemeMode.light, ThemeMode.dark]
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e == ThemeMode.light
                                        ? context.locale!.light
                                        : context.locale!.dark,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setupCubit.doAction(
                          ChangeThemeMode(value ?? ThemeMode.light),
                        );
                      },
                    ),
                  ],
                ).allPadding(16),
          ),
          Spacer(),
          FilledButton(
            onPressed: () {
              profileCubit.doAction(LogoutConfirmation(context.locale!.logoutConfirmation));
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.all(20),
            ),
            child: Row(
              spacing: 5,
              children: [
                Icon(Icons.logout_outlined),
                Text(context.locale!.logout),
              ],
            ),
          ).allPadding(16),
        ],
      ),
    );
  }
}
