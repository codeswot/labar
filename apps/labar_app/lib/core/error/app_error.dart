import 'package:equatable/equatable.dart';

/// Base class for all application errors
abstract class AppError extends Equatable {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppError({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, originalError];

  @override
  String toString() =>
      'AppError: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network-related errors
class NetworkError extends AppError {
  const NetworkError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory NetworkError.noConnection() => const NetworkError(
        message: 'No internet connection. Please check your network.',
        code: 'NO_CONNECTION',
      );

  factory NetworkError.timeout() => const NetworkError(
        message: 'Request timed out. Please try again.',
        code: 'TIMEOUT',
      );

  factory NetworkError.serverError() => const NetworkError(
        message: 'Server error. Please try again later.',
        code: 'SERVER_ERROR',
      );
}

/// Authentication-related errors
class AuthError extends AppError {
  const AuthError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory AuthError.invalidCredentials() => const AuthError(
        message: 'Invalid email or password.',
        code: 'INVALID_CREDENTIALS',
      );

  factory AuthError.userNotFound() => const AuthError(
        message: 'User not found.',
        code: 'USER_NOT_FOUND',
      );

  factory AuthError.emailAlreadyInUse() => const AuthError(
        message: 'Email is already in use.',
        code: 'EMAIL_IN_USE',
      );

  factory AuthError.weakPassword() => const AuthError(
        message: 'Password is too weak.',
        code: 'WEAK_PASSWORD',
      );

  factory AuthError.sessionExpired() => const AuthError(
        message: 'Your session has expired. Please login again.',
        code: 'SESSION_EXPIRED',
      );
}

/// Validation-related errors
class ValidationError extends AppError {
  final Map<String, String>? fieldErrors;

  const ValidationError({
    required super.message,
    super.code,
    this.fieldErrors,
    super.originalError,
    super.stackTrace,
  });

  factory ValidationError.invalidInput(String field) => ValidationError(
        message: 'Invalid $field',
        code: 'INVALID_INPUT',
        fieldErrors: {field: 'Invalid input'},
      );

  factory ValidationError.requiredField(String field) => ValidationError(
        message: '$field is required',
        code: 'REQUIRED_FIELD',
        fieldErrors: {field: 'This field is required'},
      );

  @override
  List<Object?> get props => [...super.props, fieldErrors];
}

/// Database-related errors
class DatabaseError extends AppError {
  const DatabaseError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory DatabaseError.notFound() => const DatabaseError(
        message: 'Record not found.',
        code: 'NOT_FOUND',
      );

  factory DatabaseError.alreadyExists() => const DatabaseError(
        message: 'Record already exists.',
        code: 'ALREADY_EXISTS',
      );

  factory DatabaseError.queryFailed() => const DatabaseError(
        message: 'Database query failed.',
        code: 'QUERY_FAILED',
      );
}

/// Permission-related errors
class PermissionError extends AppError {
  const PermissionError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory PermissionError.denied(String permission) => PermissionError(
        message: '$permission permission denied.',
        code: 'PERMISSION_DENIED',
      );

  factory PermissionError.notGranted() => const PermissionError(
        message: 'Required permissions not granted.',
        code: 'PERMISSIONS_NOT_GRANTED',
      );
}

/// Generic application error
class GenericError extends AppError {
  const GenericError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory GenericError.unknown() => const GenericError(
        message: 'An unexpected error occurred. Please try again.',
        code: 'UNKNOWN',
      );
}
