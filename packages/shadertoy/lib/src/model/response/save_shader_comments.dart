import 'response.dart';

/// Save shader comments API response
///
/// The response returned upon the execution of the save shader comments API call
/// When [SaveShaderCommentsResponse.error] is *not null* there was an error in the save shader comments call
/// When [SaveShaderCommentsResponse.error] is *null* the save was sucessful
class SaveShaderCommentsResponse extends APIResponse {
  /// Builds a [SaveShaderCommentsResponse]
  ///
  /// [error]: An error if there was error while saving the shader comments
  SaveShaderCommentsResponse({super.error});
}
