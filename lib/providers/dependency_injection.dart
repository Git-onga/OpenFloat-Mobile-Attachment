import 'package:http/http.dart' as http;

import '../core/network/api_client.dart';
import '../core/network/network_info.dart';
import '../features/auth/data/datasources/auth_local_data_source.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/home/data/datasources/home_remote_data_source.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/usecases/get_home_data_usecase.dart';
import '../features/home/presentation/bloc/home_bloc.dart';

/// Dependency injection container.
///
/// Creates and wires up all dependencies manually.
/// Replace with a DI package (get_it, injectable) as the project grows.
class DependencyInjection {
  // Core
  static final http.Client _httpClient = http.Client();
  static final ApiClient _apiClient = ApiClient(
    client: _httpClient,
    baseUrl: 'https://api.example.com/v1', // TODO: Use env config
  );
  static final NetworkInfo _networkInfo = NetworkInfoImpl();

  // Auth
  static final AuthRemoteDataSource _authRemoteDataSource =
      AuthRemoteDataSourceImpl(apiClient: _apiClient);
  static final AuthLocalDataSource _authLocalDataSource =
      AuthLocalDataSourceImpl();

  static final AuthRepositoryImpl _authRepository = AuthRepositoryImpl(
    remoteDataSource: _authRemoteDataSource,
    localDataSource: _authLocalDataSource,
    networkInfo: _networkInfo,
  );

  static final LoginUseCase _loginUseCase = LoginUseCase(_authRepository);
  static final RegisterUseCase _registerUseCase =
      RegisterUseCase(_authRepository);
  static final LogoutUseCase _logoutUseCase = LogoutUseCase(_authRepository);

  static AuthBloc provideAuthBloc() {
    return AuthBloc(
      loginUseCase: _loginUseCase,
      registerUseCase: _registerUseCase,
      logoutUseCase: _logoutUseCase,
    );
  }

  // Home
  static final HomeRemoteDataSource _homeRemoteDataSource =
      HomeRemoteDataSourceImpl(apiClient: _apiClient);

  static final HomeRepositoryImpl _homeRepository = HomeRepositoryImpl(
    remoteDataSource: _homeRemoteDataSource,
    networkInfo: _networkInfo,
  );

  static final GetHomeDataUseCase _getHomeDataUseCase =
      GetHomeDataUseCase(_homeRepository);

  static HomeBloc provideHomeBloc() {
    return HomeBloc(getHomeDataUseCase: _getHomeDataUseCase);
  }
}
