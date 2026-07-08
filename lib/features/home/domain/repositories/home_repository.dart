import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/home_item.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<HomeItem>>> getHomeItems();
}
