import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/home_item.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_firebase_data_source.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeFirebaseDataSource firebaseDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.firebaseDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<HomeItem>>> getHomeItems() async {
    // First try Firebase for real-time data
    try {
      final items = await firebaseDataSource.getHomeItemsForUser();
      
      // If Firebase returns empty data, fallback to API
      if (items.isEmpty) {
        if (await networkInfo.isConnected) {
          try {
            final apiItems = await remoteDataSource.getHomeItems();
            return Right(apiItems);
          } on ServerException {
            // If both fail, return empty list (mock data will be used in bloc)
            return const Right([]);
          }
        }
        return const Right([]);
      }
      
      return Right(items);
    } catch (e) {
      // Firebase failed, fallback to API
      if (await networkInfo.isConnected) {
        try {
          final items = await remoteDataSource.getHomeItems();
          return Right(items);
        } on ServerException catch (e) {
          return Left(ServerFailure(message: e.message));
        }
      }
      return const Left(NetworkFailure());
    }
  }
}
