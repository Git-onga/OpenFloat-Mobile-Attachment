import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);

  Future<UserModel> register(String email, String password, String name);

  Future<void> logout();

  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await apiClient.post(
      '/auth/login',
      body: {'email': email, 'password': password},
    );
    return UserModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<UserModel> register(
    String email,
    String password,
    String name,
  ) async {
    final response = await apiClient.post(
      '/auth/register',
      body: {'email': email, 'password': password, 'name': name},
    );
    return UserModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> logout() async {
    await apiClient.post('/auth/logout');
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await apiClient.get('/auth/me');
      return UserModel.fromJson(response['data'] as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
