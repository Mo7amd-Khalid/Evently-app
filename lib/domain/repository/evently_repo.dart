import 'package:evently/data/models/event_dm.dart';
import 'package:evently/data/network/results.dart';
import 'package:flutter/material.dart';

abstract interface class EventlyRepository{
  Future<Results<void>> setValueInSharedPreferences(String key, dynamic value);
  Future<Results<dynamic>> getValueFromSharedPreferences(String key);
  Future<Results<void>> addEvent(EventDM event, BuildContext context);
  Future<Results<List<EventDM>>> getEvents(int categoryID);
  Future<Results<void>> deleteEvent(String eventID);
  Future<Results<void>> updateEvent(EventDM event,BuildContext context);

}