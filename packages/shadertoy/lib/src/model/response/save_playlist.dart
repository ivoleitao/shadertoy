import 'response.dart';

/// Save playlist API response
///
/// The response returned upon the execution of the save playlist API call
/// When [SavePlaylistResponse.error] is *not null* there was an error in the save playlist call
/// When [SavePlaylistResponse.error] is *null* the save was sucessful
class SavePlaylistResponse extends APIResponse {
  /// Builds a [SavePlaylistResponse]
  ///
  /// [error]: An error if there was error while saving the playlist
  SavePlaylistResponse({super.error});
}
