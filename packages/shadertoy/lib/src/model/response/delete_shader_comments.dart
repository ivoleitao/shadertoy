import 'response.dart';

/// Delete shader comments API response
///
/// The response returned upon the execution of the save shader comments API call
/// When [DeleteShaderCommentsResponse.fail] is *not null* there was an error in the save shader comments call
/// When [DeleteShaderCommentsResponse.fail] is *null* the save was sucessful
class DeleteShaderCommentsResponse extends APIResponse {
  /// Builds a [DeleteShaderCommentsResponse]
  ///
  /// [error]: An error if there was error while saving the shader comments
  DeleteShaderCommentsResponse({super.error});
}
