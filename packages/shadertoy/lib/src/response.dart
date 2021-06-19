import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/error_converter.dart';
import 'package:shadertoy/src/model/comment.dart';
import 'package:shadertoy/src/model/playlist.dart';
import 'package:shadertoy/src/model/shader.dart';
import 'package:shadertoy/src/model/user.dart';

part 'response.g.dart';

/// The list of errors
enum ErrorCode {
  /// Authentication error
  AUTHENTICATION,

  /// Authorization error
  AUTHORIZATION,

  /// Backend timeout error
  BACKEND_TIMEOUT,

  /// Backend status error
  BACKEND_STATUS,

  /// Invalid backend response error
  BACKEND_RESPONSE,

  /// Not found error
  NOT_FOUND,

  /// Operation aborted error
  ABORTED,

  /// Conflict error
  CONFLICT,

  /// Unprocessable error
  UNPROCESSABLE_ENTITY,

  /// Unknowkn error
  UNKNOWN
}

/// Error information class
///
/// Provides details of an error after the execution of an API call. It should be instantiated in every
/// response object when there is an error of some sort during the execution. All the API responses should
/// return a class extending [APIResponse] which stores in [APIResponse.error] and instance of [ResponseError]
class ResponseError with EquatableMixin {
  /// The error code
  ErrorCode code;

  /// The error message
  String message;

  /// The context of execution when the error occurred
  String? context;

  /// The target entity of the API that triggered this error
  String? target;

  /// Builds a [ResponseError]
  ///
  /// * [code]: The error code
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError(
      {required this.code, required this.message, this.context, this.target});

  /// Builds a authentication [ResponseError] with [ErrorCode.AUTHENTICATION] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.authentication(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.AUTHENTICATION,
            message: message,
            context: context,
            target: target);

  /// Builds a authorization [ResponseError] with [ErrorCode.AUTHORIZATION] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.authorization(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.AUTHORIZATION,
            message: message,
            context: context,
            target: target);

  /// Builds a backend timeout [ResponseError] with [ErrorCode.BACKEND_TIMEOUT] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.backendTimeout(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.BACKEND_TIMEOUT,
            message: message,
            context: context,
            target: target);

  /// Builds a backend status [ResponseError] with [ErrorCode.BACKEND_STATUS] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.backendStatus(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.BACKEND_STATUS,
            message: message,
            context: context,
            target: target);

  /// Builds a backend response [ResponseError] with [ErrorCode.BACKEND_RESPONSE] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.backendResponse(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.BACKEND_RESPONSE,
            message: message,
            context: context,
            target: target);

  /// Builds a not found [ResponseError] with [ErrorCode.NOT_FOUND] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.notFound(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.NOT_FOUND,
            message: message,
            context: context,
            target: target);

  /// Builds a aborted [ResponseError] with [ErrorCode.ABORTED] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.aborted(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.ABORTED,
            message: message,
            context: context,
            target: target);

  /// Builds a unprocessable entity [ResponseError] with [ErrorCode.UNPROCESSABLE_ENTITY] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.unprocessableEntity(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.UNPROCESSABLE_ENTITY,
            message: message,
            context: context,
            target: target);

  /// Builds a conflict [ResponseError] with [ErrorCode.CONFLICT] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.conflict(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.CONFLICT,
            message: message,
            context: context,
            target: target);

  /// Builds a unknown [ResponseError] with [ErrorCode.UNKNOWN] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.unknown(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.UNKNOWN,
            message: message,
            context: context,
            target: target);

  @override
  List<Object?> get props => [code, message, context, target];

  /// Creates a json map from a [ResponseError]
  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code.toString().split('.').last,
        'message': message,
        'context': context,
        'target': target
      };

  /// Creates a [ResponseError] from json map
  factory ResponseError.fromJson(Map<String, dynamic> json) => ResponseError(
      code: ErrorCode.values.firstWhere(
          (e) => e.toString() == 'ErrorCode.' + (json['code'] as String)),
      message: json['message'] as String,
      context: json['context'] as String,
      target: json['target'] as String);

  /// Builds a copy of a [ResponseError]
  ///
  /// * [code]: The error code
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError copyWith(
      {ErrorCode? code, String? message, String? context, String? target}) {
    return ResponseError(
        code: code ?? this.code,
        message: message ?? this.message,
        context: context ?? this.context,
        target: target ?? this.target);
  }
}

