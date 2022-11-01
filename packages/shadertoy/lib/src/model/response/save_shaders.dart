import 'response.dart';

/// Save shaders API response
///
/// The response returned upon the execution of the save shaders API call
/// When [SaveShadersResponse.error] is *not null* there was an error in the save shader call
/// When [SaveShadersResponse.error] is *null* the save was sucessful
class SaveShadersResponse extends APIResponse {
  /// Builds a [SaveShadersResponse]
  ///
  /// [error]: An error if there was error while saving the shader
  SaveShadersResponse({super.error});
}
