import 'package:evently/core/utils/app_exeptions.dart';
import 'package:evently/data/datasource/contract/local_datasource.dart';
import 'package:evently/data/network/results.dart';
import 'package:evently/data/network/safe_call.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: LocalDatasource)
class LocalDatasourceImpl implements LocalDatasource{

  SharedPreferences sharedPreferences;

  LocalDatasourceImpl(this.sharedPreferences);



  @override
  Future<Results<void>> saveInSharedPreferences(String key, dynamic value) async{
    return safeCall(()async{
      if(value is String)
        {
          await sharedPreferences.setString(key, value);
        }
      else if(value is int)
        {
          await sharedPreferences.setInt(key, value);
        }
      else if(value is bool)
        {
          await sharedPreferences.setBool(key, value);
        }
      else if(value is double)
        {
          await sharedPreferences.setDouble(key, value);
        }
      return Success();
    });
  }


  @override
  Future<Results<dynamic>> getFromSharedPreferences(String key) {
    return safeCall(()async{
      var response = sharedPreferences.get(key);
      if(response != null) {
        return Success(data: sharedPreferences.get(key), message: "data found");
      }
      else
        {
          return Failure(exception : SharedPreferencesException(), message: "no data found");
        }
    });
  }



}