/// Base API response class
///
/// It should be used as the base class for every API response. It provides support for
/// error aware responses with a field that should be set when there was an error in
/// the API
abstract class APIResponse {
  @JsonKey(name: 'Error')
  @ResponseErrorConverter()

  /// The error
  final ResponseError? error;

  /// The [List] of `props` (properties) which will be used to determine whether
  /// two Equatables are equal.
  List get props {
    return [error];
  }

  /// Returns `true` if there is not error
  ///
  /// Simply check if [error] is null
  bool get ok {
    return error == null;
  }

  /// Builds an [APIResponse]
  ///
  /// An optional [error] can be provided
  APIResponse({this.error});
}

@JsonSerializable()

/// Login API response
///
/// The response returned upon the execution of a login in the Shadertoy website
/// When [LoginResponse.error] is *not null* there was an error in the login process
/// When [LoginResponse.error] is *null* the login was sucessfull
class LoginResponse extends APIResponse with EquatableMixin {
  /// Builds an [LoginResponse]
  ///
  /// An optional [error] can be provided
  LoginResponse({ResponseError? error}) : super(error: error);

  /// Creates a [LoginResponse] from json map
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  /// Creates a json map from a [LoginResponse]
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()

/// Logout API response
///
/// The response returned upon the execution of a logout in the Shadertoy website
/// When [LogoutResponse.error] is *not null* there was an error in the logout process
/// When [LogoutResponse.error] is *null* the logout was sucessfull
class LogoutResponse extends APIResponse with EquatableMixin {
  /// Builds an [LogoutResponse]
  ///
  /// An optional [error] can be provided
  LogoutResponse({ResponseError? error}) : super(error: error);

  /// Creates a [LogoutResponse] from json map
  factory LogoutResponse.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseFromJson(json);

  /// Creates a json map from a [LogoutResponse]
  Map<String, dynamic> toJson() => _$LogoutResponseToJson(this);
}

@JsonSerializable()

/// Find user API response
///
/// The response returned upon the execution of a find user API call
/// When [FindUserResponse.error] is *not null* there was an error in the find user call
/// When [FindUserResponse.error] is *null* the [FindUserResponse.user] has the returned user
class FindUserResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'User')

  /// The user returned, null when there is an error
  final User? user;

  @override
  List get props {
    return [user, error];
  }

  /// Builds a [FindUserResponse]
  ///
  /// [user]: The user
  /// [error]: An error if there was error while fetching the user
  FindUserResponse({this.user, ResponseError? error}) : super(error: error);

  /// Creates a [FindUserResponse] from json map
  factory FindUserResponse.fromJson(Map<String, dynamic> json) =>
      _$FindUserResponseFromJson(json);

  /// Creates a json map from a [FindUserResponse]
  Map<String, dynamic> toJson() => _$FindUserResponseToJson(this);
}

@JsonSerializable()

/// Find users API response
///
/// The response returned upon the execution of a find users API call
/// When [FindUsersResponse.error] is *not null* there was an error in the find users call
/// When [FindUsersResponse.error] is *null* the [FindUsersResponse.shaders] has the returned users
class FindUsersResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Users')

  /// The total number of users
  final int total;

  @JsonKey(name: 'Results')

  /// The list of the users returned
  final List<FindUserResponse>? users;

  @override
  List get props {
    return [total, users, error];
  }

  /// Builds a [FindUsersResponse]
  ///
  /// [total]: The total number of users returned
  /// [users]: The list of users
  /// [error]: An error if there was error while fetching the shaders
  FindUsersResponse({int? total, this.users, ResponseError? error})
      : total = total ?? users?.length ?? 0,
        super(error: error);

  /// Creates a [FindUsersResponse] from json map
  factory FindUsersResponse.fromJson(Map<String, dynamic> json) =>
      _$FindUsersResponseFromJson(json);

  /// Creates a json map from a [FindUsersResponse]
  Map<String, dynamic> toJson() => _$FindUsersResponseToJson(this);
}

