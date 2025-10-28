import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/l10n/generated/app_localizations.dart';
import 'package:evently/ui/home/bottom_nav_bar_tabs/favorite.dart';
import 'package:evently/ui/home/bottom_nav_bar_tabs/map.dart';
import 'package:flutter/material.dart';
import 'bottom_nav_bar_tabs/event_management_screen/event_management_screen.dart';
import 'bottom_nav_bar_tabs/home.dart';
import 'bottom_nav_bar_tabs/profile.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});
  static const String routeName = "Home Screen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> bottomNavBarTabs = [
    HomeTabScreen(),
    MapScreen(),
    Center(child: Text("fake"),),
    FavoriteScreen(),
    ProfileScreen()
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: bottomNavBarTabs[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          if(index == 2)
            {
              Navigator.pushNamed(context, EventManagementScreen.routeName);
            }
          else
            {
              setState(() {
                selectedIndex = index;
              });
            }
        },
        currentIndex: selectedIndex,
          type: BottomNavigationBarType.fixed,
          items: [
        BottomNavigationBarItem(
            icon: Icon(selectedIndex == 0? Icons.home : Icons.home_outlined),
            label: locale.home),
        BottomNavigationBarItem(
            icon: Icon(selectedIndex == 1? Icons.location_on : Icons.location_on_outlined),
            label: locale.map),
            //fake bottom nav bar icon
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined,color: Colors.transparent,),
          label: "",
        ),
        BottomNavigationBarItem(
            icon: Icon(selectedIndex == 3? Icons.favorite : Icons.favorite_border_outlined),
            label: locale.love),
        BottomNavigationBarItem(
            icon: Icon(selectedIndex == 4? Icons.person: Icons.person_2_outlined),
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
          Navigator.pushNamed(context, EventManagementScreen.routeName);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
