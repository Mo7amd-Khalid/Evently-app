import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/data/network/results.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class FirestoreRemoteDatasource {

  Future<Results<void>> storeUserDataToUserCollection(User user);
  Future<Results<QuerySnapshot<Map<String, dynamic>>>> getUsers();
}