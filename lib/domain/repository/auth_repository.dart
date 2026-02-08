import 'package:evently/data/network/results.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract interface class AuthRepository {
  Future<Results<User?>> login({required String email, required String password});
  Future<Results<void>> logout();
  Future<Results<UserCredential>> register({required String name, required String email, required String password});
  Future<void> sendVerificationEmail();
  Future<Results<User>> chackVerificationUser();
  Future<Results<void>> sendPasswordResetEmail(String email);
  Future<Results<void>> updateUserImage(String? imageURL, BuildContext context);
  Future<Results<User>> getUserData();


}