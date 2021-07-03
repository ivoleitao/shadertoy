import 'package:shadertoy/src/context.dart';
import 'package:shadertoy/src/model/comment.dart';
import 'package:shadertoy/src/model/playlist.dart';
import 'package:shadertoy/src/model/shader.dart';
import 'package:shadertoy/src/model/user.dart';
import 'package:shadertoy/src/response.dart';

/// The supported sort orders
enum Sort {
  /// Sort by name
  name,

  /// Sort by likes
  love,

  /// Sort by views
  popular,

  /// Sort by newest
  newest,

  /// Sort is proportional to the populary and
  /// inversly proportional to lifetime
  hot
}

/// User context
const CONTEXT_USER = 'user';

/// Shader context
const CONTEXT_SHADER = 'shader';

/// Comment context
const CONTEXT_COMMENT = 'comment';

/// Playlist context
const CONTEXT_PLAYLIST = 'playlist';

/// The exception handling mode
enum ErrorMode {
  /// The errors should be handled and returned on the response error
  HandleAndReturn,

  /// The errors should be handled and returned on retrown
  HandleAndRetrow
}

/// Base class for the client options
///
/// It provides a number of options that can be configured regardless the specific implementation
abstract class ShadertoyClientOptions {
  /// The default error handling mode
  static const ErrorMode DefaultErrorHandling = ErrorMode.HandleAndReturn;

  /// The selected error handling mode
  final ErrorMode errorHandling;

  /// Builds a [ShadertoyClientOptions]
  ///
  /// * [errorHandling]: The error handling mode
  ShadertoyClientOptions({ErrorMode? errorHandling})
      : errorHandling = errorHandling ?? DefaultErrorHandling;
}

/// Base shadertoy client API
///
/// All the basic operations supported through
/// the Shadertoy REST API.
abstract class ShadertoyClient {
  /// Returns a [FindShaderResponse] for the shader with [shaderId]
  ///
  /// Upon success a [Shader] object is provided and error is set to null
  ///
  /// In case of error a [ResponseError] is set and no [Shader] is provided
  Future<FindShaderResponse> findShaderById(String shaderId);

  /// Returns a [FindShadersResponse] for each shader id in [shaderIds]
  ///
  /// Upon success a list of [Shader] objects is provided and error is set to null
  ///
  /// In case of error a [ResponseError] is set and no [Shader] list is provided
  Future<FindShadersResponse> findShadersByIdSet(Set<String> shaderIds);

  /// Returns a filtered [FindShadersResponse] with a list of shaders
  ///
  /// * [term]: Shaders that have [term] in the name or in description
  /// * [filters]: A set of tag filters
  /// * [sort]: The sort order of the shaders
  /// * [from]: A 0 based index for results returned
  /// * [num]: The total number of results
  ///
  /// Upon success a list of [Shader] objects is provided as well as the overall
  /// number of records in total (not the number of shaders in the list, the
  /// number of total results). The error is set to null
  ///
  /// In case of error a [ResponseError] is set and no [Shader] list is provided
  Future<FindShadersResponse> findShaders(
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num});

  /// Returns a [FindShaderIdsResponse] with all the shader id's
  ///
  /// Upon success a list of shader ids is provided and error is set to null
  ///
  /// In case of error a [ResponseError] is set and no shader id list is provided
  Future<FindShaderIdsResponse> findAllShaderIds();

  /// Returns a filtered [FindShaderIdsResponse] with a list of shader ids.
  ///
  /// * [term]: Shaders that have [term] in the name or in description
  /// * [filters]: A set of tag filters
  /// * [sort]: The sort order of the shaders
  /// * [from]: A 0 based index for results returned
  /// * [num]: The total number of results
  ///
  /// Upon success a list of shader ids is provided as well as the overall
  /// number of records in total (not the number of shader ids in the list, the
  /// number of total results). The error is set to null
  ///
  /// In case of error a [ResponseError] is set and no shader id list is
  /// provided
  Future<FindShaderIdsResponse> findShaderIds(
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num});
}

/// Extended shadertoy client API
///
/// Extended set of operations not currently supported by the
/// Shadertoy REST API
abstract class ShadertoyExtendedClient extends ShadertoyClient {
  /// Returns a [FindUserResponse] for user with [userId]
  ///
  /// Upon success a [User] object is provided and error is set to null
  ///
  /// In case of error a [ResponseError] is set and no [User] is provided
  Future<FindUserResponse> findUserById(String userId);

  /// Returns a filtered [FindShadersResponse] for user [userId]
  ///
  /// * [filters]: A set of tag filters
  /// * [sort]: The sort order of the shaders
  /// * [from]: A 0 based index for results returned
  /// * [num]: The total number of results
  ///
  /// Upon success a list of [Shader] objects is provided as well as the overall
  /// number of records in total (not the number of shaders in the list, the
  /// number of total results). The error is set to null
  ///
  /// In case of error a [ResponseError] is set and no [Shader] list is provided
  Future<FindShadersResponse> findShadersByUserId(String userId,
      {Set<String>? filters, Sort? sort, int? from, int? num});

