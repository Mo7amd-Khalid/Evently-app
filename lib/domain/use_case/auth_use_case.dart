import 'package:evently/data/network/results.dart';
import 'package:evently/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthUseCase {

  final AuthRepository _authRepository;
  AuthUseCase(this._authRepository);

  Future<Results<User?>> login({required String email, required String password}){
    return _authRepository.login(email: email, password: password);
  }

  Future<Results<void>> logout(){
    return _authRepository.logout();
  }

  Future<Results<UserCredential>> register({required String name, required String email, required String password}){
    return _authRepository.register(name: name, email: email, password: password);
  }


  Future<void> sendVerificationEmail(){
    return _authRepository.sendVerificationEmail();
  }

  Future<Results<User>> checkVerificationUser(){
    return _authRepository.chackVerificationUser();
  }

  Future<Results<void>> sendPasswordResetEmail(String email){
    return _authRepository.sendPasswordResetEmail(email);
  }

  Future<Results<User>> getUserData(){
    return _authRepository.getUserData();
  }

}