import 'package:evently/core/utils/app_exeptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AppExceptionMapper {
  static AppException filterFirebaseAuthException(FirebaseAuthException exception){

    switch (exception.code) {
      case 'user-not-found':
        return const UserNotFoundException();

      case 'wrong-password':
      case 'invalid-credential':
        return const InvalidCredentialsException();

      case 'network-request-failed':
        return const NetworkException();
      case 'email-already-in-use':
        return const RegisterException();

      default:
        return UnknownException();
    }

  }

  static AppException filterFirestoreException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return const PermissionDeniedException();

      case 'not-found':
        return const DocumentNotFoundException();

      case 'already-exists':
        return const AlreadyExistsException();

      case 'unauthenticated':
        return const UnauthenticatedException();

      case 'deadline-exceeded':
        return const DeadlineExceededException();

      case 'resource-exhausted':
        return const ResourceExhaustedException();

      case 'unavailable':
        return const UnavailableException();

      case 'cancelled':
        return const CancelledException();

      case 'invalid-argument':
        return const InvalidArgumentException();

      case 'data-loss':
        return const DataLossException();

      default:
        return const UnknownFirestoreException();
    }
  }

}

