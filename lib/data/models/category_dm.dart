import 'package:evently/core/constant/app_assets.dart';
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
        image: AppImages.sport,
        icon: Icons.sports_soccer,
      ),
      CategoryDM(
        id: 1,
        nameAR: "عيد ميلاد",
        nameEN: 'Birthday',
        image: AppImages.birthday,
        icon: Icons.cake,
      ),
      CategoryDM(
        id: 2,
        nameAR: "اجتماع",
        nameEN: "Meeting",
        image: AppImages.meeting,
        icon: Icons.people,
      ),
      CategoryDM(
        id: 3,
        nameAR: "ألعاب",
        nameEN: "Gaming",
        image: AppImages.gaming,
        icon: Icons.videogame_asset,
      ),
      CategoryDM(
        id: 4,
        nameAR: "تناول الطعام",
        nameEN: "Eating",
        image: AppImages.eating,
        icon: Icons.fastfood,
      ),
      CategoryDM(
        id: 5,
        nameAR: "عطلة",
        nameEN: "Holiday",
        image: AppImages.holiday,
        icon: Icons.beach_access,
      ),
      CategoryDM(
        id: 6,
        nameAR: "معرض",
        nameEN: "Exhibition",
        image: AppImages.exhibition,
        icon: Icons.museum,
      ),
      CategoryDM(
        id: 7,
        nameAR: "ورشة عمل",
        nameEN: "Workshop",
        image: AppImages.workshop,
        icon: Icons.work,
      ),
      CategoryDM(
        id: 8,
        nameAR: "نادي الكتاب",
        nameEN: "Book Club",
        image: AppImages.bookClub,
        icon: Icons.menu_book,
      ),
  ];
}