@JsonSerializable()

/// Find user ids API response
///
/// The response returned upon the execution of a find user ids API call
/// When [FindUserIdsResponse.error] is *not null* there was an error in the find user ids call
/// When [FindUserIdsResponse.error] is *null* the [FindUserIdsResponse.ids] has the returned use ids
class FindUserIdsResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Users')

  /// The total number of user ids
  final int total;

  @JsonKey(name: 'Results')

  /// The list of user ids returned
  final List<String>? ids;

  @override
  List get props {
    return [total, ids, error];
  }

  /// Builds a [FindUserIdsResponse]
  ///
  /// [total]: The total number of user ids returned
  /// [ids]: The list of ids
  /// [error]: An error if there was error while fetching the shader ids
  FindUserIdsResponse({int? count, this.ids, ResponseError? error})
      : total = count ?? ids?.length ?? 0,
        super(error: error);

  /// Creates a [FindUserIdsResponse] from json map
  factory FindUserIdsResponse.fromJson(Map<String, dynamic> json) =>
      _$FindUserIdsResponseFromJson(json);

  /// Creates a json map from a [FindUserIdsResponse]
  Map<String, dynamic> toJson() => _$FindUserIdsResponseToJson(this);
}

/// Save user API response
///
/// The response returned upon the execution of the save user API call
/// When [SaveUserResponse.error] is *not null* there was an error in the save user call
/// When [SaveUserResponse.error] is *null* the save was sucessful
class SaveUserResponse extends APIResponse with EquatableMixin {
  /// Builds a [SaveUserResponse]
  ///
  /// [error]: An error if there was error while saving the user
  SaveUserResponse({ResponseError? error}) : super(error: error);
}

/// Save users API response
///
/// The response returned upon the execution of the save users API call
/// When [SaveUsersResponse.error] is *not null* there was an error in the save shader call
/// When [SaveUsersResponse.error] is *null* the save was sucessful
class SaveUsersResponse extends APIResponse with EquatableMixin {
  /// Builds a [SaveUsersResponse]
  ///
  /// [error]: An error if there was error while saving the user
  SaveUsersResponse({ResponseError? error}) : super(error: error);
}

/// Delete user API response
///
/// The response returned upon the execution of the delete user API call
/// When [DeleteUserResponse.error] is *not null* there was an error in the delete user call
/// When [DeleteUserResponse.error] is *null* the delete was sucessful
class DeleteUserResponse extends APIResponse with EquatableMixin {
  /// Builds a [DeleteUserResponse]
  ///
  /// [error]: An error if there was error while deleting the user
  DeleteUserResponse({ResponseError? error}) : super(error: error);
}

@JsonSerializable()

/// Find shader API response
///
/// The response returned upon the execution of a find shader API call
/// When [FindShaderResponse.error] is *not null* there was an error in the find shader call
/// When [FindShaderResponse.error] is *null* the [FindShaderResponse.shader] has the returned shader
class FindShaderResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Shader')

  /// The shader returned, null when there is an error
  final Shader? shader;

  @override
  List get props {
    return [shader, error];
  }

  /// Builds an [FindShaderResponse]
  ///
  /// * [shader]: The shader
  /// * [error]: An error
  ///
  /// Upon construction either [shader] or [error] should be provided, not both
  FindShaderResponse({this.shader, ResponseError? error}) : super(error: error);

  /// Creates a [FindShaderResponse] from json map
  factory FindShaderResponse.fromJson(Map<String, dynamic> json) =>
      _$FindShaderResponseFromJson(json);

  /// Creates a json map from a [FindShaderResponse]
  Map<String, dynamic> toJson() => _$FindShaderResponseToJson(this);
}

@JsonSerializable()

