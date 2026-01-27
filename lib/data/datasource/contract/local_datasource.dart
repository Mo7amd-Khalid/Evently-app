import 'package:evently/data/network/results.dart';

abstract interface class LocalDatasource {
  Future<Results<void>> saveInSharedPreferences(String key, dynamic value);

  Future<Results<dynamic>> getFromSharedPreferences(String key);
}

