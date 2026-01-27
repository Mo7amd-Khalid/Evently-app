import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/core/constant/app_constant.dart';
import 'package:evently/core/l10n/generated/app_localizations.dart';
import 'package:evently/data/datasource/contract/firestore_remote_datasource.dart';
import 'package:evently/data/models/event_dm.dart';
import 'package:evently/data/network/results.dart';
import 'package:evently/data/network/safe_call.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FirestoreRemoteDatasource)
class FirestoreRemoteDatasourceImpl implements FirestoreRemoteDatasource {

  final FirebaseFirestore _firestore;

  FirestoreRemoteDatasourceImpl(this._firestore);

  @override
  Future<Results<void>> storeUserDataToUserCollection(User user) async {
    return safeCall(() async {
      await _firestore.collection(KeysConstant.userCollection).doc(user.uid).set(
          {
            KeysConstant.emailKey: user.email,
          });
      return Success();
    });
  }

  @override
  Future<Results<QuerySnapshot<Map<String, dynamic>>>> getUsers() async {
    return safeCall(() async {
      var response = await _firestore
          .collection(KeysConstant.userCollection)
          .get();
      return Success(data: response);
    });
  }

  @override
  Future<Results<void>> addEvent(EventDM event, BuildContext context) async {
    return safeCall(() async {
      String errorMessage = "";
      if (event.title.isEmpty) {
        errorMessage += "\n${AppLocalizations.of(context)!.titleRequired}";
      }
      if (event.description.isEmpty) {
        errorMessage +=
        "\n${AppLocalizations.of(context)!.descriptionRequired}";
      }
      if (event.address.isEmpty) {
        errorMessage += "\n${AppLocalizations.of(context)!.locationRequired}";
      }
      if (errorMessage.isEmpty) {
        var data = _firestore.collection(KeysConstant.eventsCollection).doc();
        event.id = data.id;
        await data.set(event.toFirestore());
        return Success(message: "Event Added Successfully");
      }
      else {
        return Failure(exception: Exception(), message: errorMessage);
      }
    });
  }



}