  /// Returns a filtered [FindShaderIdsResponse] with a list of shader ids.
  /// for the user [userId]
  ///
  /// * [filters]: A set of tag filters
  /// * [sort]: The sort order of the shaders
  /// * [from]: A 0 based index for results returned
  /// * [num]: The total number of results
  ///
  /// Upon success a list of shader ids is provided as well as the overall
  /// number of records in total (not the number of shader ids in the list, the
  /// number of total results). The error is set to null
  ///
  /// In case of error a [ResponseError] is set and no shader id list is
  /// provided
  Future<FindShaderIdsResponse> findShaderIdsByUserId(String userId,
      {Set<String>? filters, Sort? sort, int? from, int? num});

  /// Returns a [FindShaderIdsResponse] with all the shader id's
  /// for the user [userId]
  ///
  /// Upon success a list of shader ids is provided and error is set to null
  ///
  /// In case of error a [ResponseError] is set and no shader id list is provided
  Future<FindShaderIdsResponse> findAllShaderIdsByUserId(String userId);

  /// Returns a [FindCommentsResponse] for a shader with id [shaderId]
  ///
  /// On success comments has the corresponding
  /// list of comment and error set to null
  ///
  /// In case of error a [ResponseError] is set and no comment list is provided
  Future<FindCommentsResponse> findCommentsByShaderId(String shaderId);

  /// Returns a [FindPlaylistResponse] for a playlist with [playlistId]
  ///
  /// Upon success a [Playlist] object is provided and error is set to null
  ///
  /// In case of error a [ResponseError] is set and no [Playlist] is provided
  Future<FindPlaylistResponse> findPlaylistById(String playlistId);

  /// Returns a [FindShadersResponse] with a list of shaders.
  /// for the playlist [playlistId]
  ///
  /// * [from]: A 0 based index for results returned
  /// * [num]: The total number of results
  ///
  /// Upon success a list of [Shader] objects is provided as well as the overall
  /// number of records in total (not the number of shaders in the list, the
  /// number of total results). The error is set to null
  ///
  /// In case of error a [ResponseError] is set and no [Shader] list is provided
  Future<FindShadersResponse> findShadersByPlaylistId(String playlistId,
      {int? from, int? num});

  /// Returns a [FindShaderIdsResponse] with a list of shader ids.
  ///
  /// * [from]: A 0 based index for results returned
  /// * [num]: The total number of results
  ///
  /// Upon success a list of shader ids is provided as well as the overall
  /// number of records in total (not the number of shader ids in the list, the
  /// number of total results). The error is set to null
  ///
  /// In case of error a [ResponseError] is set and no shader id list is
  /// provided
  Future<FindShaderIdsResponse> findShaderIdsByPlaylistId(String playlistId,
      {int from, int num});

  /// Returns a [FindShaderIdsResponse] with all the shader id's
  /// for the playlist [playlistId]
  ///
  /// Upon success a list of shader ids is provided and error is set to null
  ///
  /// In case of error a [ResponseError] is set and no shader id list is provided
  Future<FindShaderIdsResponse> findAllShaderIdsByPlaylistId(String playlistId);
}

/// A base implementation class for Shadertoy clients
///
/// It assumes a basic implementation of the client with only the
/// REST base API operations. It provides a contextual object to get
/// Shadertoy website information
abstract class ShadertoyBaseClient implements ShadertoyClient {
  /// The [ShadertoyContext] object stores Shadertoy website contextual
  /// information
  final ShadertoyContext context;

  /// Builds a [ShadertoyBaseClient] object
  ///
  /// The [baseUrl] parameter defines the base url of the Shadertoy website
  ShadertoyBaseClient(String baseUrl) : context = ShadertoyContext(baseUrl);
}

/// Extensions for [ShadertoyClient] implementors
extension ShadertoyClientExtension on ShadertoyClient {
  Future<R> catchError<R extends APIResponse, E>(
      Future<R> future, R Function(E) handle, ErrorMode errorMode) {
    return future.catchError((e) {
      if (e is E) {
        final apiResponse = handle(e);
        if (errorMode == ErrorMode.HandleAndReturn) {
          return Future.value(apiResponse);
        } else if (errorMode == ErrorMode.HandleAndRetrow) {
          return Future<R>.error(apiResponse.error ??
              ResponseError.unknown(message: 'Unknown Error'));
        }
      }
      return Future<R>.error(e);
    });
  }
}

/// A definition of a shadertoy store
///
/// It supports the same operations as [ShadertoyExtendedClient] plus
/// persistence specific operations.
abstract class ShadertoyStore extends ShadertoyExtendedClient {
  /// Returns a [FindUserIdsResponse] with all the user id's
  ///
  /// Upon success a list of user ids is provided and error is set to null
  ///
  /// In case of error a [ResponseError] is set and no user id list is provided
  Future<FindUserIdsResponse> findAllUserIds();

