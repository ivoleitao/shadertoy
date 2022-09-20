import 'package:equatable/equatable.dart';
import 'package:shadertoy/src/model/response/error.dart';

import 'response.dart';

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
