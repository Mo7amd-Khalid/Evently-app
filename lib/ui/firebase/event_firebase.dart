import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/modules/event_dm.dart';
import 'package:evently/ui/firebase/firebase_auth_services.dart';
import 'package:evently/ui/wigdets/date_extention.dart';

class EventManagementFirebase {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static CollectionReference<EventDM> getCollection(){

   return firestore.collection("events").withConverter(
        fromFirestore: EventDM.fromFirestore,
        toFirestore: (EventDM event,option) => event.toFirestore());
  }

  static Future<void> addEvent(EventDM event) async{
    CollectionReference<EventDM> collection = getCollection();
    var data = collection.doc();
    event.id = data.id;
    await data.set(event);
  }

  static Stream<QuerySnapshot<EventDM>> getEventsData(int categoryID)
  {
    CollectionReference<EventDM> collection = getCollection();
    Stream<QuerySnapshot<EventDM>> data;
    int date = DateTime.now().dateOnly.millisecondsSinceEpoch;
    if(categoryID == -1)
      {
        data = collection
            .where("date" , isGreaterThanOrEqualTo: date)
            .snapshots();
      }
    else
      {
        data = collection
            .where("categoryID" ,isEqualTo: categoryID)
            .where("date" , isGreaterThanOrEqualTo: date)
            .snapshots();
      }
    print(categoryID);
    return data;
  }

  static Future<void> addEventToFav(EventDM event)async
  {
    var collection = getCollection();
    if(event.favUsers!.contains(FirebaseAuthServices.getUserData()!.uid))
      {
        event.favUsers!.remove(FirebaseAuthServices.getUserData()!.uid);
      }
    else
      {
        event.favUsers!.add(FirebaseAuthServices.getUserData()!.uid);
      }
    await collection.doc(event.id).update(event.toFirestore());

  }

  static Future<void> updateEvent(EventDM event)async
  {
    var collection = getCollection();
    await collection.doc(event.id).update(event.toFirestore());
  }

  static Stream<QuerySnapshot<EventDM>> getEventsFav(String uid)
  {
    CollectionReference<EventDM> collection = getCollection();
    Stream<QuerySnapshot<EventDM>> data;
    int date = DateTime.now().dateOnly.millisecondsSinceEpoch;
    data = collection
        .where("favUsers" ,arrayContains: uid)
        .where("date" , isGreaterThanOrEqualTo: date)
        .snapshots();
    return data;
  }

  static Future<void> deleteEvent(String eventID) async
  {
    var collection = getCollection();
    await collection.doc(eventID).delete();
  }
}
