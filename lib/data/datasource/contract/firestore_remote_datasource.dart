import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/data/models/event_dm.dart';
import 'package:evently/data/network/results.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract interface class FirestoreRemoteDatasource {

  Future<Results<void>> storeUserDataToUserCollection(User user);
  Future<Results<QuerySnapshot<Map<String, dynamic>>>> getUsers();
  Future<Results<void>> addEvent(EventDM event, BuildContext context);
  Future<Results<void>> deleteEvent(String eventID);
  Future<Results<List<EventDM>>> getEvents(int categoryID);
  Future<Results<void>> updateEvent(EventDM event, BuildContext context);

}