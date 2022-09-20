import 'package:equatable/equatable.dart';
import 'package:shadertoy/src/model/response/error.dart';

import 'response.dart';

/// Delete sync API response
///
/// The response returned upon the execution of the delete sync API call
/// When [DeleteSyncResponse.error] is *not null* there was an error in the delete sync call
/// When [DeleteSyncResponse.error] is *null* the delete was sucessful
class DeleteSyncResponse extends APIResponse with EquatableMixin {
  /// Builds a [DeleteSyncResponse]
  ///
  /// [error]: An error if there was error while deleting the sync
  DeleteSyncResponse({ResponseError? error}) : super(error: error);
}
