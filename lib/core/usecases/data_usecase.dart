import 'package:dartz/dartz.dart';

import '../error/failures.dart';

abstract class DataUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
