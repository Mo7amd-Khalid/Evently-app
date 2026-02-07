import 'package:evently/data/datasource/contract/firestore_remote_datasource.dart';
import 'package:evently/data/datasource/contract/local_datasource.dart';
import 'package:evently/data/models/event_dm.dart';
import 'package:evently/data/network/results.dart';
import 'package:evently/domain/repository/evently_repo.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: EventlyRepository)
class RepoImpl implements EventlyRepository {
  final LocalDatasource _localDatasource;
  final FirestoreRemoteDatasource _remoteDatasource;

  RepoImpl(this._localDatasource, this._remoteDatasource);

  @override
  Future<Results<void>> setValueInSharedPreferences(String key, value) async {
    var response = await _localDatasource.saveInSharedPreferences(key, value);
    switch (response) {
      case Success<void>():
        return Success(message: "data is stored successfully");
      case Failure<void>():
        return Failure(
          exception: response.exception,
          message: response.message,
        );
    }
  }

  @override
  Future<Results<dynamic>> getValueFromSharedPreferences(String key) async {
    var response = await _localDatasource.getFromSharedPreferences(key);
    switch (response) {
      case Success<dynamic>():
        return Success(data: response.data, message: response.message);
      case Failure<dynamic>():
        return Failure(
          exception: response.exception,
          message: response.message,
        );
    }
  }

  @override
  Future<Results<void>> addEvent(EventDM event, BuildContext context) async {
    var response = await _remoteDatasource.addEvent(event, context);
    switch (response) {
      case Success<void>():
        return Success(message: response.message);
      case Failure<void>():
        return Failure(
          exception: response.exception,
          message: response.message,
        );
    }
  }

  @override
  Future<Results<List<EventDM>>> getEvents(int categoryID) async {
    var response = await _remoteDatasource.getEvents(categoryID);
    switch (response) {
      case Success<List<EventDM>>():
        return Success(data: response.data);
      case Failure<List<EventDM>>():
        return Failure(
          exception: response.exception,
          message: response.message,
        );
    }
  }

  @override
  Future<Results<void>> deleteEvent(String eventID) async {
    var response = await _remoteDatasource.deleteEvent(eventID);
    switch (response) {
      case Success<void>():
        return Success(message: response.message);
      case Failure<void>():
        return Failure(
          exception: response.exception,
          message: response.message,
        );
    }
  }

  @override
  Future<Results<void>> updateEvent(EventDM event, BuildContext context) async {
    var response = await _remoteDatasource.updateEvent(event, context);
    switch (response) {
      case Success<void>():
        return Success(message: response.message);
      case Failure<void>():
        return Failure(exception: response.exception, message: response.message);
    }
  }
}
