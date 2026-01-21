import 'package:evently/data/network/results.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class FirestoreRemoteDatasource {

  Future<Results<void>> storeUserDataToUserCollection(User user);
}