  /// Returns a [FindUsersResponse] with all the users
  ///
  /// Upon success a list of users is provided and error is set to null
  ///
  /// In case of error a [ResponseError] is set and no user list is provided
  Future<FindUsersResponse> findAllUsers();

  /// Saves a [User]
  ///
  /// On success the [User] is saved
  ///
  /// In case of error a [ResponseError] is set on [SaveUserResponse]
  Future<SaveUserResponse> saveUser(User user);

  /// Saves a list of [User]
  ///
  /// On success the list of [User] was saved
  ///
  /// In case of error a [ResponseError] is set on [SaveUsersResponse]
  Future<SaveUsersResponse> saveUsers(List<User> users);

  /// Deletes a [User] by [userId]
  ///
  /// On success the [User] identified by [userId] is deleted
  ///
  /// In case of error a [ResponseError] is set on [DeleteUserResponse]
  Future<DeleteUserResponse> deleteUserById(String userId);

  /// Returns a [FindShadersResponse] with all the shaders
  ///
  /// Upon success a list of shaders is provided and error is set to null
  ///
  /// In case of error a [ResponseError] is set and no shader list is provided
  Future<FindShadersResponse> findAllShaders();

  /// Saves a [Shader]
  ///
  /// On success the [Shader] is saved
  ///
  /// In case of error a [ResponseError] is set on [SaveShaderResponse]
  Future<SaveShaderResponse> saveShader(Shader shader);

  /// Saves a list of [Shader]
  ///
  /// On success the list of [Shader] was saved
  ///
  /// In case of error a [ResponseError] is set on [SaveShadersResponse]
  Future<SaveShadersResponse> saveShaders(List<Shader> shaders);

  /// Deletes a [Shader] by [shaderId]
  ///
  /// On success the [Shader] identified by [shaderId] is deleted
  ///
  /// In case of error a [ResponseError] is set on [DeleteShaderResponse]
  Future<DeleteShaderResponse> deleteShaderById(String shaderId);

  /// Returns a [FindCommentResponse] for a comment with id [commentId]
  ///
  /// Upon success a comment object is provided and error is set to null
  ///
  /// In case of error a [ResponseError] is set and no comment is provided
  Future<FindCommentResponse> findCommentById(String commentId);

  /// Returns a [FindCommentIdsResponse] with all the comment id's
  ///
  /// Upon success a list of comment ids is provided and error is set to null
  ///
  /// In case of error a [ResponseError] is set and no comment id list is provided
  Future<FindCommentIdsResponse> findAllCommentIds();

  /// Returns a [FindCommentsResponse] with all the comments
  ///
  /// Upon success a list of comments is provided and error is set to null
  ///
  /// In case of error a [ResponseError] is set and no comment list is provided
  Future<FindCommentsResponse> findAllComments();

  /// Saves a list of shaders comment
  ///
  /// On success the list of comment was saved
  ///
  /// In case of error a [ResponseError] is set on [SaveShaderCommentsResponse]
  Future<SaveShaderCommentsResponse> saveShaderComments(List<Comment> comments);

  /// Deletes a comment by [commentId]
  ///
  /// On success the comment identified by [commentId] is deleted
  ///
  /// In case of error a [ResponseError] is set on [DeleteCommentResponse]
  Future<DeleteCommentResponse> deleteCommentById(String commentId);

  /// Saves a [Playlist] and optionally the playlist shaders
  ///
  /// On success the [Playlist] and optionally the playlist shaders are saved
  ///
  /// In case of error a [ResponseError] is set on [SavePlaylistResponse]
  Future<SavePlaylistResponse> savePlaylist(Playlist playlist,
      {List<String> shaderIds});

  /// Associates a list of shader is with a playlist
  ///
  /// On success the list of shader ids was saved
  ///
  /// In case of error a [ResponseError] is set on [SavePlaylistShadersResponse]
  Future<SavePlaylistShadersResponse> savePlaylistShaders(
      String playlistId, List<String> shaderIds);

  /// Deletes a [Playlist] by [playlistId]
  ///
  /// On success the [Playlist] identified by [playlistId] is deleted
  ///
  /// In case of error a [ResponseError] is set on [DeletePlaylistResponse]
  Future<DeletePlaylistResponse> deletePlaylistById(String playlistId);

  /// Returns a [FindPlaylistIdsResponse] with all the playlist id's
  ///
  /// Upon success a list of playlist ids is provided and error is set to null
  ///
  /// In case of error a [ResponseError] is set and no playlist id list is provided
  Future<FindPlaylistIdsResponse> findAllPlaylistIds();

  /// Returns a [FindPlaylistsResponse] with all the playlists
  ///
  /// Upon success a list of playlists is provided and error is set to null
  ///
  /// In case of error a [ResponseError] is set and no playlist list is provided
  Future<FindPlaylistsResponse> findAllPlaylists();
}

/// A base implementation of Shadertoy stores
abstract class ShadertoyBaseStore implements ShadertoyStore {}
