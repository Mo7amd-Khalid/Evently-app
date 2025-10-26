import 'package:evently/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class CategoryDM{
  
  int id;
  String nameEN;
  String nameAR;
  String image;
  IconData icon;


  CategoryDM({
    required this.id,
    required this.nameEN,
    required this.nameAR,
    required this.image,
    required this.icon,
});


  static List<CategoryDM> categoriesList = [

      CategoryDM(
        id: 0,
        nameEN:"Sport",
        nameAR:"الرياضة",
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
}