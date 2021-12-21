import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/src/http_options.dart';

/// Options for the Shadertoy REST API client
///
/// Stores the options used to build a [ShadertoyWSClient]
class ShadertoyWSOptions extends ShadertoyHttpOptions {
  /// The default base API path to use for the REST calls
  ///
  /// Currently points to the v1 of the API
  static const String defaultApiPath = '/api/v1';

  /// The API key that should be appended for each call
  final String apiKey;

  /// The configured API path
  final String apiPath;

  /// Builds a [ShadertoyWSOptions]
  ///
  /// * [apiKey]: The API key
  /// * [apiPath]: The base api path, defaults to [ShadertoyWSOptions.defaultApiPath]
  /// * [baseUrl]: The Shadertoy base url
  /// * [poolMaxAllocatedResources]: The maximum number of resources allocated for parallel calls
  /// * [poolTimeout]: The timeout before giving up on a call
  /// * [retryMaxAttempts]: The maximum number of attempts at a failed request
  /// * [shaderCount]: The number of shaders fetched in a paged call
  /// * [errorHandling]: The error handling mode
  ShadertoyWSOptions(
      {required this.apiKey,
      String? apiPath,
      String? baseUrl,
      int? poolMaxAllocatedResources,
      int? poolTimeout,
      int? retryMaxAttempts,
      int? shaderCount,
      ErrorMode? errorHandling})
      : assert(apiKey.isNotEmpty, 'apiKey not empty'),
        apiPath = apiPath ?? defaultApiPath,
        super(
            baseUrl: baseUrl,
            supportsCookies: false,
            poolMaxAllocatedResources: poolMaxAllocatedResources,
            poolTimeout: poolTimeout,
            retryMaxAttempts: retryMaxAttempts,
            shaderCount: shaderCount,
            errorHandling: errorHandling) {
    assert(this.apiPath.isNotEmpty, 'apiPath is not empty');
  }

  /// Builds a copy of a [ShadertoyWSOptions]
  ///
  /// * [apiKey]: The API key
  /// * [apiPath]: The base api path
  /// * [baseUrl]: The Shadertoy base url
  /// * [poolMaxAllocatedResources]: The maximum number of resources allocated for parallel calls
  /// * [poolTimeout]: The timeout before giving up on a call
  /// * [retryMaxAttempts]: The maximum number of attempts at a failed request
  /// * [shaderCount]: The number of shaders fetched on a paged call
  /// * [errorHandling]: The error handling mode
  ShadertoyWSOptions copyWith(
      {String? apiKey,
      String? apiPath,
      String? baseUrl,
      int? poolMaxAllocatedResources,
      int? poolTimeout,
      int? retryMaxAttempts,
      int? shaderCount,
      ErrorMode? errorHandling}) {
    return ShadertoyWSOptions(
        apiKey: apiKey ?? this.apiKey,
        apiPath: apiPath ?? this.apiPath,
        baseUrl: baseUrl ?? this.baseUrl,
        poolMaxAllocatedResources:
            poolMaxAllocatedResources ?? this.poolMaxAllocatedResources,
        poolTimeout: poolTimeout ?? this.poolTimeout,
        retryMaxAttempts: retryMaxAttempts ?? this.retryMaxAttempts,
        shaderCount: shaderCount ?? this.shaderCount,
        errorHandling: errorHandling ?? this.errorHandling);
  }
}
