import 'response.dart';

/// Save playlist shaders API response
///
/// The response returned upon the execution of the save playlist shaders API call
/// When [SavePlaylistShadersResponse.fail] is *not null* there was an error in the save shader comments call
/// When [SavePlaylistShadersResponse.fail] is *null* the save was sucessful
class SavePlaylistShadersResponse extends APIResponse {
  /// Builds a [SavePlaylistShadersResponse]
  ///
  /// [error]: An error if there was error while saving the playlist shaders
  SavePlaylistShadersResponse({super.error});
}
