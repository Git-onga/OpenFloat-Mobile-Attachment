import '../../../../core/network/api_client.dart';
import '../models/home_item_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeItemModel>> getHomeItems();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<HomeItemModel>> getHomeItems() async {
    final response = await apiClient.get('/home/items');
    final data = response['data'] as List<dynamic>;
    return data
        .map((json) => HomeItemModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
