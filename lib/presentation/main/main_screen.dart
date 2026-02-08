import 'package:evently/core/di/di.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/core/l10n/generated/app_localizations.dart';
import 'package:evently/presentation/main/cubit/main_contract.dart';
import 'package:evently/presentation/main/cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  MainCubit mainCubit = getIt();

  @override
  void initState() {
    super.initState();
    mainCubit.navigation.listen((navigationState){
      switch (navigationState) {

        case NavigateToEventManagementScreen():
          {
            Navigator.pushNamed(context, Routes.addEvent);
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return BlocProvider.value(
      value: mainCubit,
      child: BlocBuilder<MainCubit, MainState>(
        builder: (_,state) => Scaffold(
          resizeToAvoidBottomInset: false,
          body: state.bottomNavBarTabs[state.selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index){
              mainCubit.doAction(ChangeSelectedIndex(index));
            },
            currentIndex: state.selectedIndex,
              type: BottomNavigationBarType.fixed,
              items: [
            BottomNavigationBarItem(
                icon: Icon(state.selectedIndex == 0? Icons.home : Icons.home_outlined),
                label: locale.home),
            BottomNavigationBarItem(
                icon: Icon(state.selectedIndex == 1? Icons.location_on : Icons.location_on_outlined),
                label: locale.map),
                //fake bottom nav bar icon
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined,color: Colors.transparent,),
              label: "",
            ),
            BottomNavigationBarItem(
                icon: Icon(state.selectedIndex == 3? Icons.favorite : Icons.favorite_border_outlined),
                label: locale.love),
            BottomNavigationBarItem(
                icon: Icon(state.selectedIndex == 4? Icons.person: Icons.person_2_outlined),
                label: locale.profile),
          ]),
          floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: BorderSide(
                color: AppColors.white,
                width: 4,
              )
            ),
            onPressed: (){
              mainCubit.doAction(GoToEventManagementScreen());
            },
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }
}
