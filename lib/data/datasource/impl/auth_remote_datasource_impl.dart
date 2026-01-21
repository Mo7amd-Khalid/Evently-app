import 'package:evently/core/utils/app_exeptions.dart';
import 'package:evently/data/datasource/contract/auth_remote_datasource.dart';
import 'package:evently/data/network/results.dart';
import 'package:evently/data/network/safe_call.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRemoteDatasource)
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDatasourceImpl(this._firebaseAuth);

  @override
  Future<Results<User?>> login(String email, String password) {
    return safeCall(() async {
      var response = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success(data: response.user);
    });
  }

  @override
  Future<Results<void>> logout() {
    return safeCall(() async {
      await _firebaseAuth.signOut();
      return Success();
    });
  }

  @override
  Future<Results<UserCredential>> register({
    required String name,
    required String email,
    required String password,
  }) {
    return safeCall(() async {
      var response = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success(data: response);
    });
  }

  @override
  Future<void> sendVerificationEmail() async {
    await _firebaseAuth.currentUser!.sendEmailVerification();
  }

  @override
  Future<Results<User>> checkVerificationUser() {
    return safeCall(() async {
      await _firebaseAuth.currentUser!.reload();
      User user = _firebaseAuth.currentUser!;
      if (user.emailVerified) {
        return Success(data: user);
      } else {
        return Failure(
          exception: NotVerifiedEmailException(),
          message: NotVerifiedEmailException().message,
        );
      }
    });
  }

  @override
  Future<Results<void>> sendPasswordResetEmail(String email) async {
    return safeCall(() async {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return Success();
    });
  }
}
