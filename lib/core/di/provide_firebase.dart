
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/core/constant/app_constant.dart';
import 'package:evently/data/models/event_dm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ProvideFirebase {

  @lazySingleton
  FirebaseAuth firebaseAuth() => FirebaseAuth.instance;


  @lazySingleton
  FirebaseFirestore firebaseFirestore() => FirebaseFirestore.instance;


  CollectionReference<EventDM> eventFirebase() => FirebaseFirestore.instance.collection(KeysConstant.eventsCollection).withConverter(
      fromFirestore: EventDM.fromFirestore,
      toFirestore: (EventDM event,option) => event.toFirestore());
}