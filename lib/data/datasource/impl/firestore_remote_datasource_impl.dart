import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/core/constant/app_constant.dart';
import 'package:evently/data/datasource/contract/firestore_remote_datasource.dart';
import 'package:evently/data/network/results.dart';
import 'package:evently/data/network/safe_call.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FirestoreRemoteDatasource)
class FirestoreRemoteDatasourceImpl implements FirestoreRemoteDatasource{

  final FirebaseFirestore _firestore;
  FirestoreRemoteDatasourceImpl(this._firestore);

  @override
  Future<Results<void>> storeUserDataToUserCollection(User user) async{
    return safeCall(()async{
      await _firestore.collection(AppConstant.userCollection).doc(user.uid).set({
        AppConstant.emailKey : user.email,
      });
      return Success();
    });
  }

  @override
  Future<Results<QuerySnapshot<Map<String, dynamic>>>> getUsers() async{
    return safeCall(()async{
      var response = await _firestore.collection(AppConstant.userCollection).get();
      return Success(data: response);
    });
  }

}