/// Find shader ids API response
///
/// The response returned upon the execution of a find shader ids API call
/// When [FindShaderIdsResponse.error] is *not null* there was an error in the find shader ids call
/// When [FindShaderIdsResponse.error] is *null* the [FindShaderIdsResponse.ids] has the returned shader ids
class FindShaderIdsResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Shaders')

  /// The total number of shader ids
  final int total;

  @JsonKey(name: 'Results')

  /// The list of shader ids returned
  final List<String>? ids;

  @override
  List get props {
    return [total, ids, error];
  }

  /// Builds a [FindShaderIdsResponse]
  ///
  /// [total]: The total number of shader ids returned
  /// [ids]: The list of ids
  /// [error]: An error if there was error while fetching the shader ids
  FindShaderIdsResponse({int? count, this.ids, ResponseError? error})
      : total = count ?? ids?.length ?? 0,
        super(error: error);

  /// Creates a [FindShaderIdsResponse] from json map
  factory FindShaderIdsResponse.fromJson(Map<String, dynamic> json) =>
      _$FindShaderIdsResponseFromJson(json);

  /// Creates a json map from a [FindShaderIdsResponse]
  Map<String, dynamic> toJson() => _$FindShaderIdsResponseToJson(this);
}

@JsonSerializable()

/// Find shaders API response
///
/// The response returned upon the execution of a find shaders API call
/// When [FindShadersResponse.error] is *not null* there was an error in the find shaders call
/// When [FindShadersResponse.error] is *null* the [FindShadersResponse.shaders] has the returned shaders
class FindShadersResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Shaders')

  /// The total number of shaders
  final int total;

  @JsonKey(name: 'Results')

  /// The list of the shaders returned
  final List<FindShaderResponse>? shaders;

  @override
  List get props {
    return [total, shaders, error];
  }

  /// Builds a [FindShadersResponse]
  ///
  /// [total]: The total number of shader returned
  /// [shaders]: The list of shaders
  /// [error]: An error if there was error while fetching the shaders
  FindShadersResponse({int? total, this.shaders, ResponseError? error})
      : total = total ?? shaders?.length ?? 0,
        super(error: error);

  /// Creates a [FindShadersResponse] from json map
  factory FindShadersResponse.fromJson(Map<String, dynamic> json) =>
      _$FindShadersResponseFromJson(json);

  /// Creates a json map from a [FindShadersResponse]
  Map<String, dynamic> toJson() => _$FindShadersResponseToJson(this);
}

/// Save shader API response
///
/// The response returned upon the execution of the save shader API call
/// When [SaveShaderResponse.error] is *not null* there was an error in the save shader call
/// When [SaveShaderResponse.error] is *null* the save was sucessful
class SaveShaderResponse extends APIResponse with EquatableMixin {
  /// Builds a [SaveShaderResponse]
  ///
  /// [error]: An error if there was error while saving the shader
  SaveShaderResponse({ResponseError? error}) : super(error: error);
}

/// Save shaders API response
///
/// The response returned upon the execution of the save shaders API call
/// When [SaveShadersResponse.error] is *not null* there was an error in the save shader call
/// When [SaveShadersResponse.error] is *null* the save was sucessful
class SaveShadersResponse extends APIResponse with EquatableMixin {
  /// Builds a [SaveShadersResponse]
  ///
  /// [error]: An error if there was error while saving the shader
  SaveShadersResponse({ResponseError? error}) : super(error: error);
}

/// Delete shader API response
///
/// The response returned upon the execution of the delete shader API call
/// When [DeleteShaderResponse.error] is *not null* there was an error in the delete shader call
/// When [DeleteShaderResponse.error] is *null* the delete was sucessful
class DeleteShaderResponse extends APIResponse with EquatableMixin {
  /// Builds a [DeleteShaderResponse]
  ///
  /// [error]: An error if there was error while deleting the shader
  DeleteShaderResponse({ResponseError? error}) : super(error: error);
}

@JsonSerializable()

