import 'package:evently/data/network/results.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDatasource {
  Future<Results<User?>> login(String email, String password);
  Future<Results<void>> logout();
  Future<Results<UserCredential>> register({required String name, required String email, required String password});
  Future<void> sendVerificationEmail(UserCredential user);
}