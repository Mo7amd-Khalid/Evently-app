import 'package:evently/domain/repository/evently_repo.dart';
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



}