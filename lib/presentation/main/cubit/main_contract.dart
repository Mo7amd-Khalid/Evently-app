import 'package:evently/presentation/bottom_nav_bar_tabs/map/map_screen.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/favorite/favorite.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/profile/profile.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/home/home.dart';
import 'package:flutter/material.dart';

class MainState {
  int selectedIndex;
  final List<Widget> bottomNavBarTabs = [
    HomeTabScreen(),
    MapScreen(),
    Center(child: Text("fake"),),
    FavoriteScreen(),
    ProfileScreen()
  ];

  MainState({this.selectedIndex = 0});

  MainState copyWith({int? selectedIndex}) {
    return MainState(selectedIndex: selectedIndex ?? this.selectedIndex);
  }
}

sealed class MainAction {}

class ChangeSelectedIndex extends MainAction {
  int index;

  ChangeSelectedIndex(this.index);
}

class GoToEventManagementScreen extends MainAction {}



sealed class MainNavigation {}

class NavigateToEventManagementScreen extends MainNavigation{}
