import '../models/user_model.dart';

/// Placeholder for local auth data storage (e.g., SharedPreferences, Hive)
abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);

  Future<UserModel?> getCachedUser();

  Future<void> clearCachedUser();

  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  // TODO: Inject your local storage service

  @override
  Future<void> cacheUser(UserModel user) async {
    // TODO: Implement local storage logic
  }

  @override
  Future<UserModel?> getCachedUser() async {
    // TODO: Implement local storage logic
    return null;
  }

  @override
  Future<void> clearCachedUser() async {
    // TODO: Implement local storage logic
  }

  @override
  Future<bool> isLoggedIn() async {
    // TODO: Implement local storage logic
    return false;
  }
}
