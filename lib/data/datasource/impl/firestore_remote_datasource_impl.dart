import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/core/constant/app_constant.dart';
import 'package:evently/core/l10n/generated/app_localizations.dart';
import 'package:evently/core/utils/date_extention.dart';
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
  final CollectionReference<EventDM> _eventFirebase;

  FirestoreRemoteDatasourceImpl(this._firestore, this._eventFirebase);

  @override
  Future<Results<void>> storeUserDataToUserCollection(User user) async {
    return safeCall(() async {
      await _firestore
          .collection(KeysConstant.userCollection)
          .doc(user.uid)
          .set({KeysConstant.emailKey: user.email});
      return Success();
    });
  }

  @override
  Future<Results<QuerySnapshot<Map<String, dynamic>>>> getUsers() async {
    return safeCall(() async {
      var response =
          await _firestore.collection(KeysConstant.userCollection).get();
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
      if (event.address.isEmpty ||
          event.longitude == -1 ||
          event.latitude == -1) {
        errorMessage += "\n${AppLocalizations.of(context)!.locationRequired}";
      }
      if (event.date == -1) {
        errorMessage += "\n${AppLocalizations.of(context)!.dateRequired}";
      }
      if (event.time == -1) {
        errorMessage += "\n${AppLocalizations.of(context)!.timeRequired}";
      }
      if (errorMessage.isEmpty) {
        var data = _eventFirebase.doc();
        event.id = data.id;
        print(event.favUsers);
        await data.set(event);
        return Success(message: AppLocalizations.of(context)!.eventAddedSuccessfully);
      } else {
        return Failure(exception: Exception(), message: errorMessage);
      }
    });
  }

  @override
  Future<Results<void>> deleteEvent(String eventID, BuildContext context) async {
    return safeCall(() async {
      await _eventFirebase.doc(eventID).delete();
      return Success(message: AppLocalizations.of(context)!.eventDeletedSuccessfully);
    });
  }

  @override
  Future<Results<List<EventDM>>> getEvents(int categoryID) async {
    return safeCall(() async {
      QuerySnapshot<EventDM> response;
      int date = DateTime.now().dateOnly.millisecondsSinceEpoch;
      if (categoryID == -1) {
        response =
            await _eventFirebase
                .where("date", isGreaterThanOrEqualTo: date)
                .get();
      } else {
        response =
            await _eventFirebase
                .where("categoryID", isEqualTo: categoryID)
                .where("date", isGreaterThanOrEqualTo: date)
                .get();
      }

      return Success(data: response.docs.map((e) => e.data()).toList());
    });
  }

  @override
  Future<Results<void>> updateEvent(EventDM event, BuildContext context) async {
    return safeCall(() async {
      await _eventFirebase.doc(event.id).update(event.toFirestore());
      return Success(
        message: AppLocalizations.of(context)!.eventUpdatedSuccessfully,
      );
    });
  }

  @override
  Future<Results<List<EventDM>>> updateFavUserList(
    String userID,
    EventDM event,
  ) {
    return safeCall(() async {
      if (event.favUsers!.contains(userID)) {
        (event.favUsers ?? []).remove(userID);
      } else {
        (event.favUsers ?? []).add(userID);
      }
      await _eventFirebase.doc(event.id).update(event.toFirestore());
      int date = DateTime.now().dateOnly.millisecondsSinceEpoch;
      var events =
          await _eventFirebase.where("date", isGreaterThan: date).get();
      return Success(
        data: events.docs.map((event) => event.data()).toList(),
      );
    });
  }

  @override
  Results<Stream<QuerySnapshot<EventDM>>> getMyFavList(String userID) {
    int date = DateTime.now().dateOnly.millisecondsSinceEpoch;
    Stream<QuerySnapshot<EventDM>> events = _eventFirebase
        .where("date", isGreaterThan: date)
        .where("favUsers", arrayContains: userID)
        .snapshots();
    return Success(data: events);
  }
}
