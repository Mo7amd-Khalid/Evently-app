
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/core/di/di.dart';
import 'package:evently/data/models/event_dm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ProvideFirebase {

  @lazySingleton
  FirebaseAuth firebaseAuth() => FirebaseAuth.instance;


  @lazySingleton
  FirebaseFirestore firebaseFirestore() => FirebaseFirestore.instance;

  @lazySingleton
  CollectionReference<EventDM> getCollection(){
    return getIt<FirebaseFirestore>().collection("events").withConverter(
        fromFirestore: EventDM.fromFirestore,
        toFirestore: (EventDM event,option) => event.toFirestore());
  }

}