/// Comments response
///
/// The response returned from a call to the Shadertoy comments endpoint
/// When [CommentsResponse.error] is *not null* there was an error while fetching the comments
/// When [CommentsResponse.error] is *null* the [CommentsResponse] has a individual list of
/// text, date, user id's and user picture all with the same size. The first index of
/// of the text list corresponds to the first index of the date list and so on. This is a structure
/// used for the intermediary storage of the response. It is transformed in [FindCommentsResponse] later
class CommentsResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'text')

  /// The list of comment texts
  final List<String>? texts;

  @JsonKey(name: 'date')

  /// The list of date for each comment
  final List<String>? dates;

  @JsonKey(name: 'username')

  /// The list of user id's that posted the comment
  final List<String>? userIds;

  @JsonKey(name: 'userpicture')

  /// The list of user pictures for each comment
  final List<String>? userPictures;

  @JsonKey(name: 'id')

  /// A list of the comment ids
  final List<String>? ids;

  @JsonKey(name: 'hidden')

  /// A list with a hidden flag for each comment
  final List<int>? hidden;

  /// Builds a [CommentsResponse]
  ///
  /// * [texts]: The list of text comments
  /// * [dates]: The list of dates for each comment
  /// * [userIds]: The list of user id's for each comment
  /// * [userPictures]: The list user pictures for each comment
  /// * [ids]: A list of the comment ids
  /// * [hidden]: A list with a hidden flag for each comment
  /// * [error]: An error if there was error while fetching the comments
  CommentsResponse(
      {this.texts,
      this.dates,
      this.userIds,
      this.userPictures,
      this.ids,
      this.hidden,
      ResponseError? error})
      : super(error: error);

  @override
  List get props {
    return [texts, dates, userIds, userPictures, ids, hidden, error];
  }

  /// Creates a [CommentsResponse] from json list
  factory CommentsResponse.fromList(List<dynamic> json) => CommentsResponse(
      texts: const [],
      dates: const [],
      userIds: const [],
      userPictures: const [],
      ids: const [],
      hidden: const []);

  /// Creates a [CommentsResponse] from json map
  factory CommentsResponse.fromMap(Map<String, dynamic> json) =>
      _$CommentsResponseFromJson(json);

  /// Creates a [CommentsResponse] from json list or map
  factory CommentsResponse.from(dynamic data) => data is List
      ? CommentsResponse.fromList(data)
      : CommentsResponse.fromMap(data);

  /// Creates a json map from a [CommentsResponse]
  Map<String, dynamic> toJson() => _$CommentsResponseToJson(this);
}

@JsonSerializable()

/// Find comment API response
///
/// The response returned upon the execution of a find comment API call
/// When [FindCommentResponse.error] is *not null* there was an error in the find comment call
/// When [FindCommentResponse.error] is *null* the [FindCommentResponse.comment] has the returned comment
class FindCommentResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Comment')

  /// The comment returned, null when there is an error
  final Comment? comment;

  @override
  List get props {
    return [comment, error];
  }

  /// Builds a [FindCommentResponse]
  ///
  /// [comment]: The comment
  /// [error]: An error if there was error while fetching the comment
  FindCommentResponse({this.comment, ResponseError? error})
      : super(error: error);

  /// Creates a [FindCommentResponse] from json map
  factory FindCommentResponse.fromJson(Map<String, dynamic> json) =>
      _$FindCommentResponseFromJson(json);

  /// Creates a json map from a [FindCommentResponse]
  Map<String, dynamic> toJson() => _$FindCommentResponseToJson(this);
}

@JsonSerializable()

/// Find comment ids API response
///
/// The response returned upon the execution of a find comment ids API call
/// When [FindCommentIdsResponse.error] is *not null* there was an error in the find comment ids call
/// When [FindCommentIdsResponse.error] is *null* the [FindCommentIdsResponse.ids] has the returned comment ids
class FindCommentIdsResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Comments')

  /// The total number of comment ids
  final int total;

  @JsonKey(name: 'Results')

  /// The list of comment ids returned
  final List<String>? ids;

  @override
  List get props {
    return [total, ids, error];
  }

  /// Builds a [FindCommentIdsResponse]
  ///
  /// [total]: The total number of comment ids returned
  /// [ids]: The list of ids
  /// [error]: An error if there was error while fetching the comment ids
  FindCommentIdsResponse({int? count, this.ids, ResponseError? error})
      : total = count ?? ids?.length ?? 0,
        super(error: error);

  /// Creates a [FindCommentIdsResponse] from json map
  factory FindCommentIdsResponse.fromJson(Map<String, dynamic> json) =>
      _$FindCommentIdsResponseFromJson(json);

  /// Creates a json map from a [FindCommentIdsResponse]
  Map<String, dynamic> toJson() => _$FindCommentIdsResponseToJson(this);
}

