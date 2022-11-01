import 'response.dart';

/// Save syncs API response
///
/// The response returned upon the execution of the save syncs API call
/// When [SaveSyncsResponse.fail] is *null* the save was sucessful
class SaveSyncsResponse extends APIResponse {
  /// Builds a [SaveSyncsResponse]
  ///
  /// [error]: An error if there was error while saving the sync
  SaveSyncsResponse({super.error});
}
