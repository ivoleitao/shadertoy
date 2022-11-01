import 'response.dart';

/// Delete shader API response
///
/// The response returned upon the execution of the delete shader API call
/// When [DeleteShaderResponse.fail] is *not null* there was an error in the delete shader call
/// When [DeleteShaderResponse.fail] is *null* the delete was sucessful
class DeleteShaderResponse extends APIResponse {
  /// Builds a [DeleteShaderResponse]
  ///
  /// [error]: An error if there was error while deleting the shader
  DeleteShaderResponse({super.error});
}
