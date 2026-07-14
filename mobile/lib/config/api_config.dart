/// API configuration for the Underground Terminal Flutter app.
///
/// The [baseUrl] can be overridden per environment:
/// - Android Emulator: http://10.0.2.2:8080/api (default)
/// - iOS Simulator:    http://localhost:8080/api
/// - Web (dev):        http://localhost:8080/api
/// - Physical Device:  http://YOUR_IP:8080/api
/// - Render Staging:   https://underground-terminal-api-staging.onrender.com/api
/// - Render Prod:      https://underground-terminal-api.onrender.com/api
///
/// Override at build time with `--dart-define=API_BASE_URL=https://...`
/// Or at runtime by calling [ApiConfig.init] before making API calls.
class ApiConfig {
  /// Default base URL for local development.
  /// Uses 10.0.2.2 (Android emulator localhost alias).
  static const String _defaultBaseUrl = 'http://10.0.2.2:8080/api';

  /// The current base URL for API calls.
  /// Override this at app startup for different environments.
  static String baseUrl = _defaultBaseUrl;

  /// Initialize with a custom base URL (e.g., from env vars or build config).
  static void init({String? customUrl}) {
    if (customUrl != null && customUrl.isNotEmpty) {
      baseUrl = customUrl;
    }
  }

  /// Read [API_BASE_URL] from `--dart-define` build arguments.
  /// Call this in main() so web builds can override the endpoint.
  static void initFromEnvironment() {
    const apiUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (apiUrl.isNotEmpty) {
      baseUrl = apiUrl;
    }
  }

  /// Reset to the default base URL.
  static void reset() {
    baseUrl = _defaultBaseUrl;
  }
}
