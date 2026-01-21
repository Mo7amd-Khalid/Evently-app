abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);
}

class NotVerifiedEmailException extends AppException {
  const NotVerifiedEmailException() : super("Email is not verified");
}


class InvalidCredentialsException extends AppException {
  const InvalidCredentialsException() : super("Invalid email or password");
}

class UserNotFoundException extends AppException {
  const UserNotFoundException() : super("User not found");
}

class NetworkException extends AppException {
  const NetworkException() : super("No internet connection");
}

class UnknownException extends AppException {
  const UnknownException() : super("Something went wrong, try again");
}

class SharedPreferencesException extends AppException {
  SharedPreferencesException() : super("Shared preferences error");
}

class RegisterException extends AppException {
  const RegisterException() : super("The email address is already in use by another account");
}

class TimeLimitException extends AppException {
  TimeLimitException() : super("Time limit exceeded");
}

class FormatCodeException extends AppException {
  FormatCodeException() : super("Format code error");
}

class PermissionDeniedException extends AppException {
  const PermissionDeniedException()
    : super("You don't have permission to perform this action");
}

class DocumentNotFoundException extends AppException {
  const DocumentNotFoundException() : super("Requested document was not found");
}

class AlreadyExistsException extends AppException {
  const AlreadyExistsException() : super("Document already exists");
}

class UnauthenticatedException extends AppException {
  const UnauthenticatedException() : super("User is not authenticated");
}

class DeadlineExceededException extends AppException {
  const DeadlineExceededException() : super("Request timed out, try again");
}

class ResourceExhaustedException extends AppException {
  const ResourceExhaustedException()
    : super("Quota exceeded or resource exhausted");
}

class UnavailableException extends AppException {
  const UnavailableException() : super("Service is currently unavailable");
}

class CancelledException extends AppException {
  const CancelledException() : super("Operation was cancelled");
}

class InvalidArgumentException extends AppException {
  const InvalidArgumentException() : super("Invalid data was provided");
}

class DataLossException extends AppException {
  const DataLossException() : super("Data loss occurred");
}

class UnknownFirestoreException extends AppException {
  const UnknownFirestoreException()
    : super("Something went wrong, please try again");
}
