import 'package:evently/data/datasource/contract/local_datasource.dart';
import 'package:evently/data/network/results.dart';
import 'package:evently/domain/repository/evently_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: EventlyRepository)
class RepoImpl implements EventlyRepository{

  LocalDatasource localDatasource;
  RepoImpl(this.localDatasource);

  @override
  Future<Results<void>> setValueInSharedPreferences(String key, value) async{
    var response = await localDatasource.saveInSharedPreferences(key, value);
    switch (response) {

      case Success<void>():
        return Success(message: "data is stored successfully");
      case Failure<void>():
        return Failure(exception: response.exception, message: response.message);
    }
  }


  @override
  Future<Results<dynamic>> getValueFromSharedPreferences(String key) async{
    var response = await localDatasource.getFromSharedPreferences(key);
    switch (response) {

      case Success<dynamic>():
        return Success(data: response.data, message: response.message);
      case Failure<dynamic>():
        return Failure(exception: response.exception, message: response.message);
    }
  }


}