@JsonSerializable()

/// Find comments API response
///
/// The response returned upon the execution of a find comments API call
/// When [FindCommentsResponse.error] is *not null* there was an error in the find comments call
/// When [FindCommentsResponse.error] is *null* the [FindCommentsResponse.comments] has the returned comments
class FindCommentsResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Comments')

  /// The total number of comments
  final int total;

  @JsonKey(name: 'Results')

  /// The list of [Comment] returned
  final List<Comment>? comments;

  @override
  List get props {
    return [total, comments, error];
  }

  /// Builds a [FindCommentsResponse]
  ///
  /// [total]: The total number of comments returned
  /// [comments]: The list of [Comment]
  /// [error]: An error if there was error while fetching the comments
  FindCommentsResponse({int? total, this.comments, ResponseError? error})
      : total = total ?? comments?.length ?? 0,
        super(error: error);

  /// Creates a [FindCommentsResponse] from json map
  factory FindCommentsResponse.fromJson(Map<String, dynamic> json) =>
      _$FindCommentsResponseFromJson(json);

  /// Creates a json map from a [FindCommentsResponse]
  Map<String, dynamic> toJson() => _$FindCommentsResponseToJson(this);
}

/// Save shader comments API response
///
/// The response returned upon the execution of the save shader comments API call
/// When [SaveShaderCommentsResponse.error] is *not null* there was an error in the save shader comments call
/// When [SaveShaderCommentsResponse.error] is *null* the save was sucessful
class SaveShaderCommentsResponse extends APIResponse with EquatableMixin {
  /// Builds a [SaveShaderCommentsResponse]
  ///
  /// [error]: An error if there was error while saving the shader comments
  SaveShaderCommentsResponse({ResponseError? error}) : super(error: error);
}

/// Delete comment API response
///
/// The response returned upon the execution of the delete comment API call
/// When [DeleteCommentResponse.error] is *not null* there was an error in the delete comment call
/// When [DeleteCommentResponse.error] is *null* the delete was sucessful
class DeleteCommentResponse extends APIResponse with EquatableMixin {
  /// Builds a [DeleteCommentResponse]
  ///
  /// [error]: An error if there was error while deleting the comment
  DeleteCommentResponse({ResponseError? error}) : super(error: error);
}

@JsonSerializable()

/// Find playlist API response
///
/// The response returned upon the execution of a find playlist API call
/// When [FindPlaylistResponse.error] is *not null* there was an error in the find playlist call
/// When [FindPlaylistResponse.error] is *null* the [FindPlaylistResponse.playlist] has the returned playlist
class FindPlaylistResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Playlist')

  /// The playlist returned, null when there is an error
  final Playlist? playlist;

  @override
  List get props {
    return [playlist, error];
  }

  /// Builds a [FindPlaylistResponse]
  ///
  /// [playlist]: The playlist
  /// [error]: An error if there was error while fetching the playlist
  FindPlaylistResponse({this.playlist, ResponseError? error})
      : super(error: error);

  /// Creates a [FindPlaylistResponse] from json map
  factory FindPlaylistResponse.fromJson(Map<String, dynamic> json) =>
      _$FindPlaylistResponseFromJson(json);

  /// Creates a json map from a [FindPlaylistResponse]
  Map<String, dynamic> toJson() => _$FindPlaylistResponseToJson(this);
}

@JsonSerializable()

/// Find playlist ids API response
///
/// The response returned upon the execution of a find playlist ids API call
/// When [FindPlaylistIdsResponse.error] is *not null* there was an error in the find playlist ids call
/// When [FindPlaylistIdsResponse.error] is *null* the [FindPlaylistIdsResponse.ids] has the returned playlist ids
class FindPlaylistIdsResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Playlists')

  /// The total number of playlist ids
  final int total;

  @JsonKey(name: 'Results')

  /// The list of playlist ids returned
  final List<String>? ids;

  @override
  List get props {
    return [total, ids, error];
  }

  /// Builds a [FindPlaylistIdsResponse]
  ///
  /// [total]: The total number of playlist ids returned
  /// [ids]: The list of ids
  /// [error]: An error if there was error while fetching the playlist ids
  FindPlaylistIdsResponse({int? count, this.ids, ResponseError? error})
      : total = count ?? ids?.length ?? 0,
        super(error: error);

  /// Creates a [FindPlaylistIdsResponse] from json map
  factory FindPlaylistIdsResponse.fromJson(Map<String, dynamic> json) =>
      _$FindPlaylistIdsResponseFromJson(json);

  /// Creates a json map from a [FindPlaylistIdsResponse]
  Map<String, dynamic> toJson() => _$FindPlaylistIdsResponseToJson(this);
}

