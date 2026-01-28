import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/data/models/category_dm.dart';


class EventDM{
  String id;
  String title;
  String description;
  CategoryDM category;
  int date;
  int time;
  List<String>? favUsers;
  String address;
  double latitude;
  double longitude;


  EventDM({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.favUsers
});

  factory EventDM.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data()??<String,dynamic>{};
    return EventDM(
      id: data["id"],
      title: data["title"],
      category: CategoryDM.categoriesList[data["categoryID"]],
      date: data["date"],
      description: data["description"],
      time: data["time"],
      address: data["address"],
      favUsers: ((data["favUsers"]??[]) as List<dynamic>).map((e)=> e.toString()).toList(),
      latitude: data["latitude"],
      longitude: data["longitude"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id" : id,
      "title" : title,
      "categoryID" : category.id,
      "date" : date,
      "description" : description,
      "time" : time,
      "address" : address,
      "favUsers" : favUsers??[],
      "latitude" : latitude,
      "longitude" : longitude,
    };
  }

}