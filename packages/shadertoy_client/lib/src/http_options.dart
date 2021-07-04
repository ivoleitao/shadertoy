import 'package:shadertoy/shadertoy_api.dart';

/// Base class for the http options
///
/// It provides a number of options that can be configured regardless the specific implementation of the client
abstract class ShadertoyHttpOptions extends ShadertoyClientOptions {
  /// Default base URL for Shadertoy website
  static const String defaultBaseUrl = 'https://www.shadertoy.com';

  /// The default maximum number of resources that may be allocated at once in the pool
  static const int defaultPoolMaxAllocatedResources = 5;

  /// The default timeout for a request
  static const int defaultPoolTimeout = 30;

  /// The default maximum number of attempts before giving up
  static const int defaultRetryMaxAttempts = 3;

  /// The default number of shaders fetched for a paged call.
  static const int defaultShaderCount = 12;

  /// The base url of the shadertoy website
  final String baseUrl;

  /// If the http client supports cookies
  final bool supportsCookies;

  /// The maximum number of resources that may be allocated at once in the pool
  ///
  /// It is used to constrain the number of parallel calls that are made to the
  /// Shadertoy endpoints
  final int poolMaxAllocatedResources;

  /// Constrains the maximum time a call to the Shadertoy API can last. If this
  /// value is exceed an exception is thrown for the offending request and for all
  /// the others in the queue
  final int poolTimeout;

  /// The maximum number of atempts before giving up.
  final int retryMaxAttempts;

  /// The number of shaders fetched for paged call
  final int shaderCount;

  /// Builds a [ShadertoyHttpOptions]
  ///
  /// * [baseUrl]: The base url of the shadertoy website, defaults to [ShadertoyHttpOptions.defaultBaseUrl]
  /// * [supportsCookies]: If the http client should support cookies
  /// * [poolMaxAllocatedResources]: The maximum number of resources allocated for parallel calls, defaults to [ShadertoyHttpOptions.defaultPoolMaxAllocatedResources]
  /// * [poolTimeout]: The timeout before giving up on a call, defaults to [ShadertoyHttpOptions.defaultPoolTimeout]
  /// * [retryMaxAttempts]: The maximum number of attempts at a failed request, defaults to [ShadertoyHttpOptions.defaultRetryMaxAttempts]
  /// * [shaderCount]: The number of shaders fetched in a paged call, defaults to [ShadertoyHttpOptions.defaultShaderCount]
  /// * [errorHandling]: The error handling mode
  ShadertoyHttpOptions(
      {String? baseUrl,
      required this.supportsCookies,
      int? poolMaxAllocatedResources,
      int? poolTimeout,
      int? retryMaxAttempts,
      int? shaderCount,
      ErrorMode? errorHandling})
      : baseUrl = baseUrl ?? defaultBaseUrl,
        poolMaxAllocatedResources =
            poolMaxAllocatedResources ?? defaultPoolMaxAllocatedResources,
        poolTimeout = poolTimeout ?? defaultPoolTimeout,
        retryMaxAttempts = retryMaxAttempts ?? defaultRetryMaxAttempts,
        shaderCount = shaderCount ?? defaultShaderCount,
        super(errorHandling: errorHandling) {
    assert(this.baseUrl.isNotEmpty, 'baseUrl is empty');
    assert(this.poolMaxAllocatedResources >= 1,
        'poolMaxAllocatedResources is greater or equal to one');
    assert(this.poolTimeout >= 0, 'poolTimeout is greater or equal to zero');
    assert(this.retryMaxAttempts >= 0,
        'retryMaxAttempts is greater or equal to zero');
    assert(
        this.shaderCount > 0, 'shaderCount should be greater or equal to zero');
  }
}
