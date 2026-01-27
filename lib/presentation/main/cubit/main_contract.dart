import 'package:evently/ui/home/bottom_nav_bar_tabs/favorite.dart';
import 'package:evently/presentation/bottom_nav_bar_tabs/home/home.dart';
import 'package:evently/ui/home/bottom_nav_bar_tabs/map.dart';
import 'package:evently/ui/home/bottom_nav_bar_tabs/profile.dart';
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
