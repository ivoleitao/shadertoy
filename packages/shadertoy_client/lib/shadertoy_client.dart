/// Shadertoy HTTP client.
///
/// Provides an implementation of the Shadertoy API allowing users to query both REST and site APIs.
library shadertoy_client;

import 'package:dio/dio.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/src/hybrid/hybrid_client.dart';
import 'package:shadertoy_client/src/site/site_client.dart';
import 'package:shadertoy_client/src/site/site_options.dart';
import 'package:shadertoy_client/src/ws/ws_client.dart';
import 'package:shadertoy_client/src/ws/ws_options.dart';

export 'src/http_options.dart';
export 'src/hybrid/hybrid_client.dart';
export 'src/site/site_client.dart';
export 'src/site/site_options.dart';
export 'src/ws/ws_client.dart';
export 'src/ws/ws_options.dart';

/// Creates [ShadertoyWS] backed by the Shadertoy Rest API
///
/// * [apiKey]: The API key
/// * [apiPath]: The base api path
/// * [baseUrl]: The Shadertoy base url
/// * [poolMaxAllocatedResources]: The maximum number of resources allocated for parallel calls
/// * [poolTimeout]: The timeout before giving up on a call
/// * [retryMaxAttempts]: The maximum number of attempts at a failed request
/// * [shaderCount]: The number of shaders fetched in a paged call
/// * [errorHandling]: The error handling mode
/// * [client]: A pre-initialized [Dio] client
ShadertoyWS newShadertoyWSClient(String apiKey,
    {String? apiPath,
    String? baseUrl,
    int? poolMaxAllocatedResources,
    int? poolTimeout,
    int? retryMaxAttempts,
    int? shaderCount,
    ErrorMode? errorHandling,
    Dio? client}) {
  return ShadertoyWSClient(
      ShadertoyWSOptions(
          apiKey: apiKey,
          apiPath: apiPath,
          baseUrl: baseUrl,
          poolMaxAllocatedResources: poolMaxAllocatedResources,
          poolTimeout: poolTimeout,
          retryMaxAttempts: retryMaxAttempts,
          shaderCount: shaderCount,
          errorHandling: errorHandling),
      dio: client);
}

/// Creates [ShadertoySite] backed by a [ShadertoySiteClient]
///
/// * [user]: The Shadertoy user
/// * [password]: The Shadertoy password
/// * [cookieName]: The Shadertoy cookie name
/// * [userShaderCount]: The number of shaders requested for a user paged call
/// * [playlistShaderCount]: The number of shaders requested for a playlist paged call
/// * [pageResultsShaderCount]: The number of shaders presented in the Shadertoy results page
/// * [pageUserShaderCount]: The number of shaders presented in the Shadertoy user page
/// * [pagePlaylistShaderCount]: The number of shaders presented in the Shadertoy playlist page
/// * [baseUrl]: The Shadertoy base url
/// * [poolMaxAllocatedResources]: The maximum number of resources allocated for parallel calls
/// * [poolTimeout]: The timeout before giving up on a call
/// * [retryMaxAttempts]: The maximum number of attempts at a failed request
/// * [shaderCount]: The number of shaders fetched in a paged call
/// * [errorHandling]: The error handling mode
/// * [client]: A pre-initialized [Dio] client
ShadertoySite newShadertoySiteClient(
    {String? user,
    String? password,
    String? cookieName,
    int? userShaderCount,
    int? playlistShaderCount,
    int? pageResultsShaderCount,
    int? pageUserShaderCount,
    int? pagePlaylistShaderCount,
    String? baseUrl,
    int? poolMaxAllocatedResources,
    int? poolTimeout,
    int? retryMaxAttempts,
    int? shaderCount,
    ErrorMode? errorHandling,
    Dio? client}) {
  return ShadertoySiteClient(
      ShadertoySiteOptions(
          user: user,
          password: password,
          cookieName: cookieName,
          userShaderCount: userShaderCount,
          playlistShaderCount: playlistShaderCount,
          pageResultsShaderCount: pageResultsShaderCount,
          pageUserShaderCount: pageUserShaderCount,
          pagePlaylistShaderCount: pagePlaylistShaderCount,
          baseUrl: baseUrl,
          poolMaxAlocatedResources: poolMaxAllocatedResources,
          poolTimeout: poolTimeout,
          retryMaxAttempts: retryMaxAttempts,
          shaderCount: shaderCount,
          errorHandling: errorHandling),
      dio: client);
}

/// Creates [ShadertoyHybrid] backed by a [ShadertoyHybridClient]
///
/// * [user]: The Shadertoy user
/// * [password]: The Shadertoy password
/// * [cookieName]: The Shadertoy cookie name
/// * [userShaderCount]: The number of shaders requested for a user paged call
/// * [playlistShaderCount]: The number of shaders requested for a playlist paged call
/// * [pageResultsShaderCount]: The number of shaders presented in the Shadertoy results page
/// * [pageUserShaderCount]: The number of shaders presented in the Shadertoy user page
/// * [pagePlaylistShaderCount]: The number of shaders presented in the Shadertoy playlist page
/// * [baseUrl]: The Shadertoy base url
/// * [poolMaxAllocatedResources]: The maximum number of resources allocated for parallel calls
/// * [poolTimeout]: The timeout before giving up on a call
/// * [retryMaxAttempts]: The maximum number of attempts at a failed request
/// * [shaderCount]: The number of shaders fetched in a paged call
/// * [errorHandling]: The error handling mode
/// * [client]: A pre-initialized [Dio] client
ShadertoyHybrid newShadertoyHybridClient(
    {String? user,
    String? password,
    String? cookieName,
    int? userShaderCount,
    int? playlistShaderCount,
    int? pageResultsShaderCount,
    int? pageUserShaderCount,
    int? pagePlaylistShaderCount,
    String? apiKey,
    String? apiPath,
    String? baseUrl,
    int? poolMaxAllocatedResources,
    int? poolTimeout,
    int? retryMaxAttempts,
    int? shaderCount,
    ErrorMode? errorHandling,
    Dio? client}) {
  return ShadertoyHybridClient(
      ShadertoySiteOptions(
          user: user,
          password: password,
          cookieName: cookieName,
          userShaderCount: userShaderCount,
          playlistShaderCount: playlistShaderCount,
          pageResultsShaderCount: pageResultsShaderCount,
          pageUserShaderCount: pageUserShaderCount,
          pagePlaylistShaderCount: pagePlaylistShaderCount,
          baseUrl: baseUrl,
          poolMaxAlocatedResources: poolMaxAllocatedResources,
          poolTimeout: poolTimeout,
          retryMaxAttempts: retryMaxAttempts,
          errorHandling: errorHandling),
      wsOptions: apiKey != null
          ? ShadertoyWSOptions(
              apiKey: apiKey,
              apiPath: apiPath,
              baseUrl: baseUrl,
              poolMaxAllocatedResources: poolMaxAllocatedResources,
              poolTimeout: poolTimeout,
              retryMaxAttempts: retryMaxAttempts,
              shaderCount: shaderCount,
              errorHandling: errorHandling)
          : null,
      client: client);
}
