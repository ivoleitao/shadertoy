import 'response.dart';

/// Save shader API response
///
/// The response returned upon the execution of the save shader API call
/// When [SaveShaderResponse.fail] is *not null* there was an error in the save shader call
/// When [SaveShaderResponse.fail] is *null* the save was sucessful
class SaveShaderResponse extends APIResponse {
  /// Builds a [SaveShaderResponse]
  ///
  /// [error]: An error if there was error while saving the shader
  SaveShaderResponse({super.error});
}
