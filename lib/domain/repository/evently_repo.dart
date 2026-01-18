import 'package:evently/data/network/results.dart';

abstract interface class EventlyRepository{
  Future<Results<void>> setValueInSharedPreferences(String key, dynamic value);
  Future<Results<dynamic>> getValueFromSharedPreferences(String key);
}