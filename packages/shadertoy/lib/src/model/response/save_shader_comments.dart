import 'package:equatable/equatable.dart';
import 'package:shadertoy/src/model/response/error.dart';

import 'response.dart';

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
