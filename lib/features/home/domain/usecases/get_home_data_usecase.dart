import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/home_item.dart';
import '../repositories/home_repository.dart';

class GetHomeDataUseCase {
  final HomeRepository repository;

  GetHomeDataUseCase(this.repository);

  Future<Either<Failure, List<HomeItem>>> call() {
    return repository.getHomeItems();
  }
}
