import '../core/network/api_client.dart';
import '../core/network/network_info.dart';

/// Central service locator for shared services.
///
/// Register services like [ApiClient], [NetworkInfo],
/// notification services, analytics, etc.
class Services {
  static ApiClient? _apiClient;
  static NetworkInfo? _networkInfo;

  static ApiClient get apiClient {
    _apiClient ??= ApiClient(
      client: throw UnimplementedError('Inject an HTTP client'),
      baseUrl: 'https://api.example.com/v1', // TODO: Use env config
    );
    return _apiClient!;
  }

  static NetworkInfo get networkInfo {
    _networkInfo ??= NetworkInfoImpl();
    return _networkInfo!;
  }

  /// Reset all services (useful for testing)
  static void reset() {
    _apiClient = null;
    _networkInfo = null;
  }
}
