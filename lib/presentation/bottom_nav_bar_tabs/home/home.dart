import 'package:evently/core/di/di.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/home/cubit/home_contract.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/home/cubit/home_cubit.dart';
import 'package:evently/presentation/setup/cubit/setup_cubit.dart';
import 'package:evently/presentation/setup/cubit/setup_state.dart';
import 'package:evently/ui/firebase/event_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import 'package:evently/core/l10n/generated/app_localizations.dart';
import '../../../ui/firebase/firebase_auth_services.dart';
import '../../widgets/event_card.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  HomeCubit homeCubit = getIt();
  SetupCubit setupCubit = getIt();

  @override
  void initState() {
    super.initState();
    homeCubit.doAction(GetUserData());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: homeCubit),
        BlocProvider.value(value: setupCubit),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder:
            (_, state) => Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: setupCubit.state.mode == ThemeMode.dark? AppColors.darkPurple : AppColors.purple
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            spacing: 10,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 3,
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.welcomeBack,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(color: AppColors.white),
                                      ),
                                      Text(
                                        state.userData.data?.displayName ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(color: AppColors.white),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      setupCubit.doAction(ChangeThemeMode(setupCubit.state.mode == ThemeMode.dark? ThemeMode.light : ThemeMode.dark));
                                    },
                                    icon: setupCubit.state.mode == ThemeMode.dark ? Icon(Icons.dark_mode_outlined,color: AppColors.white,) : Icon(Icons.light_mode_outlined,color: AppColors.white,),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setupCubit.doAction(ChangeLanguage(setupCubit.state.language == "en" ? "ar" : "en"));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: AppColors.white,
                                      ),
                                      child: Text(
                                        setupCubit.state.language.toUpperCase(),
                                        style: TextStyle(
                                          color: setupCubit.state.mode == ThemeMode.dark? AppColors.darkPurple : AppColors.purple
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: AppColors.white,
                                  ),
                                  Text(
                                    "Cairo, Egypt",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        DefaultTabController(
                          length: state.categoriesList.length,
                          child: TabBar(
                            onTap: (index) {
                              homeCubit.doAction(ChooseSelectedCategory(index));
                            },
                            isScrollable: true,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            indicator: BoxDecoration(),
                            labelPadding: EdgeInsets.symmetric(horizontal: 8),
                            dividerHeight: 0,
                            indicatorPadding: EdgeInsets.zero,
                            tabAlignment: TabAlignment.start,
                            tabs:
                                state.categoriesList
                                    .map(
                                      (category) => Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              state.categoriesList[state.selectedCategoryIndex] == category
                                                  ? AppColors.lightBlue
                                                  : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: AppColors.white,
                                          ),
                                        ),
                                        child: Tab(
                                          child: Row(
                                            spacing: 5,
                                            children: [
                                              Icon(
                                                category.icon,
                                                color:
                                                state.categoriesList[state.selectedCategoryIndex] ==
                                                            category
                                                        ? Theme.of(
                                                          context,
                                                        ).colorScheme.primary
                                                        : AppColors.white,
                                              ),
                                              Text(
                                                setupCubit.state.language == "en" ? category.nameEN : category.nameAR,
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyLarge!.copyWith(
                                                  color:
                                                  state.categoriesList[state.selectedCategoryIndex] ==
                                                              category
                                                          ? Theme.of(
                                                            context,
                                                          ).colorScheme.primary
                                                          : AppColors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: EventManagementFirebase.getEventsData(
                      state.categoriesList[state.selectedCategoryIndex].id,
                    ),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        var events =
                            snapshot.data?.docs.map((e) => e.data()).toList() ??
                            [];
                        return ListView.separated(
                          padding: EdgeInsets.all(16),
                          itemBuilder:
                              (context, index) =>
                                  EventCart(event: events[index]),
                          separatorBuilder:
                              (context, index) => SizedBox(height: 10),
                          itemCount: events.length,
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