@JsonSerializable()

/// Find playlists API response
///
/// The response returned upon the execution of a find playlists API call
/// When [FindPlaylistsResponse.error] is *not null* there was an error in the find playlists call
/// When [FindPlaylistsResponse.error] is *null* the [FindPlaylistsResponse.playlists] has the returned playlists
class FindPlaylistsResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Playlists')

  /// The total number of playlists
  final int total;

  @JsonKey(name: 'Results')

  /// The list of playlists returned
  final List<FindPlaylistResponse>? playlists;

  @override
  List get props {
    return [total, playlists, error];
  }

  /// Builds a [FindPlaylistsResponse]
  ///
  /// [total]: The total number of playlists returned
  /// [playlists]: The list of [Playlist]
  /// [error]: An error if there was error while fetching the playlists
  FindPlaylistsResponse({int? total, this.playlists, ResponseError? error})
      : total = total ?? playlists?.length ?? 0,
        super(error: error);

  /// Creates a [FindPlaylistsResponse] from json map
  factory FindPlaylistsResponse.fromJson(Map<String, dynamic> json) =>
      _$FindPlaylistsResponseFromJson(json);

  /// Creates a json map from a [FindPlaylistsResponse]
  Map<String, dynamic> toJson() => _$FindPlaylistsResponseToJson(this);
}

/// Save playlist API response
///
/// The response returned upon the execution of the save playlist API call
/// When [SavePlaylistResponse.error] is *not null* there was an error in the save playlist call
/// When [SavePlaylistResponse.error] is *null* the save was sucessful
class SavePlaylistResponse extends APIResponse with EquatableMixin {
  /// Builds a [SavePlaylistResponse]
  ///
  /// [error]: An error if there was error while saving the playlist
  SavePlaylistResponse({ResponseError? error}) : super(error: error);
}

/// Save playlist shaders API response
///
/// The response returned upon the execution of the save playlist shaders API call
/// When [SavePlaylistShadersResponse.error] is *not null* there was an error in the save shader comments call
/// When [SavePlaylistShadersResponse.error] is *null* the save was sucessful
class SavePlaylistShadersResponse extends APIResponse with EquatableMixin {
  /// Builds a [SavePlaylistShadersResponse]
  ///
  /// [error]: An error if there was error while saving the playlist shaders
  SavePlaylistShadersResponse({ResponseError? error}) : super(error: error);
}

/// Delete playlist API response
///
/// The response returned upon the execution of the delete playlist API call
/// When [DeletePlaylistResponse.error] is *not null* there was an error in the delete playlist call
/// When [DeletePlaylistResponse.error] is *null* the delete was sucessful
class DeletePlaylistResponse extends APIResponse with EquatableMixin {
  /// Builds a [DeletePlaylistResponse]
  ///
  /// [error]: An error if there was error while deleting the playlist
  DeletePlaylistResponse({ResponseError? error}) : super(error: error);
}

/// Download file API response
///
/// The response returned upon the execution of the download file API call
/// When [DownloadFileResponse.error] is *not null* there was an error in the donwload file call
/// When [DownloadFileResponse.error] is *null* the [DownloadFileResponse.bytes] has the bytes of the file
class DownloadFileResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Bytes')

  /// File bytes
  final List<int>? bytes;

  @override
  List get props {
    return [bytes, error];
  }

  /// Builds a [DownloadFileResponse]
  ///
  /// [bytes]: The bytes of the file
  /// [error]: An error if there was error while fetching the file
  DownloadFileResponse({this.bytes, ResponseError? error})
      : super(error: error);
}
