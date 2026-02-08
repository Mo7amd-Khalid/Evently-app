import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/data/models/event_dm.dart';
import 'package:evently/data/network/results.dart';
import 'package:evently/domain/repository/evently_repo.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class EventlyUseCase {

  final EventlyRepository _repoImpl;
  EventlyUseCase(this._repoImpl);

  Future<void> saveDataInSharedPreferences(String key, dynamic value) async{
    _repoImpl.setValueInSharedPreferences(key, value);
  }

  Future<dynamic> getDataFromSharedPreferences(String key) async{
    _repoImpl.getValueFromSharedPreferences(key);
  }

  Future<Results<void>> addEvent(EventDM event, BuildContext context) async{
    return _repoImpl.addEvent(event, context);
  }


  Future<Results<List<EventDM>>> getEvents(int categoryID) async{
    return _repoImpl.getEvents(categoryID);
  }

  Future<Results<void>> deleteEvent(String eventID, BuildContext context) async{
    return _repoImpl.deleteEvent(eventID, context);
  }

  Future<Results<void>> updateEvent(EventDM event, BuildContext context) async{
    return _repoImpl.updateEvent(event, context);
  }

  Future<Results<List<EventDM>>> updateFavUserList(String userID, EventDM event)async{
    return _repoImpl.updateFavUserList(userID, event);
  }

  Results<Stream<QuerySnapshot<EventDM>>> getMyFavList(String userID){
    return _repoImpl.getMyFavList(userID);
  }

}