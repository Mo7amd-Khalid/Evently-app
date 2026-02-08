import 'package:evently/core/utils/resources.dart';
import 'package:evently/data/models/category_dm.dart';
import 'package:evently/data/models/event_dm.dart';
import 'package:flutter/material.dart';

class EventState {
  late List<CategoryDM> categoriesList = [
    CategoryDM(
      id: 0,
      nameEN: "Sport",
      nameAR: "الرياضة",
      image: 'assets/categories/Sport.png',
      icon: Icons.sports_soccer,
    ),
    CategoryDM(
      id: 1,
      nameAR: "عيد ميلاد",
      nameEN: 'Birthday',
      image: 'assets/categories/birthday.png',
      icon: Icons.cake,
    ),
    CategoryDM(
      id: 2,
      nameAR: "اجتماع",
      nameEN: "Meeting",
      image: 'assets/categories/meeting.png',
      icon: Icons.people,
    ),
    CategoryDM(
      id: 3,
      nameAR: "ألعاب",
      nameEN: "Gaming",
      image: 'assets/categories/gaming.png',
      icon: Icons.videogame_asset,
    ),
    CategoryDM(
      id: 4,
      nameAR: "تناول الطعام",
      nameEN: "Eating",
      image: 'assets/categories/eating.png',
      icon: Icons.fastfood,
    ),
    CategoryDM(
      id: 5,
      nameAR: "عطلة",
      nameEN: "Holiday",
      image: 'assets/categories/holiday.png',
      icon: Icons.beach_access,
    ),
    CategoryDM(
      id: 6,
      nameAR: "معرض",
      nameEN: "Exhibition",
      image: 'assets/categories/exhibition.png',
      icon: Icons.museum,
    ),
    CategoryDM(
      id: 7,
      nameAR: "ورشة عمل",
      nameEN: "Workshop",
      image: 'assets/categories/workshop.png',
      icon: Icons.work,
    ),
    CategoryDM(
      id: 8,
      nameAR: "نادي الكتاب",
      nameEN: "Book Club",
      image: 'assets/categories/book_club.png',
      icon: Icons.menu_book,
    ),
  ];
  int selectedCategoryIndex;
  Resources<String> statusMessage;

  EventState({
    this.selectedCategoryIndex = 0,
    this.statusMessage = const Resources.initial(),
  });

  EventState copyWith({
    int? selectedCategoryIndex,
    Resources<String>? statusMessage,
  }) {
    return EventState(
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }
}

sealed class EventAction {}

class ChangeSelectedCategory extends EventAction {
  int index;

  ChangeSelectedCategory(this.index);
}

class GoToMapScreen extends EventAction {}

class AddEvent extends EventAction {
  EventDM event;
  BuildContext context;

  AddEvent(this.event, this.context);
}
class UpdateEvent extends EventAction {
  EventDM event;
  BuildContext context;

  UpdateEvent(this.event, this.context);
}

class DeleteEvent extends EventAction{
  String eventID;
  BuildContext context;

  DeleteEvent(this.eventID, this.context);
}

class GoToHomeScreen extends EventAction{}



sealed class EventNavigation {}

class NavigateToMapScreen extends EventNavigation {}

class NavigateToHomeScreen extends EventNavigation {}


class ShowLoadingDialog extends EventNavigation {}

class ShowInfoDialog extends EventNavigation {
  String message;
  ShowInfoDialog(this.message);
}
class ShowErrorDialog extends EventNavigation {
  String message;
  ShowErrorDialog(this.message);
}
