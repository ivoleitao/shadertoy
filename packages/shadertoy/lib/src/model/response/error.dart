import 'package:equatable/equatable.dart';

/// The list of errors
enum ErrorCode {
  /// Authentication error
  authentication,

  /// Authorization error
  authorization,

  /// Backend timeout error
  backendTimeout,

  /// Backend status error
  backendStatus,

  /// Invalid backend response error
  backendResponse,

  /// Not found error
  notFound,

  /// Operation aborted error
  aborted,

  /// Conflict error
  conflict,

  /// Unprocessable error
  unprocessableEntity,

  /// Unknowkn error
  unknown
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

  /// Builds a authentication [ResponseError] with [ErrorCode.authentication] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.authentication(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.authentication,
            message: message,
            context: context,
            target: target);

  /// Builds a authorization [ResponseError] with [ErrorCode.authorization] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.authorization(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.authorization,
            message: message,
            context: context,
            target: target);

  /// Builds a backend timeout [ResponseError] with [ErrorCode.backendTimeout] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.backendTimeout(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.backendTimeout,
            message: message,
            context: context,
            target: target);

  /// Builds a backend status [ResponseError] with [ErrorCode.backendStatus] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.backendStatus(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.backendStatus,
            message: message,
            context: context,
            target: target);

  /// Builds a backend response [ResponseError] with [ErrorCode.backendResponse] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.backendResponse(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.backendResponse,
            message: message,
            context: context,
            target: target);

  /// Builds a not found [ResponseError] with [ErrorCode.notFound] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.notFound(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.notFound,
            message: message,
            context: context,
            target: target);

  /// Builds a aborted [ResponseError] with [ErrorCode.aborted] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.aborted(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.aborted,
            message: message,
            context: context,
            target: target);

  /// Builds a unprocessable entity [ResponseError] with [ErrorCode.unprocessableEntity] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.unprocessableEntity(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.unprocessableEntity,
            message: message,
            context: context,
            target: target);

  /// Builds a conflict [ResponseError] with [ErrorCode.conflict] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.conflict(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.conflict,
            message: message,
            context: context,
            target: target);

  /// Builds a unknown [ResponseError] with [ErrorCode.unknown] and:
  ///
  /// * [message]: The error message
  /// * [context]: The context of execution when the error ocurred
  /// * [target]: The target entity of the API that triggered this error
  ResponseError.unknown(
      {required String message, String? context, String? target})
      : this(
            code: ErrorCode.unknown,
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
          (e) => e.toString() == 'ErrorCode.${json['code'] as String}'),
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
