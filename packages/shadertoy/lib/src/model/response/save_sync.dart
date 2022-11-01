import 'response.dart';

/// Save sync API response
///
/// The response returned upon the execution of the save sync API call
/// When [SaveSyncResponse.fail] is *not null* there was an error in the save sync call
/// When [SaveSyncResponse.fail] is *null* the save was sucessful
class SaveSyncResponse extends APIResponse {
  /// Builds a [SaveSyncResponse]
  ///
  /// [error]: An error if there was error while saving the sync
  SaveSyncResponse({super.error});
}
