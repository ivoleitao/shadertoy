import 'response.dart';

/// Save shader comment API response
///
/// The response returned upon the execution of the save shader comment API call
/// When [SaveShaderCommentResponse.error] is *not null* there was an error in the save shader comment call
/// When [SaveShaderCommentResponse.error] is *null* the save was sucessful
class SaveShaderCommentResponse extends APIResponse {
  /// Builds a [SaveShaderCommentResponse]
  ///
  /// [error]: An error if there was error while saving the shader comments
  SaveShaderCommentResponse({super.error});
}
