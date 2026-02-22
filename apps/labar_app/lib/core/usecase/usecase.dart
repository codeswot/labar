import 'package:dartz/dartz.dart';
import '../error/app_error.dart';

abstract class UseCase<Result, Params> {
  Future<Either<AppError, Result>> call(Params params);
}

class NoParams {}
