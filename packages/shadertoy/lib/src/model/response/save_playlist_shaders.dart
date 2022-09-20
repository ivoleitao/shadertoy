import 'package:equatable/equatable.dart';
import 'package:shadertoy/src/model/response/error.dart';

import 'response.dart';

/// Save playlist shaders API response
///
/// The response returned upon the execution of the save playlist shaders API call
/// When [SavePlaylistShadersResponse.error] is *not null* there was an error in the save shader comments call
/// When [SavePlaylistShadersResponse.error] is *null* the save was sucessful
class SavePlaylistShadersResponse extends APIResponse with EquatableMixin {
  /// Builds a [SavePlaylistShadersResponse]
  ///
  /// [error]: An error if there was error while saving the playlist shaders
  SavePlaylistShadersResponse({ResponseError? error}) : super(error: error);
}
