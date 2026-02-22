import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/app_logger.dart';
import 'app_error.dart';
import 'app_exception.dart' as app_exceptions;

/// Global error handler for the application
class ErrorHandler {
  /// Handle exceptions and convert them to user-friendly errors
  static AppError handleException(dynamic exception, [StackTrace? stackTrace]) {
    AppLogger.error('Handling exception', exception, stackTrace);

    if (exception is app_exceptions.AppException) {
      return _handleAppException(exception);
    }

    if (exception is AuthException) {
      return AuthError(
        message: exception.message,
        code: exception.code,
        originalError: exception,
        stackTrace: stackTrace,
      );
    }

    if (exception is PostgrestException) {
      return _handlePostgrestException(exception, stackTrace);
    }

    if (exception is AuthApiException) {
      return _handleAuthApiException(exception, stackTrace);
    }

    if (exception is TimeoutException) {
      return NetworkError.timeout();
    }

    if (exception is FormatException) {
      return ValidationError(
        message: 'Invalid data format',
        code: 'FORMAT_ERROR',
        originalError: exception,
        stackTrace: stackTrace,
      );
    }

    return GenericError(
      message: exception.toString(),
      code: 'UNKNOWN',
      originalError: exception,
      stackTrace: stackTrace,
    );
  }

  static AppError _handleAppException(app_exceptions.AppException exception) {
    if (exception is app_exceptions.NetworkException) {
      return NetworkError(
        message: exception.message,
        code: exception.code,
        originalError: exception,
        stackTrace: exception.stackTrace,
      );
    }

    if (exception is app_exceptions.AuthException) {
      return AuthError(
        message: exception.message,
        code: exception.code,
        originalError: exception,
        stackTrace: exception.stackTrace,
      );
    }

    if (exception is app_exceptions.ValidationException) {
      return ValidationError(
        message: exception.message,
        code: exception.code,
        fieldErrors: exception.fieldErrors,
        originalError: exception,
        stackTrace: exception.stackTrace,
      );
    }

    if (exception is app_exceptions.DatabaseException) {
      return DatabaseError(
        message: exception.message,
        code: exception.code,
        originalError: exception,
        stackTrace: exception.stackTrace,
      );
    }

    if (exception is app_exceptions.PermissionException) {
      return PermissionError(
        message: exception.message,
        code: exception.code,
        originalError: exception,
        stackTrace: exception.stackTrace,
      );
    }

    return GenericError(
      message: exception.message,
      code: exception.code,
      originalError: exception,
      stackTrace: exception.stackTrace,
    );
  }

  static AppError _handlePostgrestException(
    PostgrestException exception,
    StackTrace? stackTrace,
  ) {
    final message = exception.message;
    final code = exception.code;

    if (code == '23505') {
      return DatabaseError.alreadyExists();
    }

    if (code == 'PGRST116') {
      return DatabaseError.notFound();
    }

    return DatabaseError(
      message: message,
      code: code,
      originalError: exception,
      stackTrace: stackTrace,
    );
  }

  static AppError _handleAuthApiException(
    AuthApiException exception,
    StackTrace? stackTrace,
  ) {
    final message = exception.message;
    final code = exception.code;

    switch (code) {
      case 'invalid_credentials':
      case 'invalid_grant':
        return AuthError.invalidCredentials();
      case 'user_not_found':
        return AuthError.userNotFound();
      case 'email_exists':
      case 'user_already_exists':
        return AuthError.emailAlreadyInUse();
      case 'weak_password':
        return AuthError.weakPassword();
      case 'session_expired':
      case 'refresh_token_not_found':
        return AuthError.sessionExpired();
      default:
        return AuthError(
          message: message,
          code: code,
          originalError: exception,
          stackTrace: stackTrace,
        );
    }
  }

  /// Get user-friendly error message
  static String getUserMessage(AppError error) {
    return error.message;
  }

  /// Check if error is recoverable
  static bool isRecoverable(AppError error) {
    return error is NetworkError ||
        error is ValidationError ||
        error is DatabaseError;
  }
}
