import 'package:shadertoy/src/model/response/error.dart';

import 'response.dart';

/// Delete playlist API response
///
/// The response returned upon the execution of the delete playlist API call
/// When [DeletePlaylistResponse.error] is *not null* there was an error in the delete playlist call
/// When [DeletePlaylistResponse.error] is *null* the delete was sucessful
class DeletePlaylistResponse extends APIResponse {
  /// Builds a [DeletePlaylistResponse]
  ///
  /// [error]: An error if there was error while deleting the playlist
  DeletePlaylistResponse({ResponseError? error}) : super(error: error);
}
