import 'response.dart';

/// Delete sync API response
///
/// The response returned upon the execution of the delete sync API call
/// When [DeleteSyncResponse.fail] is *not null* there was an error in the delete sync call
/// When [DeleteSyncResponse.fail] is *null* the delete was sucessful
class DeleteSyncResponse extends APIResponse {
  /// Builds a [DeleteSyncResponse]
  ///
  /// [error]: An error if there was error while deleting the sync
  DeleteSyncResponse({super.error});
}
