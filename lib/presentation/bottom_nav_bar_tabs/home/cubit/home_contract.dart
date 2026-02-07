import 'package:evently/core/utils/resources.dart';
import 'package:evently/data/models/category_dm.dart';
import 'package:evently/data/models/event_dm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeState {
  Resources<User> userData;
  Resources<List<EventDM>> events;
  late List<CategoryDM> categoriesList = [
    CategoryDM(
      id: -1,
      nameEN: "All",
      nameAR: "الكل",
      image: "",
      icon: Icons.explore,
    ),
    CategoryDM(
      id: 0,
      nameEN: "Sport",
      nameAR: "الرياضة",
      image: 'assets/events/Sport.png',
      icon: Icons.sports_soccer,
    ),
    CategoryDM(
      id: 1,
      nameAR: "عيد ميلاد",
      nameEN: 'Birthday',
      image: 'assets/events/birthday.png',
      icon: Icons.cake,
    ),
    CategoryDM(
      id: 2,
      nameAR: "اجتماع",
      nameEN: "Meeting",
      image: 'assets/events/meeting.png',
      icon: Icons.people,
    ),
    CategoryDM(
      id: 3,
      nameAR: "ألعاب",
      nameEN: "Gaming",
      image: 'assets/events/gaming.png',
      icon: Icons.videogame_asset,
    ),
    CategoryDM(
      id: 4,
      nameAR: "تناول الطعام",
      nameEN: "Eating",
      image: 'assets/events/eating.png',
      icon: Icons.fastfood,
    ),
    CategoryDM(
      id: 5,
      nameAR: "عطلة",
      nameEN: "Holiday",
      image: 'assets/events/holiday.png',
      icon: Icons.beach_access,
    ),
    CategoryDM(
      id: 6,
      nameAR: "معرض",
      nameEN: "Exhibition",
      image: 'assets/events/exhibition.png',
      icon: Icons.museum,
    ),
    CategoryDM(
      id: 7,
      nameAR: "ورشة عمل",
      nameEN: "Workshop",
      image: 'assets/events/workshop.png',
      icon: Icons.work,
    ),
    CategoryDM(
      id: 8,
      nameAR: "نادي الكتاب",
      nameEN: "Book Club",
      image: 'assets/events/book_club.png',
      icon: Icons.menu_book,
    ),
  ];
  int selectedCategoryIndex;

  HomeState({
    this.userData = const Resources.initial(), this.selectedCategoryIndex = 0,
    this.events = const Resources.initial(),
  });

  HomeState copyWith({
    Resources<User>? userData,
    int? selectedCategoryIndex,
    Resources<List<EventDM>>? events,
  }) {
    return HomeState(
      userData: userData ?? this.userData,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      events: events ?? this.events
    );
  }
}

sealed class HomeAction {}

class GetUserData extends HomeAction {}
class ChooseSelectedCategory extends HomeAction {
  int index;
  ChooseSelectedCategory(this.index);
}
class GetEvents extends HomeAction {
  int categoryID;
  GetEvents(this.categoryID);
}


sealed class HomeNavigation {}
