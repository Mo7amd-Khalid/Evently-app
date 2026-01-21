import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/core/constant/app_constant.dart';
import 'package:evently/core/utils/app_exeptions.dart';
import 'package:evently/data/datasource/contract/auth_remote_datasource.dart';
import 'package:evently/data/datasource/contract/firestore_remote_datasource.dart';
import 'package:evently/data/network/results.dart';
import 'package:evently/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
class AuthRepoImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;
  final FirestoreRemoteDatasource _firestoreRemoteDatasource;

  AuthRepoImpl(this._authRemoteDatasource, this._firestoreRemoteDatasource);

  @override
  Future<Results<User?>> login({
    required String email,
    required String password,
  }) async
  {
    var response = await _authRemoteDatasource.login(email, password);
    switch (response) {
      case Success<User?>():
        {
          if (response.data!.emailVerified) {
            return Success(data: response.data, message: response.message);
          } else {
            response.data!.delete();
            return Failure(
              exception: InvalidCredentialsException(),
              message: InvalidCredentialsException().message,
            );
          }
        }
      case Failure<User?>():
        return Failure(
          exception: response.exception,
          message: response.message,
        );
    }
  }

  @override
  Future<Results<void>> logout() async {
    var response = await _authRemoteDatasource.logout();
    switch (response) {
      case Success<void>():
        return Success(message: "Logout success");
      case Failure<void>():
        return Failure(
          exception: response.exception,
          message: response.message,
        );
    }
  }

  @override
  Future<Results<UserCredential>> register({
    required String name,
    required String email,
    required String password,
  }) async
  {
    var response = await _authRemoteDatasource.register(
      name: name,
      email: email,
      password: password,
    );
    switch (response) {
      case Success<UserCredential>():
        {
          await sendVerificationEmail();
          await response.data?.user?.updateDisplayName(name);
          return Success(data: response.data, message: response.message);
        }
      case Failure<UserCredential>():
        return Failure(
          exception: response.exception,
          message: response.message,
        );
    }
  }

  @override
  Future<void> sendVerificationEmail() async {
    return await _authRemoteDatasource.sendVerificationEmail();
  }

  @override
  Future<Results<User>> chackVerificationUser() async{
    var response = await _authRemoteDatasource.checkVerificationUser();
    switch (response) {
      case Success<User>():{
        await _firestoreRemoteDatasource.storeUserDataToUserCollection(response.data!);
        return Success(data: response.data);
      }
      case Failure<User>():
        return Failure(exception: response.exception, message: response.message);
    }
  }

  @override
  Future<Results<void>> sendPasswordResetEmail(String email) async{
    var response = await _firestoreRemoteDatasource.getUsers();
    switch (response) {
      case Success<QuerySnapshot<Map<String, dynamic>>>():
        {
          for(QueryDocumentSnapshot document in response.data!.docs)
            {
              if(document[AppConstant.emailKey] == email)
                {
                  print(email);
                  await _authRemoteDatasource.sendPasswordResetEmail(email);
                  return Success();
                }
            }
          return Failure(exception: UserNotFoundException(), message: UserNotFoundException().message);
        }
      case Failure<QuerySnapshot<Map<String, dynamic>>>():
        {
          return Failure(exception: response.exception, message: response.message);
        }
    }
  }


}
